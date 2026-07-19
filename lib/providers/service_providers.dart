import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/services/integrations/esp32_led_integration.dart';
import 'package:pomodoro_sczuw/services/integrations/integration_bus.dart';
import 'package:pomodoro_sczuw/services/sound_service.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';
import 'package:pomodoro_sczuw/utils/consts/integration_constant.dart';

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

final integrationBusProvider = Provider<IntegrationBus>((ref) {
  final bus = IntegrationBus([
    Esp32LedIntegration(baseUrl: IntegrationConstant.esp32BaseUrl),
    // TelegramIntegration(...), WebhookIntegration(...), HomeAssistantIntegration(...)
  ]);

  ref.onDispose(() {
    bus.dispose();
  });

  return bus;
});
