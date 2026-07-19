import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/user_action.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';
import 'package:pomodoro_sczuw/providers/pomodoro_settings_provider.dart';
import 'package:pomodoro_sczuw/providers/service_providers.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';
import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';
import 'package:pomodoro_sczuw/services/pomodoro_session_manager.dart';

class SessionNotifier extends Notifier<PomodoroSession> {
  @override
  PomodoroSession build() {
    final timerAsyncValue = ref.watch(timerProvider);

    return timerAsyncValue.when(
      data: (session) => session,
      loading: () => PomodoroSession.initial(),
      error: (error, stack) => PomodoroSession.initial(),
    );
  }

  void _publishUserAction(UserAction action, {int? durationSeconds}) {
    ref.read(integrationBusProvider).publish(
      UserActionPressed(action: action, durationSeconds: durationSeconds),
    );
  }

  void changeState(SessionState newState) {
    ref.read(timerProvider.notifier).changeState(newState);
  }

  void changeStateToNext() {
    _publishUserAction(UserAction.next);
    ref.read(timerProvider.notifier).changeStateToNext();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  void changeStateToInactivity() {
    _publishUserAction(UserAction.inactivity);
    ref.read(timerProvider.notifier).changeStateToInactivity();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> start() async {
    _publishUserAction(UserAction.start);
    await ref.read(timerProvider.notifier).start();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> pause() async {
    _publishUserAction(UserAction.pause);
    await ref.read(timerProvider.notifier).pause();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> postpone(int duration) async {
    _publishUserAction(UserAction.postpone, durationSeconds: duration);
    await ref.read(timerProvider.notifier).postpone(duration);
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> resume() async {
    _publishUserAction(UserAction.resume);
    await ref.read(timerProvider.notifier).resume();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> stop() async {
    _publishUserAction(UserAction.stop);
    await ref.read(timerProvider.notifier).stop();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> reset() async {
    _publishUserAction(UserAction.reset);
    await ref.read(timerProvider.notifier).reset();
    ref.read(soundServiceProvider).playSound('toggle');
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, PomodoroSession>(() {
  return SessionNotifier();
});

final pomodoroSessionManagerProvider = Provider<PomodoroSessionManager>((ref) {
  final timerService = ref.read(timerServiceProvider);
  final soundService = ref.read(soundServiceProvider);

  final settingsAsync = ref.read(pomodoroSettingsProvider);
  final initialSettings = settingsAsync.when(
    data: (value) => value,
    loading: () => PomodoroSettings.initial(),
    error: (error, stack) => PomodoroSettings.initial(),
  );

  final sessionManager = PomodoroSessionManager(timerService, soundService, initialSettings);
  final notificationService = ref.read(systemNotificationServiceProvider);
  final integrationBus = ref.read(integrationBusProvider);

  ref.listen(pomodoroSettingsProvider, (previous, next) {
    if (next.hasValue) {
      sessionManager.updateSettings(next.requireValue);
    }
  });

  sessionManager.onStateChanged = (newState, previousState) {
    try {
      notificationService.showStateChangeNotification(newState, previousState);
    } catch (e) {
      print('Error sending state change notification: $e');
    }
    integrationBus.publish(
      SessionStatusChanged(
        from: previousState ?? newState,
        to: newState,
        session: sessionManager.currentSession,
      ),
    );
  };

  sessionManager.onSessionPaused = () {
    integrationBus.publish(
      SessionPaused(
        state: sessionManager.currentSession.state,
        session: sessionManager.currentSession,
      ),
    );
  };

  sessionManager.onSessionResumed = () {
    integrationBus.publish(
      SessionResumed(
        state: sessionManager.currentSession.state,
        session: sessionManager.currentSession,
      ),
    );
  };

  sessionManager.onSessionCompleted = (completedState) {
    try {
      notificationService.showSessionCompleteNotification(completedState);
    } catch (e) {
      print('Error sending session complete notification: $e');
    }
    integrationBus.publish(
      SessionCompleted(
        completedState: completedState,
        session: sessionManager.currentSession,
      ),
    );
  };

  ref.onDispose(() {
    sessionManager.dispose();
  });

  return sessionManager;
});
