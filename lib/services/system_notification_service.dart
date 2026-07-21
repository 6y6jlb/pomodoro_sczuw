import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';

class SystemNotificationService {
  SystemNotificationService._();

  static final SystemNotificationService instance = SystemNotificationService._();

  factory SystemNotificationService() => instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int _id = 0;
  bool _initialized = false;

  static const String _windowsAppName = 'Pomodoro';
  static const String _windowsAppUserModelId = 'com.pomodoro_sczuw.app';
  static const String _windowsGuid = '4c474872-1b0f-42bd-95a2-df8f9d3d3665';

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final LinuxInitializationSettings initializationSettingsLinux =
          LinuxInitializationSettings(
        defaultActionName: 'Open Pomodoro',
        defaultIcon: AssetsLinuxIcon('assets/images/pomodoro_app_icon_red.png'),
      );

      final WindowsInitializationSettings initializationSettingsWindows =
          WindowsInitializationSettings(
        appName: _windowsAppName,
        appUserModelId: _windowsAppUserModelId,
        guid: _windowsGuid,
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        linux: initializationSettingsLinux,
        windows: initializationSettingsWindows,
      );

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
      _initialized = true;
    } catch (e) {
      print('Error initializing notifications: ${e.toString()}');
    }
  }

  Future<void> showNotification({required String title, String? body, String? iconPath}) async {
    final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
      location: const LinuxNotificationLocation(10, 10),
      icon: iconPath != null ? AssetsLinuxIcon(iconPath) : null,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
      windows: const WindowsNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(_id++, title, body, notificationDetails);
  }

  Future<void> showStateChangeNotification(SessionState newState, SessionState? previousState) async {
    final title = _getStateChangeTitle(newState, previousState);
    final body = _getStateChangeBody(newState);
    final iconPath = Platform.isLinux ? newState.icon() : null;

    await showNotification(title: title, body: body, iconPath: iconPath);
  }

  Future<void> showSessionCompleteNotification(SessionState completedState) async {
    final title = _getSessionCompleteTitle(completedState);
    final body = _getSessionCompleteBody(completedState);
    final iconPath = Platform.isLinux ? completedState.next().icon() : null;

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
