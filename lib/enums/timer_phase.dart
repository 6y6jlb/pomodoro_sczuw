import 'package:pomodoro_sczuw/enums/session_state.dart';

/// Semantic phase of the timer used to drive external side effects
/// (ESP32 LEDs, smart bulbs, MQTT, etc.). Decoupled from [SessionState]
/// so that a paused timer can be represented as its own phase.
enum TimerPhase { activity, rest, inactivity, paused }

extension TimerPhaseMapping on TimerPhase {
  static TimerPhase fromState(SessionState state, {required bool isPaused}) {
    if (isPaused && state.hasTimer()) {
      return TimerPhase.paused;
    }

    return switch (state) {
      SessionState.activity => TimerPhase.activity,
      SessionState.rest => TimerPhase.rest,
      SessionState.inactivity => TimerPhase.inactivity,
    };
  }
}
