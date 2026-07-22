import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/user_action.dart';
import 'package:pomodoro_sczuw/l10n/app_localizations.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';
import 'package:pomodoro_sczuw/services/integrations/telegram_integration.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';

class _RecordingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  bool shouldFail = false;
  DioExceptionType? failType;
  Object? failResponseData;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (shouldFail) {
      throw DioException(
        requestOptions: options,
        type: failType ?? DioExceptionType.unknown,
        message: 'network error',
        response: failResponseData == null
            ? null
            : Response(
                requestOptions: options,
                data: failResponseData,
                statusCode: 400,
              ),
      );
    }
    return ResponseBody.fromString(
      '{"ok":true}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }
}

void main() {
  late _RecordingAdapter adapter;
  late Dio dio;
  late TelegramCredentials credentials;

  setUp(() async {
    adapter = _RecordingAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    credentials = const TelegramCredentials(
      enabled: true,
      botToken: 'test-token',
      chatId: '12345',
    );
    L10n().initializeWith(
      await AppLocalizations.delegate.load(const Locale('en')),
    );
  });

  TelegramIntegration createIntegration() {
    return TelegramIntegration(
      credentialsProvider: () => credentials,
      dio: dio,
    );
  }

  test('sends English messages for start, stop and status change', () async {
    final integration = createIntegration();

    await integration.handle(
      const UserActionPressed(action: UserAction.start),
    );
    await integration.handle(
      const UserActionPressed(action: UserAction.stop),
    );
    await integration.handle(
      SessionStatusChanged(
        from: SessionState.inactivity,
        to: SessionState.activity,
        session: PomodoroSession.initial(),
      ),
    );

    expect(adapter.requests, hasLength(3));
    expect(adapter.requests[0].data['text'], 'Pomodoro: started');
    expect(adapter.requests[1].data['text'], 'Pomodoro: stopped');
    expect(adapter.requests[2].data['text'], 'Pomodoro: Inactive → Active');

    await integration.dispose();
  });

  test('sends Russian messages when app locale is ru', () async {
    L10n().initializeWith(
      await AppLocalizations.delegate.load(const Locale('ru')),
    );
    final integration = createIntegration();

    await integration.handle(
      const UserActionPressed(action: UserAction.start),
    );
    await integration.handle(
      SessionStatusChanged(
        from: SessionState.activity,
        to: SessionState.rest,
        session: PomodoroSession.initial(),
      ),
    );
    await integration.handle(
      SessionPaused(
        state: SessionState.activity,
        session: PomodoroSession.initial(),
      ),
    );

    expect(adapter.requests[0].data['text'], 'Pomodoro: запуск');
    expect(adapter.requests[1].data['text'], 'Pomodoro: Активно → Перерыв');
    expect(adapter.requests[2].data['text'], 'Pomodoro: пауза (Активно)');

    await integration.dispose();
  });

  test('does not send when disabled or not configured', () async {
    credentials = const TelegramCredentials(
      enabled: false,
      botToken: 'test-token',
      chatId: '12345',
    );
    final disabled = createIntegration();
    await disabled.handle(const UserActionPressed(action: UserAction.start));
    expect(adapter.requests, isEmpty);
    await disabled.dispose();

    credentials = const TelegramCredentials(
      enabled: true,
      botToken: '',
      chatId: '12345',
    );
    final missingToken = createIntegration();
    await missingToken.handle(const UserActionPressed(action: UserAction.start));
    expect(adapter.requests, isEmpty);
    await missingToken.dispose();
  });

  test('sendTestMessage returns localized not-configured error', () async {
    L10n().initializeWith(
      await AppLocalizations.delegate.load(const Locale('ru')),
    );
    credentials = const TelegramCredentials(
      enabled: false,
      botToken: '',
      chatId: '',
    );
    final integration = createIntegration();

    final error = await integration.sendTestMessage();

    expect(error, 'Telegram выключен или не заполнены token/chat id');
    expect(adapter.requests, isEmpty);
    await integration.dispose();
  });

  test('sendTestMessage returns localized timeout error', () async {
    adapter.shouldFail = true;
    adapter.failType = DioExceptionType.connectionTimeout;
    final integration = createIntegration();

    final error = await integration.sendTestMessage();

    expect(error, 'Connection timed out. Check network or VPN.');
    expect(error, isNot(contains('DioException')));
    expect(adapter.requests, hasLength(1));
    await integration.dispose();
  });

  test('sendTestMessage returns Telegram API description when present', () async {
    adapter.shouldFail = true;
    adapter.failType = DioExceptionType.badResponse;
    adapter.failResponseData = {
      'ok': false,
      'description': 'Bad Request: chat not found',
    };
    final integration = createIntegration();

    final error = await integration.sendTestMessage();

    expect(error, 'Bad Request: chat not found');
    await integration.dispose();
  });
}
