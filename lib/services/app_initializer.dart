import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/services/android/android_foreground_controller.dart';
import 'package:pomodoro_sczuw/services/hive_service.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';
import 'package:pomodoro_sczuw/utils/platform_support.dart';
import 'package:window_manager/window_manager.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      await AndroidForegroundController.initCommunicationPort();
    }

    if (isDesktop) {
      await windowManager.ensureInitialized();
    }

    await SystemNotificationService.instance.initialize();

    if (Platform.isAndroid) {
      await AndroidForegroundController.initPlugin();
    }

    await HiveService.init();
  }
}
