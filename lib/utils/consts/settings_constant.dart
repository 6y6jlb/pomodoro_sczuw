import 'package:pomodoro_sczuw/enums/session_state.dart';

class SettingsConstant {
  static const Map<SessionState, int> sessionDurationInSeconds = {
    SessionState.activity: 10,
    SessionState.rest: 5,
    SessionState.inactivity: 0,
  };

  static const int postponedSeconds = 10;
}
