import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pomodoro_sczuw/enums/timer_phase.dart';
import 'package:pomodoro_sczuw/services/integrations/abstract/integration.dart';
import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';

/// Drives an ESP32 RGB LED over HTTP from session status / pause / resume events.
///
/// Behaviour:
/// - Any phase change: yellow for 0.5s, then the phase pattern.
/// - Activity: steady green.
/// - Inactivity: off.
/// - Rest: alternates green / yellow every 0.5s.
/// - Paused: yellow immediately, no transition flash.
class Esp32LedIntegration implements Integration {
  static const Duration _transitionDuration = Duration(milliseconds: 500);
  static const Duration _restAlternationInterval = Duration(milliseconds: 500);

  static const String _greenEndpoint = '/green';
  static const String _yellowEndpoint = '/yellow';
  static const String _offEndpoint = '/off';

  final Dio _dio;
  final String _baseUrl;

  Timer? _transitionTimer;
  Timer? _restAlternationTimer;
  bool _restShowsGreen = true;
  int _generation = 0;
  Future<void> _requestQueue = Future.value();
  TimerPhase? _lastPhase;

  Esp32LedIntegration({required String baseUrl, Dio? dio})
    : _baseUrl = _normalizeBaseUrl(baseUrl),
      _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 2),
              receiveTimeout: const Duration(seconds: 2),
              sendTimeout: const Duration(seconds: 2),
            ),
          );

  @override
  String get id => 'esp32_led';

  static String _normalizeBaseUrl(String url) => url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  @override
  Future<void> handle(IntegrationEvent event) async {
    final phase = switch (event) {
      SessionStatusChanged(:final to) => TimerPhaseMapping.fromState(to, isPaused: false),
      SessionPaused(:final state) => TimerPhaseMapping.fromState(state, isPaused: true),
      SessionResumed(:final state) => TimerPhaseMapping.fromState(state, isPaused: false),
      SessionCompleted() || UserActionPressed() || PageNavigated() => null,
    };

    if (phase == null) return;

    final force = event is SessionPaused || event is SessionResumed;
    if (!force && phase == _lastPhase) return;
    _lastPhase = phase;

    await _onPhaseChanged(phase);
  }

  Future<void> _onPhaseChanged(TimerPhase phase) async {
    final generation = ++_generation;
    _cancelTimers();

    if (phase == TimerPhase.paused) {
      await _send(_yellowEndpoint, generation: generation);
      return;
    }

    await _send(_yellowEndpoint, generation: generation);

    _transitionTimer = Timer(_transitionDuration, () {
      if (generation != _generation) return;
      _applyPhasePattern(phase, generation: generation);
    });
  }

  void _applyPhasePattern(TimerPhase phase, {required int generation}) {
    if (generation != _generation) return;

    switch (phase) {
      case TimerPhase.activity:
        _send(_greenEndpoint, generation: generation);
      case TimerPhase.inactivity:
        _send(_offEndpoint, generation: generation);
      case TimerPhase.rest:
        _startRestAlternation(generation: generation);
      case TimerPhase.paused:
        _send(_yellowEndpoint, generation: generation);
    }
  }

  void _startRestAlternation({required int generation}) {
    _restShowsGreen = true;
    _send(_greenEndpoint, generation: generation);

    _restAlternationTimer = Timer.periodic(_restAlternationInterval, (_) {
      if (generation != _generation) return;

      _restShowsGreen = !_restShowsGreen;
      _send(_restShowsGreen ? _greenEndpoint : _yellowEndpoint, generation: generation);
    });
  }

  Future<void> _send(String endpoint, {required int generation}) {
    if (generation != _generation) return Future.value();

    _requestQueue = _requestQueue.then((_) async {
      if (generation != _generation) return;

      try {
        await _dio.get('$_baseUrl$endpoint');
      } catch (_) {}
    });

    return _requestQueue;
  }

  void _cancelTimers() {
    _transitionTimer?.cancel();
    _transitionTimer = null;
    _restAlternationTimer?.cancel();
    _restAlternationTimer = null;
  }

  @override
  Future<void> dispose() async {
    ++_generation;
    _cancelTimers();
    await _requestQueue;
    _dio.close(force: true);
  }
}
