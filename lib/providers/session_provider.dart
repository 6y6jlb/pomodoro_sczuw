import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

/// Timer state notifier that manages the timer state changes
/// Following Riverpod 3.0.3 best practices with NotifierProvider
class SessionNotifier extends Notifier<PomodoroSession> {
  @override
  PomodoroSession build() {
    return PomodoroSession.initial();
  }

  void changeState(SessionState newState) {
    state = state.changeState(newState);
  }

  void changeStateToNext() {
    state = state.changeStateToNext();
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, PomodoroSession>(() {
  return SessionNotifier();
});
