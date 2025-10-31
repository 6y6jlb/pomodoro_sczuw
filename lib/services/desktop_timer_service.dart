import 'dart:async';

import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/services/abstract/timer_service.dart';

class DesktopTimerService implements TimerService {
  Timer? _timer;
  @override
  Stream<PomodoroSession> get onTick => throw UnimplementedError();

  @override
  Future<void> start() => throw UnimplementedError();

  @override
  Future<void> pause() => throw UnimplementedError();

  @override
  Future<void> resume() => throw UnimplementedError();

  @override
  Future<void> stop() => throw UnimplementedError();

  @override
  Future<void> reset() => throw UnimplementedError();

  @override
  Future<void> dispose() => throw UnimplementedError();
}
