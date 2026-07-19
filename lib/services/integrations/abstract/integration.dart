import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';

/// Pluggable outbound integration (ESP32, Telegram, webhooks, Home Assistant, ...).
///
/// Implementations must not throw out of [handle] — swallow and log their own
/// errors so the timer / UI flow is never blocked. Integrations may ignore
/// event types they do not care about.
abstract class Integration {
  String get id;

  Future<void> handle(IntegrationEvent event);

  Future<void> dispose();
}
