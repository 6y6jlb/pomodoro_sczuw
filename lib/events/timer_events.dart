sealed class TimerEvent {
  const TimerEvent();
}

class TimerTick extends TimerEvent {
  final int remainingSeconds;
  final int totalSeconds;

  const TimerTick({required this.remainingSeconds, required this.totalSeconds});

  @override
  String toString() => 'TimerTick(remaining: $remainingSeconds, total: $totalSeconds)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerTick &&
          runtimeType == other.runtimeType &&
          remainingSeconds == other.remainingSeconds &&
          totalSeconds == other.totalSeconds;

  @override
  int get hashCode => remainingSeconds.hashCode ^ totalSeconds.hashCode;
}

class TimerCompleted extends TimerEvent {
  const TimerCompleted();

  @override
  String toString() => 'TimerCompleted()';
}

class TimerPaused extends TimerEvent {
  const TimerPaused();

  @override
  String toString() => 'TimerPaused()';
}

class TimerResumed extends TimerEvent {
  const TimerResumed();

  @override
  String toString() => 'TimerResumed()';
}

class TimerStopped extends TimerEvent {
  const TimerStopped();

  @override
  String toString() => 'TimerStopped()';
}

class TimerReset extends TimerEvent {
  final int newDurationSeconds;

  const TimerReset({required this.newDurationSeconds});

  @override
  String toString() => 'TimerReset(duration: $newDurationSeconds)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerReset && runtimeType == other.runtimeType && newDurationSeconds == other.newDurationSeconds;

  @override
  int get hashCode => newDurationSeconds.hashCode;
}
