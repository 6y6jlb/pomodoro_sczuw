import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/providers/session_provider.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';
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

    ButtonStyle commonButtonStyles = ElevatedButton.styleFrom(
      backgroundColor: timer.state.colorLevel(timerColors),
      minimumSize: const Size(100, 36),
    );

    Widget buildBottomActionWidget() {
      if (timer.state.isInactive()) {
        return ElevatedButton(
          style: commonButtonStyles.copyWith(backgroundColor: WidgetStateProperty.all(Colors.grey)),
          onPressed: null,
          child: Text(I10n().t.action_stop, style: AppTextStyles.action.copyWith(color: Colors.white)),
        );
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (timer.state.hasTimer() && timer.isRunning)
            ElevatedButton(
              style: commonButtonStyles,
              onPressed: () => timerNotifier.pause(),
              child: Text(I10n().t.action_pause, style: AppTextStyles.action.copyWith(color: Colors.white)),
            ),
          if (timer.state.hasTimer() && !timer.isRunning && timer.currentSeconds > 0)
            ElevatedButton(
              style: commonButtonStyles,
              onPressed: () => timerNotifier.resume(),
              child: Text(I10n().t.action_continue, style: AppTextStyles.action.copyWith(color: Colors.white)),
            ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: commonButtonStyles,
            onPressed: () => timerNotifier.changeStateToInactivity(),
            child: Text(I10n().t.action_stop, style: AppTextStyles.action.copyWith(color: Colors.white)),
          ),
        ],
      );
    }

    Widget buildUpperActionWidget() {
      TextStyle commonTextStyles = AppTextStyles.action.copyWith(color: Colors.white);

      if (timer.state.isRest()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => timerNotifier.changeState(SessionState.activity),
          child: Text(I10n().t.action_continue, style: commonTextStyles),
        );
      } else if (timer.state.isInactive()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => timerNotifier.changeState(SessionState.activity),
          child: Text(I10n().t.action_start, style: commonTextStyles),
        );
      } else if (timer.state.isActive()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => timerNotifier.changeState(SessionState.rest),
          child: Text(I10n().t.action_rest, style: commonTextStyles),
        );
      } else {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => timerNotifier.changeStateToNext(),
          child: Text(I10n().t.action_skip, style: commonTextStyles),
        );
      }
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
