import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_sczuw/services/hive_service.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/utils/consts/app_theme_preference.dart';
import 'package:pomodoro_sczuw/utils/consts/sound_preset.dart';

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

  Future<void> updateTelegramEnabled(bool enabled) async {
    final currentState = state.value;
    if (currentState == null) return;

    await _saveSettings(currentState.copyWith(telegramEnabled: enabled));
  }

  Future<void> updateTelegramBotToken(String token) async {
    final currentState = state.value;
    if (currentState == null) return;

    await _saveSettings(currentState.copyWith(telegramBotToken: token));
  }

  Future<void> updateTelegramChatId(String chatId) async {
    final currentState = state.value;
    if (currentState == null) return;

    await _saveSettings(currentState.copyWith(telegramChatId: chatId));
  }

  Future<void> updateRestOverlayEnabled(bool enabled) async {
    final currentState = state.value;
    if (currentState == null) return;

    await _saveSettings(currentState.copyWith(restOverlayEnabled: enabled));
  }

  Future<void> updateSoundUserAction(String soundKey) async {
    await _updateSoundField((settings) => settings.copyWith(soundUserAction: soundKey));
  }

  Future<void> updateSoundSessionComplete(String soundKey) async {
    await _updateSoundField((settings) => settings.copyWith(soundSessionComplete: soundKey));
  }

  Future<void> updateSoundStateActivity(String soundKey) async {
    await _updateSoundField((settings) => settings.copyWith(soundStateActivity: soundKey));
  }

  Future<void> updateSoundStateRest(String soundKey) async {
    await _updateSoundField((settings) => settings.copyWith(soundStateRest: soundKey));
  }

  Future<void> updateSoundStateInactivity(String soundKey) async {
    await _updateSoundField((settings) => settings.copyWith(soundStateInactivity: soundKey));
  }

  Future<void> updateThemeMode(String themeMode) async {
    final currentState = state.value;
    if (currentState == null) return;
    if (!AppThemePreference.isAllowed(themeMode)) return;

    await _saveSettings(currentState.copyWith(themeMode: themeMode));
  }

  Future<void> _updateSoundField(
    PomodoroSettings Function(PomodoroSettings current) update,
  ) async {
    final currentState = state.value;
    if (currentState == null) return;

    final newSettings = update(currentState);
    if (!_areSoundKeysAllowed(newSettings)) return;

    await _saveSettings(newSettings);
  }

  bool _areSoundKeysAllowed(PomodoroSettings settings) {
    return SoundPreset.isAllowed(settings.soundUserAction) &&
        SoundPreset.isAllowed(settings.soundSessionComplete) &&
        SoundPreset.isAllowed(settings.soundStateActivity) &&
        SoundPreset.isAllowed(settings.soundStateRest) &&
        SoundPreset.isAllowed(settings.soundStateInactivity);
  }

  Future<void> resetSessionDurationsToDefaults() async {
    final currentState = state.value;
    if (currentState == null) return;

    await _saveSettings(
      currentState.copyWith(
        sessionDuration: SessionState.activity.defaultDuration,
        breakDuration: SessionState.rest.defaultDuration,
      ),
    );
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
