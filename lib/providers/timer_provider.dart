import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/desktop_timer_service.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

class TimerNotifier extends StreamNotifier<PomodoroSession> {
  late final DesktopTimerService _timerService;

  @override
  Stream<PomodoroSession> build() {
    _timerService = DesktopTimerService();

    // Добавляем listener для автоматического обновления при получении новых данных
    ref.onDispose(() {
      _timerService.dispose();
    });

    return _timerService.onTick;
  }

  PomodoroSession get currentSession => _timerService.currentSession;

  void changeState(SessionState newState) {
    final newSession = _timerService.currentSession.changeState(newState);
    _timerService.updateSession(newSession);
  }

  void changeStateToNext() {
    final newSession = _timerService.currentSession.changeStateToNext();
    _timerService.updateSession(newSession);
  }

  void changeStateToInactivity() {
    final newSession = _timerService.currentSession.changeStateToInactivity();
    _timerService.updateSession(newSession);
  }

  Future<void> start() async {
    await _timerService.start();
  }

  Future<void> pause() async {
    await _timerService.pause();
  }

  Future<void> postpone() async {
    await _timerService.postpone();
  }

  Future<void> resume() async {
    await _timerService.resume();
  }

  Future<void> stop() async {
    await _timerService.stop();
  }

  Future<void> reset() async {
    await _timerService.reset();
  }
}

final timerProvider = StreamNotifierProvider<TimerNotifier, PomodoroSession>(() {
  return TimerNotifier();
});
