import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/widgets/timer_circle_painter.dart';

class AnimatedCircleTimer extends StatelessWidget {
  final Color fillColor;
  final Widget? upperWidget;
  final Widget? bottomWidget;
  final int totalSeconds;
  final int remainingSeconds;
  final double progress;

  const AnimatedCircleTimer({
    super.key,
    required this.fillColor,
    this.upperWidget,
    this.bottomWidget,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.progress,
  });

  String _formatTime(int seconds) {
    if (seconds >= 3600) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatTime(remainingSeconds);

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: CustomPaint(
            size: const Size(250, 250),
            painter: TimerCirclePainter(
              progress: progress,
              fillColor: fillColor,
              timeText: formattedTime,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
        if (upperWidget != null)
          Positioned(
            top: 32,
            child: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: upperWidget!),
          ),
        if (bottomWidget != null)
          Positioned(
            bottom: 32,
            child: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: bottomWidget!),
          ),
      ],
    );
  }
}
