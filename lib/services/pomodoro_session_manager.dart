import 'dart:async';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/events/timer_events.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

/// Менеджер Pomodoro сессий с поддержкой callback'ов
/// Управляет бизнес-логикой сессий, используя таймер
class PomodoroSessionManager {
  final TimerService _timerService;
  final StreamController<PomodoroSession> _sessionController;

  PomodoroSession _currentSession = PomodoroSession.initial();
  StreamSubscription<TimerEvent>? _timerSubscription;

  PomodoroSessionManager(this._timerService) : _sessionController = StreamController<PomodoroSession>.broadcast() {
    // Подписываемся на события таймера
    _timerSubscription = _timerService.onTimerEvent.listen(_handleTimerEvent);
  }

  /// Поток изменений сессии
  Stream<PomodoroSession> get onSessionChange => _sessionController.stream;

  /// Текущая сессия
  PomodoroSession get currentSession => _currentSession;

  // ========== Callback'и для внешних систем ==========

  /// Вызывается при смене состояния сессии
  void Function(SessionState newState, SessionState? previousState)? onStateChanged;

  /// Вызывается при завершении сессии
  void Function(SessionState completedState)? onSessionCompleted;

  /// Вызывается при каждом тике таймера
  void Function(PomodoroSession session)? onSessionTick;

  /// Вызывается при паузе
  void Function()? onSessionPaused;

  /// Вызывается при возобновлении
  void Function()? onSessionResumed;

  // ========== Обработка событий таймера ==========

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
    // Callback о завершении сессии
    onSessionCompleted?.call(_currentSession.state);

    // Автоматический переход к следующему состоянию
    final nextSession = _currentSession.changeStateToNext();
    changeState(nextSession.state);
  }

  void _updateSession(PomodoroSession session) {
    _currentSession = session;
    _sessionController.add(_currentSession);
  }

  // ========== Публичные методы управления ==========

  /// Изменить состояние сессии
  void changeState(SessionState newState) {
    final previousState = _currentSession.state;
    final newSession = _currentSession.changeState(newState);

    _updateSession(newSession);

    // Запускаем таймер с новой длительностью если состояние имеет таймер
    if (newSession.state.hasTimer() && newSession.currentSeconds > 0) {
      _timerService.start(newSession.currentSeconds);
    } else {
      _timerService.stop();
    }

    // Callback об изменении состояния
    onStateChanged?.call(newState, previousState);
  }

  /// Перейти к следующему состоянию
  void changeStateToNext() {
    final nextState = _currentSession.state.next();
    changeState(nextState);
  }

  /// Перейти к состоянию неактивности
  void changeStateToInactivity() {
    changeState(SessionState.inactivity);
  }

  /// Запустить/возобновить таймер
  Future<void> start() async {
    if (_currentSession.state.hasTimer()) {
      if (_currentSession.isPaused && _currentSession.currentSeconds > 0) {
        _timerService.resume();
      } else if (_currentSession.currentSeconds > 0) {
        _timerService.start(_currentSession.currentSeconds);
      }
    }
  }

  /// Приостановить таймер
  Future<void> pause() async {
    _timerService.pause();
  }

  /// Отложить сессию на дополнительное время
  Future<void> postpone() async {
    final postponedSession = _currentSession.postpone();
    _updateSession(postponedSession);

    // Перезапускаем таймер с новым временем
    if (postponedSession.state.hasTimer()) {
      _timerService.start(postponedSession.currentSeconds);
    }
  }

  /// Возобновить таймер
  Future<void> resume() async {
    if (_currentSession.currentSeconds > 0 && _currentSession.state.hasTimer()) {
      _timerService.resume();
    }
  }

  /// Остановить таймер
  Future<void> stop() async {
    _timerService.stop();
  }

  /// Сбросить сессию
  Future<void> reset() async {
    final resetSession = _currentSession.reset();
    _updateSession(resetSession);

    if (resetSession.state.hasTimer() && !resetSession.isPaused) {
      _timerService.start(resetSession.currentSeconds);
    } else {
      _timerService.stop();
    }
  }

  /// Освободить ресурсы
  Future<void> dispose() async {
    await _timerSubscription?.cancel();
    await _timerService.dispose();
    await _sessionController.close();
  }
}
