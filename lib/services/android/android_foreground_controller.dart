import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/android/android_foreground_action.dart';
import 'package:pomodoro_sczuw/services/android/android_foreground_task_handler.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';

class AndroidForegroundController {
  static const int _serviceId = 256;
  static const String _channelId = 'pomodoro_foreground';
  static const String _channelName = 'Pomodoro timer';
  static const String _actionPause = 'pause';
  static const String _actionResume = 'resume';
  static const String _actionStop = 'stop';

  static bool _pluginInitialized = false;

  void Function(AndroidForegroundAction action)? onAction;
  bool _taskDataCallbackRegistered = false;

  static Future<void> initCommunicationPort() async {
    if (!Platform.isAndroid) return;
    FlutterForegroundTask.initCommunicationPort();
  }

  /// Configures the plugin once at app startup (permissions + notification channel).
  static Future<void> initPlugin() async {
    if (!Platform.isAndroid || _pluginInitialized) return;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _channelId,
        channelName: _channelName,
        channelDescription: 'Ongoing Pomodoro timer while a session is active',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(60000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    final notificationPermission = await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    _pluginInitialized = true;
  }

  void ensureTaskDataCallbackRegistered() {
    if (_taskDataCallbackRegistered) return;
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    _taskDataCallbackRegistered = true;
  }

  void _onReceiveTaskData(Object data) {
    if (data is! Map) return;
    final actionId = data['action'];
    if (actionId is! String) return;

    final action = switch (actionId) {
      _actionPause => AndroidForegroundAction.pause,
      _actionResume => AndroidForegroundAction.resume,
      _actionStop => AndroidForegroundAction.stop,
      _ => null,
    };
    if (action != null) {
      onAction?.call(action);
    }
  }

  Future<void> updateSession(PomodoroSession session) async {
    if (!Platform.isAndroid) return;
    if (!_pluginInitialized) await initPlugin();
    ensureTaskDataCallbackRegistered();

    if (!session.state.hasTimer()) {
      await stopSession();
      return;
    }

    final title = _notificationTitle(session);
    final text = _formatTime(session.currentSeconds);
    final buttons = _notificationButtons(session);

    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
        notificationButtons: buttons,
      );
      return;
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    await FlutterForegroundTask.startService(
      serviceId: _serviceId,
      serviceTypes: [ForegroundServiceTypes.dataSync],
      notificationTitle: title,
      notificationText: text,
      notificationButtons: buttons,
      notificationInitialRoute: '/',
      callback: pomodoroForegroundStartCallback,
    );
  }

  Future<void> stopSession() async {
    if (!Platform.isAndroid) return;
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }

  List<NotificationButton> _notificationButtons(PomodoroSession session) {
    final l10n = L10n();
    final pauseLabel = l10n.safeGetText((t) => t.action_pause, 'Pause');
    final resumeLabel = l10n.safeGetText((t) => t.action_resume, 'Resume');
    final stopLabel = l10n.safeGetText((t) => t.action_stop, 'Stop');

    return [
      if (session.isPaused)
        NotificationButton(id: _actionResume, text: resumeLabel)
      else
        NotificationButton(id: _actionPause, text: pauseLabel),
      NotificationButton(id: _actionStop, text: stopLabel),
    ];
  }

  String _notificationTitle(PomodoroSession session) {
    final l10n = L10n();
    final stateLabel = l10n.safeGetText((t) {
      return switch (session.state) {
        SessionState.activity => t.timerStateLabel_activity,
        SessionState.rest => t.timerStateLabel_rest,
        SessionState.inactivity => t.timerStateLabel_inactivity,
      };
    }, session.state.name);

    if (session.isPaused) {
      final pausedLabel = l10n.safeGetText((t) => t.action_pause, 'Paused');
      return '$stateLabel · $pausedLabel';
    }
    return stateLabel;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> dispose() async {
    if (_taskDataCallbackRegistered) {
      FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
      _taskDataCallbackRegistered = false;
    }
    await stopSession();
    onAction = null;
  }
}
