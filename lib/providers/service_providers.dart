import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/services/pomodoro_session_manager.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';
import 'package:pomodoro_sczuw/services/sound_service.dart';
import 'package:pomodoro_sczuw/services/events_sound_service.dart';

final timerServiceProvider = Provider<TimerService>((ref) {
  return DesktopTimerService();
});

final soundServiceProvider = Provider<SoundService>((ref) {
  final soundService = SoundService();

  ref.onDispose(() {
    soundService.dispose();
  });

  return soundService;
});

final eventsSoundServiceProvider = Provider<EventsSoundService>((ref) {
  final soundService = ref.read(soundServiceProvider);
  return EventsSoundService(soundService);
});

final pomodoroSessionManagerProvider = Provider<PomodoroSessionManager>((ref) {
  final timerService = ref.read(timerServiceProvider);
  final eventsSoundService = ref.read(eventsSoundServiceProvider);
  final sessionManager = PomodoroSessionManager(timerService, eventsSoundService);
  final notificationService = ref.read(systemNotificationServiceProvider);

  sessionManager.onStateChanged = (newState, previousState) {
    try {
      notificationService.showStateChangeNotification(newState, previousState);
    } catch (e) {
      print('Error sending state change notification: $e');
    }
  };

  sessionManager.onSessionCompleted = (completedState) {
    try {
      notificationService.showSessionCompleteNotification(completedState);
    } catch (e) {
      print('Error sending session complete notification: $e');
    }
  };

  ref.onDispose(() {
    sessionManager.dispose();
  });

  return sessionManager;
});

final systemNotificationServiceProvider = Provider<SystemNotificationService>((ref) {
  return SystemNotificationService();
});
