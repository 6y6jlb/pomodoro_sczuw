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
  String get restDurationLabel => 'Rest duration:';

  @override
  String get action_stop => 'Stop';

  @override
  String get action_start => 'Start';

  @override
  String get action_continue => 'Continue';

  @override
  String get action_resume => 'Resume';

  @override
  String action_postpone(Object duration) {
    return '+$duration';
  }

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
  String get action_resetToDefaults => 'Reset to defaults';

  @override
  String get action_collapseWindow => 'Collapse window';

  @override
  String get action_exitApp => 'Exit app';

  @override
  String get action_showWindow => 'Show window';

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

  @override
  String get telegram_sectionTitle => 'Telegram';

  @override
  String get telegram_notificationsEnabled => 'Telegram notifications';

  @override
  String get telegram_botTokenLabel => 'Bot token';

  @override
  String get telegram_chatIdLabel => 'Chat ID';

  @override
  String get telegram_setupHint => 'Create a bot with @BotFather, send it /start, get your chat_id via @userinfobot, and paste the values above.';

  @override
  String get telegram_sendTest => 'Send test';

  @override
  String get telegram_sendingTest => 'Sending…';

  @override
  String get telegram_testSent => 'Telegram: test message sent';

  @override
  String telegram_testError(Object error) {
    return 'Telegram: $error';
  }

  @override
  String get telegram_notConfigured => 'Telegram is disabled or token/chat id is empty';

  @override
  String get telegram_timeout => 'Connection timed out. Check network or VPN.';

  @override
  String get telegram_connectionError => 'Cannot reach Telegram API. Check network or VPN.';

  @override
  String get telegram_requestFailed => 'Request failed';

  @override
  String get telegram_started => 'Pomodoro: started';

  @override
  String get telegram_stopped => 'Pomodoro: stopped';

  @override
  String telegram_statusChanged(Object from, Object to) {
    return 'Pomodoro: $from → $to';
  }

  @override
  String telegram_paused(Object state) {
    return 'Pomodoro: paused ($state)';
  }

  @override
  String telegram_resumed(Object state) {
    return 'Pomodoro: resumed ($state)';
  }

  @override
  String get telegram_test => 'Pomodoro: test';

  @override
  String get restOverlay_sectionTitle => 'Rest overlay';

  @override
  String get restOverlay_enabled => 'Show over all windows during rest';

  @override
  String get restOverlay_title => 'Time to rest';

  @override
  String get restOverlay_subtitle => 'Take a short break — your eyes and body will thank you.';

  @override
  String get restOverlay_dismiss => 'Got it';

  @override
  String get restOverlay_tip1 => 'Stand up, walk for a minute, and stretch your neck.';

  @override
  String get restOverlay_tip2 => 'Look into the distance for 20 seconds to rest your eyes.';

  @override
  String get restOverlay_tip3 => 'Drink some water and take a few deep breaths.';

  @override
  String get restOverlay_tip4 => 'Step away from the screen and roll your shoulders.';

  @override
  String get sounds_sectionTitle => 'Sounds';

  @override
  String get sounds_userAction => 'User actions';

  @override
  String get sounds_sessionComplete => 'Timer complete';

  @override
  String get sounds_stateActivity => 'Switch to activity';

  @override
  String get sounds_stateRest => 'Switch to rest';

  @override
  String get sounds_stateInactivity => 'Switch to inactivity';

  @override
  String get sounds_presetOff => 'Off';

  @override
  String get sounds_presetToggle => 'toggle';

  @override
  String get sounds_presetRequest => 'request';

  @override
  String get sounds_chooseFile => 'Choose file';

  @override
  String get sounds_resetDefault => 'Default';

  @override
  String get sounds_defaultLabel => 'Default';

  @override
  String get sounds_customFileInvalid => 'Invalid or missing audio file';

  @override
  String get theme_sectionTitle => 'Theme';

  @override
  String get theme_system => 'System';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_paletteSection => 'Palette';

  @override
  String get theme_paletteDefault => 'Default';

  @override
  String get theme_paletteSage => 'Sage';

  @override
  String get theme_paletteMist => 'Mist';

  @override
  String get theme_paletteSand => 'Sand';

  @override
  String get settings_sectionSession => 'Session';

  @override
  String get settings_sectionAppearance => 'Appearance';

  @override
  String get settings_sectionRestOverlay => 'Rest overlay';

  @override
  String get settings_sectionSounds => 'Sounds';

  @override
  String get settings_sectionTelegram => 'Telegram';

  @override
  String get language_sectionTitle => 'Language';

  @override
  String get language_system => 'System';

  @override
  String get language_en => 'English';

  @override
  String get language_ru => 'Russian';
}
