import 'package:pomodoro_sczuw/enums/timer_state.dart';

class Timer {
  final TimerState state;

Timer({required this.state});

  factory Timer.initial() {
    return Timer(state: TimerState.inactivity);
  }

  Timer copyWith({TimerState? state}) {
    return Timer(state: state ?? this.state);
  }

  Timer changeState(TimerState state) {
    return copyWith(state: state);
  }

  Timer changeStateToNext() {
    return changeState(state.next());
  }

  Timer changeStateToInactivity() {
    return changeState(TimerState.inactivity);
  }
}