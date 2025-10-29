import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/timer.dart';
import 'package:pomodoro_sczuw/enums/timer_state.dart';

/// Timer state notifier that manages the timer state changes
/// Following Riverpod 3.0.3 best practices with NotifierProvider
class TimerNotifier extends Notifier<Timer> {
  @override
  Timer build() {
    return Timer.initial();
  }

  void changeState(TimerState newState) {
    state = state.changeState(newState);
  }

  void changeStateToNext() {
    state = state.changeStateToNext();
  }
}

final timerProvider = NotifierProvider<TimerNotifier, Timer>(() {
  return TimerNotifier();
});
