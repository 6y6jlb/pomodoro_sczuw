import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @timerStateLabel_activity.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get timerStateLabel_activity;

  /// No description provided for @timerStateLabel_inactivity.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get timerStateLabel_inactivity;

  /// No description provided for @timerStateLabel_rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get timerStateLabel_rest;

  /// No description provided for @timerStateLabel_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get timerStateLabel_unknown;

  /// No description provided for @pomodoroModeLabel_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get pomodoroModeLabel_custom;

  /// No description provided for @pomodoroModeLabel_schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get pomodoroModeLabel_schedule;

  /// No description provided for @operationModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode:'**
  String get operationModeLabel;

  /// No description provided for @sessionDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Session duration:'**
  String get sessionDurationLabel;

  /// No description provided for @restDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Rest duration:'**
  String get restDurationLabel;

  /// No description provided for @action_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get action_stop;

  /// No description provided for @action_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get action_start;

  /// No description provided for @action_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get action_continue;

  /// No description provided for @action_resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get action_resume;

  /// No description provided for @action_postpone.
  ///
  /// In en, this message translates to:
  /// **'+5min'**
  String get action_postpone;

  /// No description provided for @action_rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get action_rest;

  /// No description provided for @action_break.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get action_break;

  /// No description provided for @action_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get action_confirm;

  /// No description provided for @action_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get action_pause;

  /// No description provided for @action_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get action_unknown;

  /// No description provided for @action_resetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get action_resetToDefaults;

  /// No description provided for @unitShort_minute.
  ///
  /// In en, this message translates to:
  /// **'min.'**
  String get unitShort_minute;

  /// No description provided for @unitShort_seconds.
  ///
  /// In en, this message translates to:
  /// **'s.'**
  String get unitShort_seconds;

  /// No description provided for @unitShort_hours.
  ///
  /// In en, this message translates to:
  /// **'h.'**
  String get unitShort_hours;

  /// No description provided for @unitShort_days.
  ///
  /// In en, this message translates to:
  /// **'d.'**
  String get unitShort_days;

  /// No description provided for @timerLabel.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerLabel;

  /// No description provided for @scheduleStateLabel_active.
  ///
  /// In en, this message translates to:
  /// **'Schedule: active'**
  String get scheduleStateLabel_active;

  /// No description provided for @scheduleStateLabel_inactive.
  ///
  /// In en, this message translates to:
  /// **'Schedule: inactive'**
  String get scheduleStateLabel_inactive;

  /// No description provided for @scheduleHasNotActiveDay.
  ///
  /// In en, this message translates to:
  /// **'No active days in the schedule'**
  String get scheduleHasNotActiveDay;

  /// No description provided for @scheduleWillStartAt.
  ///
  /// In en, this message translates to:
  /// **'Schedule will start: {day} at {time}'**
  String scheduleWillStartAt(Object day, Object time);

  /// No description provided for @scheduleWillEndAt.
  ///
  /// In en, this message translates to:
  /// **'Schedule will end: {time}'**
  String scheduleWillEndAt(Object time);

  /// No description provided for @scheduleScheduleModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Set active days and hours - the timer will work only when needed.'**
  String get scheduleScheduleModeDescription;

  /// No description provided for @scheduleCustomModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the duration of work and rest without being tied to the schedule.'**
  String get scheduleCustomModeDescription;

  /// No description provided for @scheduleActiveDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Active days:'**
  String get scheduleActiveDaysLabel;

  /// No description provided for @scheduleActiveHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Active hours:'**
  String get scheduleActiveHoursLabel;

  /// No description provided for @scheduleExceptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Exceptions:'**
  String get scheduleExceptionsLabel;

  /// No description provided for @scheduleExceptionAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add exception'**
  String get scheduleExceptionAddLabel;

  /// No description provided for @scheduleExceptionShowLabel.
  ///
  /// In en, this message translates to:
  /// **'Show exception'**
  String get scheduleExceptionShowLabel;

  /// No description provided for @notification_stateChanged.
  ///
  /// In en, this message translates to:
  /// **'State changed: {state}'**
  String notification_stateChanged(Object state);

  /// No description provided for @notification_exceptionAdded.
  ///
  /// In en, this message translates to:
  /// **'Added exception for {day}'**
  String notification_exceptionAdded(Object day);

  /// No description provided for @notification_activity_title.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro - Work Time! 🍅'**
  String get notification_activity_title;

  /// No description provided for @notification_activity_body.
  ///
  /// In en, this message translates to:
  /// **'Work session is starting. Focus on your task!'**
  String get notification_activity_body;

  /// No description provided for @notification_rest_title.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro - Break Time! ☕'**
  String get notification_rest_title;

  /// No description provided for @notification_rest_body.
  ///
  /// In en, this message translates to:
  /// **'Break is starting. Relax and rest!'**
  String get notification_rest_body;

  /// No description provided for @notification_inactivity_title.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro - Stopped'**
  String get notification_inactivity_title;

  /// No description provided for @notification_inactivity_body.
  ///
  /// In en, this message translates to:
  /// **'Timer is stopped. Ready to start a new session?'**
  String get notification_inactivity_body;

  /// No description provided for @notification_activity_complete_title.
  ///
  /// In en, this message translates to:
  /// **'Work session completed! ✅'**
  String get notification_activity_complete_title;

  /// No description provided for @notification_activity_complete_body.
  ///
  /// In en, this message translates to:
  /// **'Great work! Time for a well-deserved break.'**
  String get notification_activity_complete_body;

  /// No description provided for @notification_rest_complete_title.
  ///
  /// In en, this message translates to:
  /// **'Break completed! 🔄'**
  String get notification_rest_complete_title;

  /// No description provided for @notification_rest_complete_body.
  ///
  /// In en, this message translates to:
  /// **'Rest is over. Ready for a new work session?'**
  String get notification_rest_complete_body;

  /// No description provided for @notification_inactivity_complete_title.
  ///
  /// In en, this message translates to:
  /// **'Session completed'**
  String get notification_inactivity_complete_title;

  /// No description provided for @notification_inactivity_complete_body.
  ///
  /// In en, this message translates to:
  /// **'Ready to start a new session?'**
  String get notification_inactivity_complete_body;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error_retry.
  ///
  /// In en, this message translates to:
  /// **'Error. Tap to retry'**
  String get error_retry;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
