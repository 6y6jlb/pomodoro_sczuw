import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/providers/pomodoro_settings_provider.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/android/android_foreground_controller.dart';
import 'package:pomodoro_sczuw/services/android_timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/services/integrations/integration_bus.dart';
import 'package:pomodoro_sczuw/services/integrations/telegram_integration.dart';
import 'package:pomodoro_sczuw/services/rest_overlay_service.dart';
import 'package:pomodoro_sczuw/services/sound_service.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';

final androidForegroundControllerProvider = Provider<AndroidForegroundController>((ref) {
  final controller = AndroidForegroundController();
  controller.ensureTaskDataCallbackRegistered();

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});

final timerServiceProvider = Provider<TimerService>((ref) {
  if (Platform.isAndroid) {
    return AndroidTimerService(
      foregroundController: ref.read(androidForegroundControllerProvider),
    );
  }
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
  return SystemNotificationService.instance;
});

final restOverlayServiceProvider = Provider<RestOverlayService>((ref) {
  final service = RestOverlayService();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

final integrationBusProvider = Provider<IntegrationBus>((ref) {
  final bus = IntegrationBus([
    // Esp32LedIntegration(baseUrl: IntegrationConstant.esp32BaseUrl),
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
