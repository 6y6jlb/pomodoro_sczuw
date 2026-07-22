import 'dart:async';

import 'package:pomodoro_sczuw/events/timer_events.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/services/android/android_foreground_controller.dart';

/// Wall-clock timer for Android; FGS keeps the process alive while a session runs.
class AndroidTimerService implements TimerService {
  final AndroidForegroundController _foregroundController;
  Timer? _timer;
  late final StreamController<TimerEvent> _controller;

  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  DateTime? _endAt;

  AndroidTimerService({required AndroidForegroundController foregroundController})
      : _foregroundController = foregroundController {
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
    _endAt = DateTime.now().add(Duration(seconds: durationSeconds));

    _startTimer();

    _controller.add(const TimerStarted());
    _controller.add(TimerTick(remainingSeconds: _remainingSeconds, totalSeconds: _totalSeconds));
  }

  @override
  void pause() {
    if (_isRunning && !_isPaused) {
      _syncRemainingFromWallClock();
      _isPaused = true;
      _endAt = null;
      _stopTimer();
      _controller.add(const TimerPaused());
    }
  }

  @override
  void resume() {
    if (_isRunning && _isPaused && _remainingSeconds > 0) {
      _isPaused = false;
      _endAt = DateTime.now().add(Duration(seconds: _remainingSeconds));
      _startTimer();
      _controller.add(const TimerResumed());
    }
  }

  @override
  void stop() {
    if (_isRunning) {
      _isRunning = false;
      _isPaused = false;
      _endAt = null;
      _stopTimer();
      unawaited(_foregroundController.stopSession());
      _controller.add(const TimerStopped());
    }
  }

  @override
  void reset() {
    _stopTimer();
    _remainingSeconds = _totalSeconds;
    _isPaused = false;
    _endAt = _isRunning ? DateTime.now().add(Duration(seconds: _remainingSeconds)) : null;

    _controller.add(TimerReset(newDurationSeconds: _totalSeconds));

    if (_isRunning) {
      _startTimer();
      _controller.add(TimerTick(remainingSeconds: _remainingSeconds, totalSeconds: _totalSeconds));
    }
  }

  void _startTimer() {
    _stopTimer();
    if (_remainingSeconds <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    _syncRemainingFromWallClock();

    _controller.add(TimerTick(remainingSeconds: _remainingSeconds, totalSeconds: _totalSeconds));

    if (_remainingSeconds <= 0) {
      _isRunning = false;
      _isPaused = false;
      _endAt = null;
      _stopTimer();
      _controller.add(const TimerCompleted());
    }
  }

  void _syncRemainingFromWallClock() {
    if (_endAt == null) return;
    final remaining = _endAt!.difference(DateTime.now()).inSeconds;
    _remainingSeconds = remaining < 0 ? 0 : remaining;
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> dispose() async {
    _stopTimer();
    await _foregroundController.stopSession();
    await _controller.close();
  }
}
