import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/widgets/app.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await SystemNotificationService().initialize();
  runApp(const ProviderScope(child: App()));
}
