import 'package:pomodoro_sczuw/enums/session_state.dart';

class PomodoroSession {
  final SessionState state;

  PomodoroSession({required this.state});

  factory PomodoroSession.initial() {
    return PomodoroSession(state: SessionState.inactivity);
  }

  PomodoroSession copyWith({SessionState? state}) {
    return PomodoroSession(state: state ?? this.state);
  }

  PomodoroSession changeState(SessionState state) {
    return copyWith(state: state);
  }

  PomodoroSession changeStateToNext() {
    return changeState(state.next());
  }

  PomodoroSession changeStateToInactivity() {
    return changeState(SessionState.inactivity);
  }
}
