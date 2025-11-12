import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/pomodoro_session_manager.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/providers/session_provider.dart';

class TimerNotifier extends StreamNotifier<PomodoroSession> {
  late final PomodoroSessionManager _sessionManager;

  @override
  Stream<PomodoroSession> build() {
    _sessionManager = ref.read(pomodoroSessionManagerProvider);

    return _sessionManager.onSessionChange;
  }

  PomodoroSession get currentSession => _sessionManager.currentSession;

  void changeState(SessionState newState) {
    _sessionManager.changeState(newState);
  }

  void changeStateToNext() {
    _sessionManager.changeStateToNext();
  }

  void changeStateToInactivity() {
    _sessionManager.changeStateToInactivity();
  }

  Future<void> start() async {
    await _sessionManager.start();
  }

  Future<void> pause() async {
    await _sessionManager.pause();
  }

  Future<void> postpone() async {
    await _sessionManager.postpone();
  }

  Future<void> resume() async {
    await _sessionManager.resume();
  }

  Future<void> stop() async {
    await _sessionManager.stop();
  }

  Future<void> reset() async {
    await _sessionManager.reset();
  }
}

final timerProvider = StreamNotifierProvider<TimerNotifier, PomodoroSession>(() {
  return TimerNotifier();
});
