import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';

class PomodoroSettingsNotifier extends Notifier<PomodoroSettings> {
  @override
  PomodoroSettings build() {
    return PomodoroSettings.initial();
  }

  void updateSessionDuration(int duration) {
    state = state.copyWith(sessionDuration: duration);
  }

  void updateBreakDuration(int duration) {
    state = state.copyWith(breakDuration: duration);
  }
}

final pomodoroSettingsProvider = NotifierProvider<PomodoroSettingsNotifier, PomodoroSettings>(() {
  return PomodoroSettingsNotifier();
});