import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/providers/pomodoro_settings_provider.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/services/integrations/esp32_led_integration.dart';
import 'package:pomodoro_sczuw/services/integrations/integration_bus.dart';
import 'package:pomodoro_sczuw/services/integrations/telegram_integration.dart';
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
    TelegramIntegration(
      credentialsProvider: () {
        final settings = ref.read(pomodoroSettingsProvider).value;
        return TelegramCredentials(
          enabled: settings?.telegramEnabled ?? false,
          botToken: settings?.telegramBotToken ?? '',
          chatId: settings?.telegramChatId ?? '',
        );
      },
    ),
  ]);

  ref.onDispose(() {
    bus.dispose();
  });

  return bus;
});
