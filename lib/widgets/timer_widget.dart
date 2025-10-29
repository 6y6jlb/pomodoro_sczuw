import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:pomodoro_sczuw/enums/timer_state.dart';
import 'package:pomodoro_sczuw/widgets/animated_circle_timer.dart';

class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final timerColors = Theme.of(context).extension<TimerColors>()!;

    ButtonStyle commonButtonStyles = ElevatedButton.styleFrom(backgroundColor: timer.state.colorLevel(timerColors));

    Widget buildBottomActionWidget() {
      return ElevatedButton(
        style: commonButtonStyles,
        onPressed: timer.state.hasTimer() ? () => timerNotifier.changeState(TimerState.inactivity) : null,
        child: Text(I10n().t.action_stop, style: AppTextStyles.action.copyWith(color: Colors.white)),
      );
    }

    Widget buildUpperActionWidget() {
      TextStyle commonTextStyles = AppTextStyles.action.copyWith(color: Colors.white);

      if (timer.state.isRest()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => timerNotifier.changeState(TimerState.activity),
          child: Text(I10n().t.action_continue, style: commonTextStyles),
        );
      } else if (timer.state.isInactive()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => timerNotifier.changeState(TimerState.activity),
          child: Text(I10n().t.action_start, style: commonTextStyles),
        );
      } else {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => timerNotifier.changeState(TimerState.rest),
          child: Text(I10n().t.action_rest, style: commonTextStyles),
        );
      }
    }

    return AnimatedCircleTimer(
      key: ValueKey(timer.state),
      fillColor: timer.state.colorLevel(timerColors),
      bottomWidget: buildBottomActionWidget(),
      upperWidget: buildUpperActionWidget(),
    );
  }
}
