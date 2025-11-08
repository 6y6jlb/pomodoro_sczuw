import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';
import 'package:pomodoro_sczuw/providers/service_providers.dart';

class SessionNotifier extends Notifier<PomodoroSession> {
  @override
  PomodoroSession build() {
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
    ref.read(soundServiceProvider).playSound('toggle');
  }

  void changeStateToInactivity() {
    ref.read(timerProvider.notifier).changeStateToInactivity();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> start() async {
    await ref.read(timerProvider.notifier).start();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> pause() async {
    await ref.read(timerProvider.notifier).pause();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> postpone() async {
    await ref.read(timerProvider.notifier).postpone();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> resume() async {
    await ref.read(timerProvider.notifier).resume();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> stop() async {
    await ref.read(timerProvider.notifier).stop();
    ref.read(soundServiceProvider).playSound('toggle');
  }

  Future<void> reset() async {
    await ref.read(timerProvider.notifier).reset();
    ref.read(soundServiceProvider).playSound('toggle');
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, PomodoroSession>(() {
  return SessionNotifier();
});
