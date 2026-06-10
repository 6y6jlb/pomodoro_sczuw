import 'package:pomodoro_sczuw/enums/timer_phase.dart';

/// Contract for any module that reacts to timer phase changes with a side
/// effect. Implementations may be HTTP (ESP32), MQTT, serial, smart-home
/// integrations, etc. Implementations must not throw — they should handle
/// and swallow their own errors so the timer flow is never blocked.
abstract class StateSideEffect {
  Future<void> onPhaseChanged(TimerPhase phase);

  Future<void> dispose();
}
