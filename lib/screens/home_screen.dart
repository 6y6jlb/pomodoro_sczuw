import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/enums/timer_state.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:pomodoro_sczuw/widgets/joke_widget.dart';
import 'package:pomodoro_sczuw/widgets/timer_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    final timerColors = Theme.of(context).extension<TimerColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text(timer.state.label(), style: AppTextStyles.title),
        backgroundColor: timer.state.colorLevel(timerColors),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerWidget(),
                const SizedBox(height: 30),
                JokeWidget(backgroundColor: timer.state.colorLevel(timerColors), textColor: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
