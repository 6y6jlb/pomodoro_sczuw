import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';

// Провайдер для TimerService - здесь можно переключаться между разными реализациями
final timerServiceProvider = Provider<TimerService>((ref) {
  return DesktopTimerService();
});
