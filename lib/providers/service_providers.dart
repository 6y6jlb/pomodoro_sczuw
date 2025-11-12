import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/services/sound_service.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';

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

final systemNotificationServiceProvider = Provider<SystemNotificationService>((ref) {
  return SystemNotificationService();
});
