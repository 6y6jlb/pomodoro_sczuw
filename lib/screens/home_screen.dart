import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/providers/app_version_provider.dart';
import 'package:pomodoro_sczuw/providers/session_provider.dart';
import 'package:pomodoro_sczuw/screens/settings_screen.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/utils/consts/integration_constant.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:pomodoro_sczuw/widgets/joke_widget.dart';
import 'package:pomodoro_sczuw/widgets/timer_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(sessionProvider);
    final timerColors = Theme.of(context).extension<TimerColors>()!;
    final versionAsync = ref.watch(appVersionLabelProvider);
    final versionLabel = versionAsync.when(
      data: (label) => label,
      loading: () => '…',
      error: (error, stackTrace) => 'v?',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(timer.state.label(), style: AppTextStyles.title),
        backgroundColor: timer.state.colorLevel(timerColors),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: IntegrationConstant.settingsRouteName),
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: material.Icon(material.Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TimerWidget(),
                    const SizedBox(height: 30),
                    JokeWidget(backgroundColor: timer.state.colorLevel(timerColors), textColor: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                versionLabel,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
