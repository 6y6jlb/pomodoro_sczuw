import 'package:pomodoro_sczuw/enums/session_state.dart';

class SettingsConstant {
  static const Map<SessionState, int> sessionDurationInSeconds = {
    SessionState.activity: 10,
    SessionState.rest: 5,
    SessionState.inactivity: 0,
  };

  static const Map<SessionState, int> minSessionDurationInSeconds = {
    SessionState.activity: 10,
    SessionState.rest: 5,
    SessionState.inactivity: 0,
  };

  static const Map<SessionState, int> maxSessionDurationInSeconds = {
    SessionState.activity: 3600,
    SessionState.rest: 3600,
    SessionState.inactivity: 0,
  };

  static const int postponedSeconds = 10;
}
