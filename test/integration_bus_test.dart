import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/user_action.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/integrations/abstract/integration.dart';
import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';
import 'package:pomodoro_sczuw/services/integrations/integration_bus.dart';

class _RecordingIntegration implements Integration {
  final List<IntegrationEvent> events = [];

  @override
  String get id => 'recording';

  @override
  Future<void> handle(IntegrationEvent event) async {
    events.add(event);
  }

  @override
  Future<void> dispose() async {}
}

class _ThrowingIntegration implements Integration {
  @override
  String get id => 'throwing';

  @override
  Future<void> handle(IntegrationEvent event) async {
    throw StateError('boom');
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  test('publishes events to every registered integration', () async {
    final first = _RecordingIntegration();
    final second = _RecordingIntegration();
    final bus = IntegrationBus([first, second]);

    bus.publish(const UserActionPressed(action: UserAction.pause));
    await Future<void>.delayed(Duration.zero);

    expect(first.events, hasLength(1));
    expect(second.events, hasLength(1));
    expect(first.events.single, isA<UserActionPressed>());
  });

  test('isolates errors so other integrations still receive events', () async {
    final recording = _RecordingIntegration();
    final bus = IntegrationBus([_ThrowingIntegration(), recording]);

    bus.publish(
      SessionStatusChanged(
        from: SessionState.inactivity,
        to: SessionState.activity,
        session: PomodoroSession.initial(),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(recording.events, hasLength(1));
    expect(recording.events.single, isA<SessionStatusChanged>());
  });
}
