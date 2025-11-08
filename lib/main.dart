import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/app_initializer.dart';
import 'package:pomodoro_sczuw/widgets/app.dart';

void main() async {
  await AppInitializer.init();
  
  runApp(const ProviderScope(child: App()));
}
