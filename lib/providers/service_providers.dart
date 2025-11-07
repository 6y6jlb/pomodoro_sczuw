import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';


final timerServiceProvider = Provider<TimerService>((ref) {
  return DesktopTimerService(); //TODO: another implementations
});


final systemNotificationServiceProvider = Provider<SystemNotificationService>((ref) {
  return SystemNotificationService();
});