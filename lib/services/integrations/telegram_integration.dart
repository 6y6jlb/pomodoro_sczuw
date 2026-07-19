import 'package:dio/dio.dart';
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
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 5),
               receiveTimeout: const Duration(seconds: 5),
               sendTimeout: const Duration(seconds: 5),
             ),
           );

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
      return e.toString();
    }
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
