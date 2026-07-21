import 'package:hive/hive.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/sound_event.dart';
import 'package:pomodoro_sczuw/utils/consts/app_theme_preference.dart';
import 'package:pomodoro_sczuw/utils/consts/sound_preset.dart';

part 'pomodoro_settings.g.dart';

@HiveType(typeId: 0)
class PomodoroSettings extends HiveObject {
  @HiveField(0)
  final int sessionDuration;

  @HiveField(1)
  final int breakDuration;

  @HiveField(2, defaultValue: false)
  final bool telegramEnabled;

  @HiveField(3, defaultValue: '')
  final String telegramBotToken;

  @HiveField(4, defaultValue: '')
  final String telegramChatId;

  @HiveField(5, defaultValue: false)
  final bool restOverlayEnabled;

  @HiveField(6, defaultValue: SoundPreset.toggle)
  final String soundUserAction;

  @HiveField(7, defaultValue: SoundPreset.request)
  final String soundSessionComplete;

  @HiveField(8, defaultValue: SoundPreset.off)
  final String soundStateActivity;

  @HiveField(9, defaultValue: SoundPreset.off)
  final String soundStateRest;

  @HiveField(10, defaultValue: SoundPreset.off)
  final String soundStateInactivity;

  @HiveField(11, defaultValue: AppThemePreference.system)
  final String themeMode;

  PomodoroSettings({
    required this.sessionDuration,
    required this.breakDuration,
    this.telegramEnabled = false,
    this.telegramBotToken = '',
    this.telegramChatId = '',
    this.restOverlayEnabled = false,
    this.soundUserAction = SoundPreset.toggle,
    this.soundSessionComplete = SoundPreset.request,
    this.soundStateActivity = SoundPreset.off,
    this.soundStateRest = SoundPreset.off,
    this.soundStateInactivity = SoundPreset.off,
    this.themeMode = AppThemePreference.system,
  });

  factory PomodoroSettings.initial() {
    return PomodoroSettings(
      sessionDuration: SessionState.activity.defaultDuration,
      breakDuration: SessionState.rest.defaultDuration,
    );
  }

  String soundKeyForEvent(SoundEvent event) {
    switch (event) {
      case SoundEvent.userAction:
        return soundUserAction;
      case SoundEvent.sessionComplete:
        return soundSessionComplete;
      case SoundEvent.stateActivity:
        return soundStateActivity;
      case SoundEvent.stateRest:
        return soundStateRest;
      case SoundEvent.stateInactivity:
        return soundStateInactivity;
    }
  }

  PomodoroSettings copyWith({
    int? sessionDuration,
    int? breakDuration,
    bool? telegramEnabled,
    String? telegramBotToken,
    String? telegramChatId,
    bool? restOverlayEnabled,
    String? soundUserAction,
    String? soundSessionComplete,
    String? soundStateActivity,
    String? soundStateRest,
    String? soundStateInactivity,
    String? themeMode,
  }) {
    return PomodoroSettings(
      sessionDuration: sessionDuration ?? this.sessionDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      telegramEnabled: telegramEnabled ?? this.telegramEnabled,
      telegramBotToken: telegramBotToken ?? this.telegramBotToken,
      telegramChatId: telegramChatId ?? this.telegramChatId,
      restOverlayEnabled: restOverlayEnabled ?? this.restOverlayEnabled,
      soundUserAction: soundUserAction ?? this.soundUserAction,
      soundSessionComplete: soundSessionComplete ?? this.soundSessionComplete,
      soundStateActivity: soundStateActivity ?? this.soundStateActivity,
      soundStateRest: soundStateRest ?? this.soundStateRest,
      soundStateInactivity: soundStateInactivity ?? this.soundStateInactivity,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
