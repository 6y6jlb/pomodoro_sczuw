import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/services/system_notification_service.dart';
import 'package:pomodoro_sczuw/providers/service_providers.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

class NotificationNotifier extends Notifier<void> {
  late final SystemNotificationService _systemNotificationService;

  @override
  void build() {
    _systemNotificationService = ref.read(systemNotificationServiceProvider);
  }

  Future<void> showStateChangeNotification(SessionState newState, SessionState? previousState) async {
    await _systemNotificationService.showStateChangeNotification(newState, previousState);
  }

  Future<void> showSessionCompleteNotification(SessionState completedState) async {
    await _systemNotificationService.showSessionCompleteNotification(completedState);
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, void>(() {
  return NotificationNotifier();
});
