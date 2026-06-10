import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pomodoro_sczuw/enums/timer_phase.dart';
import 'package:pomodoro_sczuw/services/side_effects/abstract/state_side_effect.dart';

/// Drives an ESP32 RGB LED over HTTP.
///
/// Behaviour:
/// - Any phase change: yellow for 0.5s, then the phase pattern.
/// - Activity: steady green.
/// - Inactivity: off.
/// - Rest: alternates green / yellow every 0.5s.
/// - Paused: yellow immediately, no transition flash.
class Esp32LedSideEffect implements StateSideEffect {
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

  Esp32LedSideEffect({required String baseUrl, Dio? dio})
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

  static String _normalizeBaseUrl(String url) => url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  @override
  Future<void> onPhaseChanged(TimerPhase phase) async {
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
