import 'dart:async';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/events/timer_events.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/services/sound_service.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';

class PomodoroSessionManager {
  final TimerService _timerService;
  final StreamController<PomodoroSession> _sessionController;
  final SoundService _soundService;
  PomodoroSettings _settings;

  PomodoroSession _currentSession = PomodoroSession.initial();
  StreamSubscription<TimerEvent>? _timerSubscription;

  PomodoroSessionManager(this._timerService, this._soundService, this._settings)
    : _sessionController = StreamController<PomodoroSession>.broadcast() {
    _timerSubscription = _timerService.onTimerEvent.listen(_handleTimerEvent);
  }

  Stream<PomodoroSession> get onSessionChange => _sessionController.stream;

  PomodoroSession get currentSession => _currentSession;
  PomodoroSettings get settings => _settings;

  void updateSettings(PomodoroSettings newSettings) {
    _settings = newSettings;
  }

  void Function(SessionState newState, SessionState? previousState)? onStateChanged;

  void Function(SessionState completedState)? onSessionCompleted;

  void Function(PomodoroSession session)? onSessionTick;

  void Function()? onSessionPaused;

  void Function()? onSessionResumed;

  int _getDurationForState(SessionState state) {
    switch (state) {
      case SessionState.activity:
        return _settings.sessionDuration;
      case SessionState.rest:
        return _settings.breakDuration;
      case SessionState.inactivity:
        return 0;
    }
  }

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

      default:
        break;
    }
  }

  void _handleSessionComplete() {
    onSessionCompleted?.call(_currentSession.state);

    final nextState = _currentSession.state.next();
    changeState(nextState);
    _soundService.playSound('request');
  }

  void _updateSession(PomodoroSession session) {
    _currentSession = session;
    _sessionController.add(_currentSession);
  }

  void changeState(SessionState newState) {
    final previousState = _currentSession.state;
    final duration = _getDurationForState(newState);
    final newSession = _currentSession.changeState(newState, duration);

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
    final duration = _getDurationForState(_currentSession.state);
    final resetSession = _currentSession.reset(duration);
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
