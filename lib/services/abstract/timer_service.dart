import 'package:pomodoro_sczuw/events/timer_events.dart';

abstract class TimerService {
  Stream<TimerEvent> get onTimerEvent;

  int get remainingSeconds;
  int get totalSeconds;
  bool get isRunning;
  bool get isPaused;

  void start(int durationSeconds);

  void pause();

  void resume();

  void stop();

  void reset();

  Future<void> dispose();
}
