import 'package:pomodoro_sczuw/models/pomodoro_session.dart';

abstract class TimerService {
  Stream<PomodoroSession> get onTick;
  Future<void> postpone();
  Future<void> start();
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> reset();
  Future<void> dispose();
}
