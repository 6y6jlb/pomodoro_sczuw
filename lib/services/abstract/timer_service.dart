import 'package:pomodoro_sczuw/models/pomodoro_session.dart';

abstract class TimerService {
  Stream<PomodoroSession> get onTick;
  PomodoroSession get currentSession;

  void updateSession(PomodoroSession session);

  Future<void> postpone();
  Future<void> start();
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> reset();
  Future<void> dispose();
}
