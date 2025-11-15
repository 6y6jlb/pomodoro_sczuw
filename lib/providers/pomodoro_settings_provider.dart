import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_sczuw/services/hive_service.dart';
import 'package:pomodoro_sczuw/utils/consts/settings_constant.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';

/// Notifier для управления настройками Pomodoro с автоматическим сохранением в Hive
class PomodoroSettingsNotifier extends AsyncNotifier<PomodoroSettings> {
  static const String _boxName = 'pomodoro_settings';
  static const String _settingsKey = 'settings';

  late final Box<PomodoroSettings> _settingsBox;

  @override
  Future<PomodoroSettings> build() async {
    _settingsBox = await HiveService.openBox<PomodoroSettings>(_boxName);

    final settings = _settingsBox.get(_settingsKey);

    if (settings != null) {
      return settings;
    }

    final initialSettings = PomodoroSettings.initial();
    await _settingsBox.put(_settingsKey, initialSettings);
    return initialSettings;
  }

  Future<void> updateSessionDuration(int duration) async {
    final currentState = state.value;
    if (currentState == null) return;
    if (duration < SessionState.activity.minDuration) return;
    final newSettings = currentState.copyWith(sessionDuration: duration);
    await _saveSettings(newSettings);
  }

  Future<void> updateBreakDuration(int duration) async {
    final currentState = state.value;
    if (currentState == null) return;
    if (duration < SessionState.rest.minDuration) return;

    final newSettings = currentState.copyWith(breakDuration: duration);
    await _saveSettings(newSettings);
  }

  Future<void> resetToDefaults() async {
    final initialSettings = PomodoroSettings.initial();
    await _saveSettings(initialSettings);
  }

  /// Внутренний метод для сохранения настроек
  Future<void> _saveSettings(PomodoroSettings settings) async {
    try {
      await _settingsBox.put(_settingsKey, settings);
      state = AsyncValue.data(settings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final pomodoroSettingsProvider = AsyncNotifierProvider<PomodoroSettingsNotifier, PomodoroSettings>(() {
  return PomodoroSettingsNotifier();
});
