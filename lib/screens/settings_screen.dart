import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/providers/session_provider.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/providers/pomodoro_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(sessionProvider);
    final timerColors = Theme.of(context).extension<TimerColors>()!;
    final settings = ref.watch(pomodoroSettingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n().t.settingsScreenTitle, style: AppTextStyles.title),
        backgroundColor: timer.state.colorLevel(timerColors),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${L10n().t.sessionDurationLabel} ${settings.sessionDuration ~/ 60} ${L10n().t.unitShort_minute}',
              style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: settings.sessionDuration.toDouble(),
              min: SessionState.activity.minDuration.toDouble(),
              max: SessionState.activity.maxDuration.toDouble(),
              onChanged: (value) {
                ref.read(pomodoroSettingsProvider.notifier).updateSessionDuration(value.toInt());
              },
            ),
            const SizedBox(height: 16),
            Text(
              '${L10n().t.restDurationLabel} ${settings.breakDuration ~/ 60} ${L10n().t.unitShort_minute}',
              style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: settings.breakDuration.toDouble(),
              min: SessionState.rest.minDuration.toDouble(),
              max: SessionState.rest.maxDuration.toDouble(),
              onChanged: (value) {
                ref.read(pomodoroSettingsProvider.notifier).updateBreakDuration(value.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }
}
