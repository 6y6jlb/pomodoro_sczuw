import 'package:pomodoro_sczuw/enums/session_state.dart';

class SettingsConstant {
  static const Map<SessionState, int> sessionDurationInSeconds = {
    SessionState.activity: 1500,
    SessionState.rest: 300,
    SessionState.restDelay: 300,
    SessionState.inactivity: 0,
  };
}
