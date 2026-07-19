import 'package:hive/hive.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

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

  PomodoroSettings({
    required this.sessionDuration,
    required this.breakDuration,
    this.telegramEnabled = false,
    this.telegramBotToken = '',
    this.telegramChatId = '',
  });

  factory PomodoroSettings.initial() {
    return PomodoroSettings(
      sessionDuration: SessionState.activity.defaultDuration,
      breakDuration: SessionState.rest.defaultDuration,
    );
  }

  PomodoroSettings copyWith({
    int? sessionDuration,
    int? breakDuration,
    bool? telegramEnabled,
    String? telegramBotToken,
    String? telegramChatId,
  }) {
    return PomodoroSettings(
      sessionDuration: sessionDuration ?? this.sessionDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      telegramEnabled: telegramEnabled ?? this.telegramEnabled,
      telegramBotToken: telegramBotToken ?? this.telegramBotToken,
      telegramChatId: telegramChatId ?? this.telegramChatId,
    );
  }
}
