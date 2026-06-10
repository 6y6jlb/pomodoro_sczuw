import 'package:dio/dio.dart';
import 'package:pomodoro_sczuw/enums/timer_phase.dart';
import 'package:pomodoro_sczuw/services/side_effects/abstract/state_side_effect.dart';

/// Drives an ESP32 RGB LED over HTTP. Each timer phase maps to an endpoint
/// (e.g. `GET http://192.168.0.102/red`). Requests are fire-and-forget with a
/// short timeout so an unreachable device never blocks or breaks the timer.
class Esp32LedSideEffect implements StateSideEffect {
  final Dio _dio;
  final String _baseUrl;
  final Map<TimerPhase, String> _phaseEndpoints;

  Esp32LedSideEffect({required String baseUrl, Map<TimerPhase, String>? phaseEndpoints, Dio? dio})
    : _baseUrl = _normalizeBaseUrl(baseUrl),
      _phaseEndpoints = phaseEndpoints ?? _defaultPhaseEndpoints,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 2),
              receiveTimeout: const Duration(seconds: 2),
              sendTimeout: const Duration(seconds: 2),
            ),
          );

  static const Map<TimerPhase, String> _defaultPhaseEndpoints = {
    TimerPhase.activity: '/red',
    TimerPhase.rest: '/green',
    TimerPhase.paused: '/yellow',
    TimerPhase.inactivity: '/off',
  };

  static String _normalizeBaseUrl(String url) => url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  @override
  Future<void> onPhaseChanged(TimerPhase phase) async {
    final endpoint = _phaseEndpoints[phase];
    if (endpoint == null) return;

    try {
      print('$_baseUrl$endpoint');
      await _dio.get('$_baseUrl$endpoint');
    } catch (e) {
      print('Esp32LedSideEffect failed for phase $phase: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _dio.close(force: true);
  }
}
