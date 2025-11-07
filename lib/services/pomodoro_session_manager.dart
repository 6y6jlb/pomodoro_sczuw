import 'dart:async';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/events/timer_events.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/services/events_sound_service.dart';

class PomodoroSessionManager {
  final TimerService _timerService;
  final StreamController<PomodoroSession> _sessionController;
  final EventsSoundService _soundService;

  PomodoroSession _currentSession = PomodoroSession.initial();
  StreamSubscription<TimerEvent>? _timerSubscription;

  PomodoroSessionManager(this._timerService, this._soundService)
    : _sessionController = StreamController<PomodoroSession>.broadcast() {
    _timerSubscription = _timerService.onTimerEvent.listen(_handleTimerEvent);
  }

  Stream<PomodoroSession> get onSessionChange => _sessionController.stream;

  PomodoroSession get currentSession => _currentSession;

  void Function(SessionState newState, SessionState? previousState)? onStateChanged;

  void Function(SessionState completedState)? onSessionCompleted;

  void Function(PomodoroSession session)? onSessionTick;

  void Function()? onSessionPaused;

  void Function()? onSessionResumed;

  void _handleTimerEvent(TimerEvent event) {
    switch (event) {
      case TimerTick(:final remainingSeconds, :final totalSeconds):
        _updateSession(_currentSession.copyWith(currentSeconds: remainingSeconds, totalSeconds: totalSeconds));
        onSessionTick?.call(_currentSession);

      case TimerCompleted():
        _handleSessionComplete();

      case TimerPaused():
        _updateSession(_currentSession.pause());
        onSessionPaused?.call();

      case TimerResumed():
        _updateSession(_currentSession.resume());
        onSessionResumed?.call();

      case TimerStopped():
        _updateSession(_currentSession.pause());

      case TimerReset(:final newDurationSeconds):
        _updateSession(_currentSession.copyWith(currentSeconds: newDurationSeconds, totalSeconds: newDurationSeconds));
    }
  }

  void _handleSessionComplete() {

    onSessionCompleted?.call(_currentSession.state);

    final nextSession = _currentSession.changeStateToNext();
    changeState(nextSession.state);
  }

  void _updateSession(PomodoroSession session) {
    _currentSession = session;
    _sessionController.add(_currentSession);
  }

  void changeState(SessionState newState) {
    final previousState = _currentSession.state;
    final newSession = _currentSession.changeState(newState);

    _updateSession(newSession);

    if (newSession.state.hasTimer() && newSession.currentSeconds > 0) {
      _timerService.start(newSession.currentSeconds);
    } else {
      _timerService.stop();
    }

    onStateChanged?.call(newState, previousState);
  }

  void changeStateToNext() {
    final nextState = _currentSession.state.next();
    changeState(nextState);
  }

  void changeStateToInactivity() {
    changeState(SessionState.inactivity);
  }

  Future<void> start() async {
    if (_currentSession.state.hasTimer()) {
      if (_currentSession.isPaused && _currentSession.currentSeconds > 0) {
        _timerService.resume();
      } else if (_currentSession.currentSeconds > 0) {
        _timerService.start(_currentSession.currentSeconds);
      }
    }
  }

  Future<void> pause() async {
    _timerService.pause();
  }

  Future<void> postpone() async {
    final postponedSession = _currentSession.postpone();
    _updateSession(postponedSession);

    if (postponedSession.state.hasTimer()) {
      _timerService.start(postponedSession.currentSeconds);
    }
  }

  Future<void> resume() async {
    if (_currentSession.currentSeconds > 0 && _currentSession.state.hasTimer()) {
      _timerService.resume();
    }
  }

  Future<void> stop() async {
    _timerService.stop();
  }

  Future<void> reset() async {
    final resetSession = _currentSession.reset();
    _updateSession(resetSession);

    if (resetSession.state.hasTimer() && !resetSession.isPaused) {
      _timerService.start(resetSession.currentSeconds);
    } else {
      _timerService.stop();
    }
  }

  Future<void> dispose() async {
    await _timerSubscription?.cancel();
    await _timerService.dispose();
    await _sessionController.close();
  }
}
