import 'package:pomodoro_sczuw/enums/session_state.dart';

class PomodoroSession {
  final SessionState state;
  final int currentSeconds;
  final int totalSeconds;
  final bool isPaused;

  PomodoroSession({
    required this.state,
    required this.currentSeconds,
    required this.totalSeconds,
    required this.isPaused,
  });

  factory PomodoroSession.initial() {
    return PomodoroSession(state: SessionState.inactivity, currentSeconds: 0, totalSeconds: 0, isPaused: true);
  }

  PomodoroSession copyWith({SessionState? state, int? currentSeconds, int? totalSeconds, bool? isPaused}) {
    return PomodoroSession(
      state: state ?? this.state,
      currentSeconds: currentSeconds ?? this.currentSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  PomodoroSession changeState(SessionState newState) {
    final duration = newState.defaultDuration;
    return copyWith(state: newState, currentSeconds: duration, totalSeconds: duration, isPaused: !newState.hasTimer());
  }

  PomodoroSession changeStateToNext() {
    return changeState(state.next());
  }

  PomodoroSession changeStateToInactivity() {
    return changeState(SessionState.inactivity);
  }

  PomodoroSession tick() {
    if (isPaused || !state.hasTimer() || currentSeconds <= 0) return this;
    return copyWith(currentSeconds: currentSeconds - 1);
  }

  PomodoroSession pause() {
    return copyWith(isPaused: true);
  }

  PomodoroSession resume() {
    return copyWith(isPaused: !(currentSeconds > 0 && state.hasTimer()));
  }

  PomodoroSession reset() {
    final duration = state.defaultDuration;
    return copyWith(currentSeconds: duration, totalSeconds: duration, isPaused: true);
  }

  bool get isCompleted => currentSeconds <= 0 && state.hasTimer();
  bool get isRunning => !isPaused && state.hasTimer() && currentSeconds > 0;
  double get progress => totalSeconds > 0 ? (totalSeconds - currentSeconds) / totalSeconds : 0.0;
}
