import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';

class SystemNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int _id = 0;

  Future<void> initialize() async {
    try {
      final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
        defaultActionName: 'Open Pomodoro',
        defaultIcon: AssetsLinuxIcon('assets/images/pomodoro_app_icon_red.png'),
      );

      final InitializationSettings initializationSettings = InitializationSettings(linux: initializationSettingsLinux);

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      print('Error initializing notifications: ${e.toString()}');
    }
  }

  Future<void> showNotification({required String title, String? body, String? iconPath}) async {
    final icon = iconPath != null ? AssetsLinuxIcon(iconPath) : null;

    final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
      location: const LinuxNotificationLocation(10, 10),
      icon: icon,
    );

    final NotificationDetails notificationDetails = NotificationDetails(linux: linuxPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(_id++, title, body, notificationDetails);
  }

  Future<void> showStateChangeNotification(SessionState newState, SessionState? previousState) async {
    final title = _getStateChangeTitle(newState, previousState);
    final body = _getStateChangeBody(newState);
    final iconPath = newState.icon();

    await showNotification(title: title, body: body, iconPath: iconPath);
  }

  Future<void> showSessionCompleteNotification(SessionState completedState) async {
    final title = _getSessionCompleteTitle(completedState);
    final body = _getSessionCompleteBody(completedState);
    final iconPath = completedState.next().icon(); // Иконка следующего состояния

    await showNotification(title: title, body: body, iconPath: iconPath);
  }

  String _getStateChangeTitle(SessionState newState, SessionState? previousState) {
    final l10n = L10n();
    switch (newState) {
      case SessionState.activity:
        return l10n.safeGetText((t) => t.notification_activity_title, 'Pomodoro - Work Time! 🍅');
      case SessionState.rest:
        return l10n.safeGetText((t) => t.notification_rest_title, 'Pomodoro - Break Time! ☕');
      case SessionState.inactivity:
        return l10n.safeGetText((t) => t.notification_inactivity_title, 'Pomodoro - Stopped');
    }
  }

  String _getStateChangeBody(SessionState state) {
    final l10n = L10n();
    switch (state) {
      case SessionState.activity:
        return l10n.safeGetText((t) => t.notification_activity_body, 'Work session is starting. Focus on your task!');
      case SessionState.rest:
        return l10n.safeGetText((t) => t.notification_rest_body, 'Break is starting. Relax and rest!');
      case SessionState.inactivity:
        return l10n.safeGetText(
          (t) => t.notification_inactivity_body,
          'Timer is stopped. Ready to start a new session?',
        );
    }
  }

  String _getSessionCompleteTitle(SessionState completedState) {
    final l10n = L10n();
    switch (completedState) {
      case SessionState.activity:
        return l10n.safeGetText((t) => t.notification_activity_complete_title, 'Work session completed! ✅');
      case SessionState.rest:
        return l10n.safeGetText((t) => t.notification_rest_complete_title, 'Break completed! 🔄');
      case SessionState.inactivity:
        return l10n.safeGetText((t) => t.notification_inactivity_complete_title, 'Session completed');
    }
  }

  String _getSessionCompleteBody(SessionState completedState) {
    final l10n = L10n();
    switch (completedState) {
      case SessionState.activity:
        return l10n.safeGetText(
          (t) => t.notification_activity_complete_body,
          'Great work! Time for a well-deserved break.',
        );
      case SessionState.rest:
        return l10n.safeGetText(
          (t) => t.notification_rest_complete_body,
          'Rest is over. Ready for a new work session?',
        );
      case SessionState.inactivity:
        return l10n.safeGetText((t) => t.notification_inactivity_complete_body, 'Ready to start a new session?');
    }
  }
}
