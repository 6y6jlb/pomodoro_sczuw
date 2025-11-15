import 'package:hive/hive.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

part 'pomodoro_settings.g.dart';

@HiveType(typeId: 0)
class PomodoroSettings extends HiveObject {
  @HiveField(0)
  final int sessionDuration;
  
  @HiveField(1)
  final int breakDuration;

  PomodoroSettings({
    required this.sessionDuration,
    required this.breakDuration,
  });

  factory PomodoroSettings.initial() {
    return PomodoroSettings(
      sessionDuration: SessionState.activity.defaultDuration,
      breakDuration: SessionState.rest.defaultDuration,
    );
  }

  PomodoroSettings copyWith({int? sessionDuration, int? breakDuration}) {
    return PomodoroSettings(
      sessionDuration: sessionDuration ?? this.sessionDuration,
      breakDuration: breakDuration ?? this.breakDuration,
    );
  }
}