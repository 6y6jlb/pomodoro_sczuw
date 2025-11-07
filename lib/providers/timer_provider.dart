import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';
import 'package:pomodoro_sczuw/providers/service_providers.dart';
import 'package:pomodoro_sczuw/providers/notification_provider.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

class TimerNotifier extends StreamNotifier<PomodoroSession> {
  late final TimerService _timerService;
  PomodoroSession? _previousSession;

  @override
  Stream<PomodoroSession> build() {
    _timerService = ref.read(timerServiceProvider);

    ref.onDispose(() {
      _timerService.dispose();
    });

    // Слушаем изменения сессии и отправляем уведомления
    return _timerService.onTick.map((session) {
      _handleSessionChange(session);
      _previousSession = session;
      return session;
    });
  }

  PomodoroSession get currentSession => _timerService.currentSession;

  void changeState(SessionState newState) {
    final previousState = _timerService.currentSession.state;
    final newSession = _timerService.currentSession.changeState(newState);
    _timerService.updateSession(newSession);

    // Отправляем уведомление о смене состояния
    _sendStateChangeNotification(newState, previousState);
  }

  void changeStateToNext() {
    final previousState = _timerService.currentSession.state;
    final newSession = _timerService.currentSession.changeStateToNext();
    _timerService.updateSession(newSession);

    // Отправляем уведомление о смене состояния
    _sendStateChangeNotification(newSession.state, previousState);
  }

  void changeStateToInactivity() {
    final previousState = _timerService.currentSession.state;
    final newSession = _timerService.currentSession.changeStateToInactivity();
    _timerService.updateSession(newSession);

    // Отправляем уведомление о смене состояния
    _sendStateChangeNotification(SessionState.inactivity, previousState);
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

  void _handleSessionChange(PomodoroSession session) {
    // Проверяем завершение сессии
    if (_previousSession != null && _previousSession!.currentSeconds > 0 && session.isCompleted) {
      _sendSessionCompleteNotification(session.state);
    }
  }

  void _sendStateChangeNotification(SessionState newState, SessionState previousState) {
    try {
      final notificationNotifier = ref.read(notificationProvider.notifier);
      notificationNotifier.showStateChangeNotification(newState, previousState);
    } catch (e) {
      print('Error sending state change notification: $e');
    }
  }

  void _sendSessionCompleteNotification(SessionState completedState) {
    try {
      final notificationNotifier = ref.read(notificationProvider.notifier);
      notificationNotifier.showSessionCompleteNotification(completedState);
    } catch (e) {
      print('Error sending session complete notification: $e');
    }
  }
}

final timerProvider = StreamNotifierProvider<TimerNotifier, PomodoroSession>(() {
  return TimerNotifier();
});
