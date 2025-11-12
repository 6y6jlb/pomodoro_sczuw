import 'package:pomodoro_sczuw/enums/session_state.dart';


class PomodoroSettings {
  final int sessionDuration;
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