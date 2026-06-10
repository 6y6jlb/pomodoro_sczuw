import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/services/sound_service.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';
import 'package:pomodoro_sczuw/services/side_effects/side_effect_manager.dart';
import 'package:pomodoro_sczuw/services/side_effects/esp32_led_side_effect.dart';
import 'package:pomodoro_sczuw/utils/consts/side_effect_constant.dart';

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

final sideEffectManagerProvider = Provider<SideEffectManager>((ref) {
  final manager = SideEffectManager([Esp32LedSideEffect(baseUrl: SideEffectConstant.esp32BaseUrl)]);

  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
});
