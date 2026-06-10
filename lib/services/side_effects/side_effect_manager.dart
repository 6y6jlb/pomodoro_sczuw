import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/timer_phase.dart';
import 'package:pomodoro_sczuw/services/side_effects/abstract/state_side_effect.dart';

/// Fans out timer phase changes to every registered [StateSideEffect].
/// Adding a new integration (smart bulb, MQTT, serial, ...) is just adding
/// another implementation to the list this manager is constructed with.
class SideEffectManager {
  final List<StateSideEffect> _sideEffects;
  TimerPhase? _lastDispatchedPhase;

  SideEffectManager(this._sideEffects);

  void handleStateChanged(SessionState newState) {
    _dispatch(TimerPhaseMapping.fromState(newState, isPaused: false));
  }

  void handlePaused(SessionState currentState) {
    _dispatch(TimerPhaseMapping.fromState(currentState, isPaused: true));
  }

  void handleResumed(SessionState currentState) {
    _dispatch(TimerPhaseMapping.fromState(currentState, isPaused: false));
  }

  void _dispatch(TimerPhase phase) {
    if (phase == _lastDispatchedPhase) return;
    _lastDispatchedPhase = phase;

    for (final sideEffect in _sideEffects) {
      sideEffect.onPhaseChanged(phase);
    }
  }

  Future<void> dispose() async {
    for (final sideEffect in _sideEffects) {
      await sideEffect.dispose();
    }
  }
}
