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
    switch (newState) {
      case SessionState.activity:
        return L10n().t.notification_activity_title;
      case SessionState.rest:
        return L10n().t.notification_rest_title;
      case SessionState.inactivity:
        return L10n().t.notification_inactivity_title;
    }
  }

  String _getStateChangeBody(SessionState state) {
    switch (state) {
      case SessionState.activity:
        return L10n().t.notification_activity_body;
      case SessionState.rest:
        return L10n().t.notification_rest_body;
      case SessionState.inactivity:
        return L10n().t.notification_inactivity_body;
    }
  }

  String _getSessionCompleteTitle(SessionState completedState) {
    switch (completedState) {
      case SessionState.activity:
        return L10n().t.notification_activity_complete_title;
      case SessionState.rest:
        return L10n().t.notification_rest_complete_title;
      case SessionState.inactivity:
        return L10n().t.notification_inactivity_complete_title;
    }
  }

  String _getSessionCompleteBody(SessionState completedState) {
    switch (completedState) {
      case SessionState.activity:
        return L10n().t.notification_activity_complete_body;
      case SessionState.rest:
        return L10n().t.notification_rest_complete_body;
      case SessionState.inactivity:
        return L10n().t.notification_inactivity_complete_body;
    }
  }
}
