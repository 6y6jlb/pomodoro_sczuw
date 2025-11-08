import 'package:pomodoro_sczuw/services/hive_service.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';

class AppInitializer {
  static Future<void> init() async {
     WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    await SystemNotificationService().initialize();
    await HiveService.init();
  }
}