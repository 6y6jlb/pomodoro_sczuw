import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/providers/session_provider.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/widgets/animated_circle_timer.dart';

class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(sessionProvider);
    final timerNotifier = ref.read(sessionProvider.notifier);
    final timerColors = Theme.of(context).extension<TimerColors>()!;

    ButtonStyle commonButtonStyles = ElevatedButton.styleFrom(minimumSize: const Size(100, 36));

    Widget buildBottomActionWidget() {
      if (timer.state.isInactive()) {
        return ElevatedButton(
          style: commonButtonStyles.copyWith(backgroundColor: WidgetStateProperty.all(timerColors.inactivity)),
          onPressed: null,
          child: Text(L10n().t.action_stop, style: AppTextStyles.action.copyWith(color: Colors.blueGrey[200])),
        );
      }

      return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              if (timer.state.hasTimer() && timer.isRunning)
                ElevatedButton(
                  style: commonButtonStyles.copyWith(backgroundColor: WidgetStateProperty.all(timerColors.pause)),
                  onPressed: () => timerNotifier.pause(),
                  child: Text(L10n().t.action_pause, style: AppTextStyles.action.copyWith(color: Colors.white)),
                ),
              if (timer.state.hasTimer() && timer.isPaused && timer.currentSeconds > 0)
                ElevatedButton(
                  style: commonButtonStyles.copyWith(backgroundColor: WidgetStateProperty.all(timerColors.resume)),
                  onPressed: () => timerNotifier.resume(),
                  child: Text(L10n().t.action_resume, style: AppTextStyles.action.copyWith(color: Colors.white)),
                ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: commonButtonStyles.copyWith(backgroundColor: WidgetStateProperty.all(timerColors.inactivity)),
                onPressed: () => timerNotifier.changeStateToInactivity(),
                child: Text(L10n().t.action_stop, style: AppTextStyles.action.copyWith(color: Colors.white)),
              ),
            ],
          ),
          if (timer.state.hasTimer()) const SizedBox(height: 8),
          ElevatedButton(
            style: commonButtonStyles.copyWith(backgroundColor: WidgetStateProperty.all(timerColors.postpone)),
            onPressed: () => timerNotifier.postpone(),
            child: Text(L10n().t.action_postpone, style: AppTextStyles.action.copyWith(color: Colors.white)),
          ),
        ],
      );
    }

    Widget buildUpperActionWidget() {
      TextStyle commonTextStyles = AppTextStyles.action.copyWith(color: Colors.white);

      final nextState = timer.state.next();

      return ElevatedButton(
        style: commonButtonStyles.copyWith(backgroundColor: WidgetStateProperty.all(nextState.colorLevel(timerColors))),
        onPressed: () => timerNotifier.changeStateToNext(),
        child: Text(nextState.actionLabel(), style: commonTextStyles),
      );
    }

    return AnimatedCircleTimer(
      key: ValueKey('${timer.state}_${timer.isRunning}'),
      fillColor: timer.state.colorLevel(timerColors),
      totalSeconds: timer.totalSeconds,
      remainingSeconds: timer.currentSeconds,
      progress: timer.progress,
      bottomWidget: buildBottomActionWidget(),
      upperWidget: buildUpperActionWidget(),
    );
  }
}
