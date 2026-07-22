import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/sound_event.dart';
import 'package:pomodoro_sczuw/enums/user_action.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';
import 'package:pomodoro_sczuw/providers/pomodoro_settings_provider.dart';
import 'package:pomodoro_sczuw/providers/service_providers.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';
import 'package:pomodoro_sczuw/services/android/android_foreground_action.dart';
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

  PomodoroSettings _settingsOrInitial() {
    return ref.read(pomodoroSettingsProvider).value ?? PomodoroSettings.initial();
  }

  void _playUserActionSound() {
    ref.read(soundServiceProvider).playForEvent(SoundEvent.userAction, _settingsOrInitial());
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
    _playUserActionSound();
  }

  void changeStateToInactivity() {
    _publishUserAction(UserAction.inactivity);
    ref.read(timerProvider.notifier).changeStateToInactivity();
    _playUserActionSound();
  }

  Future<void> start() async {
    _publishUserAction(UserAction.start);
    await ref.read(timerProvider.notifier).start();
    _playUserActionSound();
  }

  Future<void> pause() async {
    _publishUserAction(UserAction.pause);
    await ref.read(timerProvider.notifier).pause();
    _playUserActionSound();
  }

  Future<void> postpone(int duration) async {
    _publishUserAction(UserAction.postpone, durationSeconds: duration);
    await ref.read(timerProvider.notifier).postpone(duration);
    _playUserActionSound();
  }

  Future<void> resume() async {
    _publishUserAction(UserAction.resume);
    await ref.read(timerProvider.notifier).resume();
    _playUserActionSound();
  }

  Future<void> stop() async {
    _publishUserAction(UserAction.stop);
    await ref.read(timerProvider.notifier).stop();
    _playUserActionSound();
  }

  Future<void> reset() async {
    _publishUserAction(UserAction.reset);
    await ref.read(timerProvider.notifier).reset();
    _playUserActionSound();
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, PomodoroSession>(() {
  return SessionNotifier();
});

SoundEvent _soundEventForState(SessionState state) {
  switch (state) {
    case SessionState.activity:
      return SoundEvent.stateActivity;
    case SessionState.rest:
      return SoundEvent.stateRest;
    case SessionState.inactivity:
      return SoundEvent.stateInactivity;
  }
}

final pomodoroSessionManagerProvider = Provider<PomodoroSessionManager>((ref) {
  final timerService = ref.read(timerServiceProvider);
  final soundService = ref.read(soundServiceProvider);
  final restOverlayService = ref.read(restOverlayServiceProvider);

  final settingsAsync = ref.read(pomodoroSettingsProvider);
  final initialSettings = settingsAsync.when(
    data: (value) => value,
    loading: () => PomodoroSettings.initial(),
    error: (error, stack) => PomodoroSettings.initial(),
  );

  final sessionManager = PomodoroSessionManager(timerService, soundService, initialSettings);
  final notificationService = ref.read(systemNotificationServiceProvider);
  final integrationBus = ref.read(integrationBusProvider);
  final androidForeground = Platform.isAndroid ? ref.read(androidForegroundControllerProvider) : null;

  if (androidForeground != null) {
    androidForeground.onAction = (action) {
      final notifier = ref.read(sessionProvider.notifier);
      switch (action) {
        case AndroidForegroundAction.pause:
          notifier.pause();
        case AndroidForegroundAction.resume:
          notifier.resume();
        case AndroidForegroundAction.stop:
          notifier.changeStateToInactivity();
      }
    };
  }

  void updateAndroidForeground(PomodoroSession session) {
    if (androidForeground == null) return;
    if (session.state.hasTimer()) {
      androidForeground.updateSession(session);
    } else {
      androidForeground.stopSession();
    }
  }

  ref.listen(pomodoroSettingsProvider, (previous, next) {
    if (!next.hasValue) return;

    final settings = next.requireValue;
    sessionManager.updateSettings(settings);

    final wasEnabled = previous?.value?.restOverlayEnabled ?? false;
    if (wasEnabled && !settings.restOverlayEnabled && restOverlayService.isVisible) {
      restOverlayService.hide();
    }
  });

  sessionManager.onStateChanged = (newState, previousState) {
    try {
      notificationService.showStateChangeNotification(newState, previousState);
    } catch (e) {
      print('Error sending state change notification: $e');
    }

    try {
      soundService.playForEvent(_soundEventForState(newState), sessionManager.settings);
    } catch (e) {
      print('Error playing state change sound: $e');
    }

    final overlayEnabled = sessionManager.settings.restOverlayEnabled;
    if (overlayEnabled && newState == SessionState.rest) {
      restOverlayService.show();
    } else if (restOverlayService.isVisible && newState != SessionState.rest) {
      restOverlayService.hide();
    }

    updateAndroidForeground(sessionManager.currentSession);

    integrationBus.publish(
      SessionStatusChanged(
        from: previousState ?? newState,
        to: newState,
        session: sessionManager.currentSession,
      ),
    );
  };

  sessionManager.onSessionPaused = () {
    updateAndroidForeground(sessionManager.currentSession);
    integrationBus.publish(
      SessionPaused(
        state: sessionManager.currentSession.state,
        session: sessionManager.currentSession,
      ),
    );
  };

  sessionManager.onSessionResumed = () {
    updateAndroidForeground(sessionManager.currentSession);
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
    if (androidForeground != null) {
      androidForeground.onAction = null;
    }
    sessionManager.dispose();
  });

  return sessionManager;
});
