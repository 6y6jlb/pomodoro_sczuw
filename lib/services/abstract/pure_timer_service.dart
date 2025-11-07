import 'package:pomodoro_sczuw/events/timer_events.dart';

/// Таймер-сервис, который знает только о времени
/// Не содержит бизнес-логики Pomodoro
abstract class TimerService {
  /// Поток событий таймера
  Stream<TimerEvent> get onTimerEvent;

  /// Текущее состояние таймера
  int get remainingSeconds;
  int get totalSeconds;
  bool get isRunning;
  bool get isPaused;

  /// Запустить таймер с заданной длительностью
  void start(int durationSeconds);

  /// Приостановить таймер
  void pause();

  /// Возобновить таймер
  void resume();

  /// Остановить и сбросить таймер
  void stop();

  /// Сбросить таймер к начальному времени
  void reset();

  /// Освободить ресурсы
  Future<void> dispose();
}
