// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get timerStateLabel_activity => 'Active';

  @override
  String get timerStateLabel_inactivity => 'Inactive';

  @override
  String get timerStateLabel_rest => 'Rest';

  @override
  String get timerStateLabel_unknown => 'Unknown';

  @override
  String get pomodoroModeLabel_custom => 'Custom';

  @override
  String get pomodoroModeLabel_schedule => 'Schedule';

  @override
  String get operationModeLabel => 'Mode:';

  @override
  String get sessionDurationLabel => 'Session duration:';

  @override
  String get action_stop => 'Stop';

  @override
  String get action_start => 'Start';

  @override
  String get action_continue => 'Continue';

  @override
  String get action_resume => 'Resume';

  @override
  String get action_postpone => '+5min';

  @override
  String get action_rest => 'Rest';

  @override
  String get action_break => 'Break';

  @override
  String get action_confirm => 'Confirm';

  @override
  String get action_pause => 'Pause';

  @override
  String get action_unknown => 'Unknown';

  @override
  String get unitShort_minute => 'min.';

  @override
  String get unitShort_seconds => 's.';

  @override
  String get unitShort_hours => 'h.';

  @override
  String get unitShort_days => 'd.';

  @override
  String get timerLabel => 'Timer';

  @override
  String get scheduleStateLabel_active => 'Schedule: active';

  @override
  String get scheduleStateLabel_inactive => 'Schedule: inactive';

  @override
  String get scheduleHasNotActiveDay => 'No active days in the schedule';

  @override
  String scheduleWillStartAt(Object day, Object time) {
    return 'Schedule will start: $day at $time';
  }

  @override
  String scheduleWillEndAt(Object time) {
    return 'Schedule will end: $time';
  }

  @override
  String get scheduleScheduleModeDescription => 'Set active days and hours - the timer will work only when needed.';

  @override
  String get scheduleCustomModeDescription => 'Choose the duration of work and rest without being tied to the schedule.';

  @override
  String get scheduleActiveDaysLabel => 'Active days:';

  @override
  String get scheduleActiveHoursLabel => 'Active hours:';

  @override
  String get scheduleExceptionsLabel => 'Exceptions:';

  @override
  String get scheduleExceptionAddLabel => 'Add exception';

  @override
  String get scheduleExceptionShowLabel => 'Show exception';

  @override
  String notification_stateChanged(Object state) {
    return 'State changed: $state';
  }

  @override
  String notification_exceptionAdded(Object day) {
    return 'Added exception for $day';
  }

  @override
  String get notification_activity_title => 'Pomodoro - Work Time! 🍅';

  @override
  String get notification_activity_body => 'Work session is starting. Focus on your task!';

  @override
  String get notification_rest_title => 'Pomodoro - Break Time! ☕';

  @override
  String get notification_rest_body => 'Break is starting. Relax and rest!';

  @override
  String get notification_inactivity_title => 'Pomodoro - Stopped';

  @override
  String get notification_inactivity_body => 'Timer is stopped. Ready to start a new session?';

  @override
  String get notification_activity_complete_title => 'Work session completed! ✅';

  @override
  String get notification_activity_complete_body => 'Great work! Time for a well-deserved break.';

  @override
  String get notification_rest_complete_title => 'Break completed! 🔄';

  @override
  String get notification_rest_complete_body => 'Rest is over. Ready for a new work session?';

  @override
  String get notification_inactivity_complete_title => 'Session completed';

  @override
  String get notification_inactivity_complete_body => 'Ready to start a new session?';

  @override
  String get loading => 'Loading...';

  @override
  String get error_retry => 'Error. Tap to retry';
}
