import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';

class SessionNotifier extends Notifier<PomodoroSession> {
  @override
  PomodoroSession build() {
    // Слушаем изменения от timerProvider
    final timerAsyncValue = ref.watch(timerProvider);

    return timerAsyncValue.when(
      data: (session) => session,
      loading: () => PomodoroSession.initial(),
      error: (error, stack) => PomodoroSession.initial(),
    );
  }

  void changeState(SessionState newState) {
    ref.read(timerProvider.notifier).changeState(newState);
  }

  void changeStateToNext() {
    ref.read(timerProvider.notifier).changeStateToNext();
  }

  void changeStateToInactivity() {
    ref.read(timerProvider.notifier).changeStateToInactivity();
  }

  Future<void> start() async {
    await ref.read(timerProvider.notifier).start();
  }

  Future<void> pause() async {
    await ref.read(timerProvider.notifier).pause();
  }

  Future<void> resume() async {
    await ref.read(timerProvider.notifier).resume();
  }

  Future<void> stop() async {
    await ref.read(timerProvider.notifier).stop();
  }

  Future<void> reset() async {
    await ref.read(timerProvider.notifier).reset();
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, PomodoroSession>(() {
  return SessionNotifier();
});
