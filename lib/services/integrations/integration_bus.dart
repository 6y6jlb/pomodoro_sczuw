import 'dart:async';

import 'package:pomodoro_sczuw/services/integrations/abstract/integration.dart';
import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';

/// Fans out [IntegrationEvent]s to every registered [Integration].
///
/// Publishing is fire-and-forget: each handler runs independently and errors
/// are isolated so one broken integration cannot affect others or the timer.
class IntegrationBus {
  final List<Integration> _integrations;

  IntegrationBus(this._integrations);

  void publish(IntegrationEvent event) {
    for (final integration in _integrations) {
      unawaited(_dispatch(integration, event));
    }
  }

  Future<void> _dispatch(Integration integration, IntegrationEvent event) async {
    try {
      await integration.handle(event);
    } catch (_) {}
  }

  Future<void> dispose() async {
    for (final integration in _integrations) {
      await integration.dispose();
    }
  }
}
