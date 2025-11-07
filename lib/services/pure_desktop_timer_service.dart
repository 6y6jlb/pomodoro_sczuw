import 'dart:async';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/events/timer_events.dart';

/// Реализация таймера для desktop платформы
/// Знает только о времени, не содержит Pomodoro бизнес-логики
class DesktopTimerService implements TimerService {
  Timer? _timer;
  late final StreamController<TimerEvent> _controller;

  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  DesktopTimerService() {
    _controller = StreamController<TimerEvent>.broadcast();
  }

  @override
  Stream<TimerEvent> get onTimerEvent => _controller.stream;

  @override
  int get remainingSeconds => _remainingSeconds;

  @override
  int get totalSeconds => _totalSeconds;

  @override
  bool get isRunning => _isRunning && !_isPaused;

  @override
  bool get isPaused => _isPaused;

  @override
  void start(int durationSeconds) {
    _totalSeconds = durationSeconds;
    _remainingSeconds = durationSeconds;
    _isRunning = true;
    _isPaused = false;

    _startTimer();

    // Сразу отправляем первое событие
    _controller.add(TimerTick(remainingSeconds: _remainingSeconds, totalSeconds: _totalSeconds));
  }

  @override
  void pause() {
    if (_isRunning && !_isPaused) {
      _isPaused = true;
      _stopTimer();
      _controller.add(const TimerPaused());
    }
  }

  @override
  void resume() {
    if (_isRunning && _isPaused && _remainingSeconds > 0) {
      _isPaused = false;
      _startTimer();
      _controller.add(const TimerResumed());
    }
  }

  @override
  void stop() {
    if (_isRunning) {
      _isRunning = false;
      _isPaused = false;
      _stopTimer();
      _controller.add(const TimerStopped());
    }
  }

  @override
  void reset() {
    _stopTimer();
    _remainingSeconds = _totalSeconds;
    _isPaused = false;

    _controller.add(TimerReset(newDurationSeconds: _totalSeconds));

    // Если таймер был запущен, возобновляем с новым временем
    if (_isRunning) {
      _startTimer();
      _controller.add(TimerTick(remainingSeconds: _remainingSeconds, totalSeconds: _totalSeconds));
    }
  }

  void _startTimer() {
    _stopTimer(); // Остановить предыдущий таймер если он есть

    if (_remainingSeconds <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;

        _controller.add(TimerTick(remainingSeconds: _remainingSeconds, totalSeconds: _totalSeconds));

        // Проверяем завершение таймера
        if (_remainingSeconds == 0) {
          _isRunning = false;
          _isPaused = false;
          _stopTimer();
          _controller.add(const TimerCompleted());
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> dispose() async {
    _stopTimer();
    await _controller.close();
  }
}
