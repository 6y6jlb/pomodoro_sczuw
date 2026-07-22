import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/user_action.dart';
import 'package:pomodoro_sczuw/services/integrations/abstract/integration.dart';
import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';

class TelegramCredentials {
  final bool enabled;
  final String botToken;
  final String chatId;

  const TelegramCredentials({
    required this.enabled,
    required this.botToken,
    required this.chatId,
  });

  bool get isConfigured =>
      enabled && botToken.trim().isNotEmpty && chatId.trim().isNotEmpty;
}

/// Sends personal Telegram messages for session lifecycle events.
///
/// Credentials come from [credentialsProvider] on each send so Hive/settings
/// changes apply without recreating the integration bus.
/// Message text follows the current app locale via [L10n].
class TelegramIntegration implements Integration {
  final TelegramCredentials Function() credentialsProvider;
  final Dio _dio;

  TelegramIntegration({
    required this.credentialsProvider,
    Dio? dio,
  }) : _dio = dio ?? _createDefaultDio();

  static Dio _createDefaultDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
      ),
    );
    // Prefer IPv4: on some Android networks IPv6 to api.telegram.org hangs
    // until connectTimeout while IPv4 works.
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (_) => 'DIRECT';
        client.connectionFactory = (uri, proxyHost, proxyPort) async {
          final addresses = await InternetAddress.lookup(
            uri.host,
            type: InternetAddressType.IPv4,
          );
          if (addresses.isEmpty) {
            throw SocketException('Failed to resolve IPv4 for ${uri.host}');
          }
          return Socket.startConnect(addresses.first, uri.port);
        };
        return client;
      },
    );
    return dio;
  }

  @override
  String get id => 'telegram';

  @override
  Future<void> handle(IntegrationEvent event) async {
    final text = _messageForEvent(event);
    if (text == null) return;

    try {
      await sendMessage(text);
    } catch (_) {}
  }

  /// Posts [text] when credentials are configured. Throws on HTTP/network errors.
  Future<void> sendMessage(String text) async {
    final credentials = credentialsProvider();
    if (!credentials.isConfigured) return;

    final token = credentials.botToken.trim();
    final chatId = credentials.chatId.trim();
    await _dio.post(
      'https://api.telegram.org/bot$token/sendMessage',
      data: {
        'chat_id': chatId,
        'text': text,
      },
    );
  }

  /// Sends a test message; returns an error string, or null on success / skip.
  Future<String?> sendTestMessage() async {
    final credentials = credentialsProvider();
    if (!credentials.isConfigured) {
      return L10n().safeGetText(
        (t) => t.telegram_notConfigured,
        'Telegram is disabled or token/chat id is empty',
      );
    }

    try {
      await sendMessage(
        L10n().safeGetText((t) => t.telegram_test, 'Pomodoro: test'),
      );
      return null;
    } catch (e) {
      return _formatSendError(e);
    }
  }

  String _formatSendError(Object error) {
    if (error is DioException) {
      final apiDescription = _telegramApiDescription(error.response?.data);
      if (apiDescription != null) return apiDescription;

      return switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          L10n().safeGetText(
            (t) => t.telegram_timeout,
            'Connection timed out. Check network or VPN.',
          ),
        DioExceptionType.connectionError => L10n().safeGetText(
          (t) => t.telegram_connectionError,
          'Cannot reach Telegram API. Check network or VPN.',
        ),
        _ => L10n().safeGetText(
          (t) => t.telegram_requestFailed,
          'Request failed',
        ),
      };
    }

    return L10n().safeGetText(
      (t) => t.telegram_requestFailed,
      'Request failed',
    );
  }

  String? _telegramApiDescription(Object? data) {
    if (data is Map) {
      final description = data['description'];
      if (description is String && description.trim().isNotEmpty) {
        return description.trim();
      }
    }
    return null;
  }

  String? _messageForEvent(IntegrationEvent event) {
    return switch (event) {
      UserActionPressed(action: UserAction.start) => L10n().safeGetText(
        (t) => t.telegram_started,
        'Pomodoro: started',
      ),
      UserActionPressed(action: UserAction.stop) => L10n().safeGetText(
        (t) => t.telegram_stopped,
        'Pomodoro: stopped',
      ),
      UserActionPressed() => null,
      SessionStatusChanged(:final from, :final to) => _statusChangedMessage(from, to),
      SessionPaused(:final state) => L10n().safeGetText(
        (t) => t.telegram_paused(_stateLabel(state)),
        'Pomodoro: paused (${_stateLabel(state)})',
      ),
      SessionResumed(:final state) => L10n().safeGetText(
        (t) => t.telegram_resumed(_stateLabel(state)),
        'Pomodoro: resumed (${_stateLabel(state)})',
      ),
      SessionCompleted() || PageNavigated() => null,
    };
  }

  String _statusChangedMessage(SessionState from, SessionState to) {
    final fromLabel = _stateLabel(from);
    final toLabel = _stateLabel(to);
    return L10n().safeGetText(
      (t) => t.telegram_statusChanged(fromLabel, toLabel),
      'Pomodoro: $fromLabel → $toLabel',
    );
  }

  String _stateLabel(SessionState state) {
    return L10n().safeGetText(
      (t) => switch (state) {
        SessionState.activity => t.timerStateLabel_activity,
        SessionState.inactivity => t.timerStateLabel_inactivity,
        SessionState.rest => t.timerStateLabel_rest,
      },
      state.name,
    );
  }

  @override
  Future<void> dispose() async {
    _dio.close(force: true);
  }
}
