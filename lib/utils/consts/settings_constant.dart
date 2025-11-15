import 'package:pomodoro_sczuw/enums/session_state.dart';

class SettingsConstant {
  static const Map<SessionState, int> sessionDurationInSeconds = {
    SessionState.activity: 1500,
    SessionState.rest: 300,
    SessionState.inactivity: 0,
  };

  static const Map<SessionState, int> minSessionDurationInSeconds = {
    SessionState.activity: 60,
    SessionState.rest: 30,
    SessionState.inactivity: 0,
  };

  static const Map<SessionState, int> maxSessionDurationInSeconds = {
    SessionState.activity: 3600,
    SessionState.rest: 3600,
    SessionState.inactivity: 0,
  };

  static const int postponedSeconds = 300;
}
