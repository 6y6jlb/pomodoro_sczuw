import 'dart:async';

import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

class DesktopTimerService implements TimerService {
  Timer? _timer;
  late final StreamController<PomodoroSession> _controller;
  PomodoroSession _currentSession = PomodoroSession.initial();

  DesktopTimerService() {
    _controller = StreamController<PomodoroSession>.broadcast();
  }

  @override
  Stream<PomodoroSession> get onTick => _controller.stream;

  PomodoroSession get currentSession => _currentSession;

  void updateSession(PomodoroSession session) {
    _currentSession = session;
    _controller.add(_currentSession);

    if (session.isRunning) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    _stopTimer(); // Остановить предыдущий таймер если он есть

    if (!_currentSession.state.hasTimer()) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentSession = _currentSession.tick();
      _controller.add(_currentSession);

      // Проверяем завершение таймера
      if (_currentSession.isCompleted) {
        _stopTimer();
        // Автоматический переход к следующему состоянию
        final nextSession = _currentSession.changeStateToNext();
        updateSession(nextSession);
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> start() async {
    if (_currentSession.state.hasTimer()) {
      updateSession(_currentSession.resume());
    }
  }

  @override
  Future<void> pause() async {
    updateSession(_currentSession.pause());
  }

  @override
  Future<void> postpone() async {
    updateSession(_currentSession.postpone());
  }

  @override
  Future<void> resume() async {
    if (_currentSession.currentSeconds > 0 && _currentSession.state.hasTimer()) {
      updateSession(_currentSession.resume());
    }
  }

  @override
  Future<void> stop() async {
    updateSession(_currentSession.pause());
  }

  @override
  Future<void> reset() async {
    updateSession(_currentSession.reset());
  }

  @override
  Future<void> dispose() async {
    _stopTimer();
    await _controller.close();
  }
}
