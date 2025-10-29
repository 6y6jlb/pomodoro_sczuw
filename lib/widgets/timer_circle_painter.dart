import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';

class TimerCirclePainter extends CustomPainter {
  final double progress;
  final Color fillColor;
  final String timeText;
  final Color? backgroundColor;

  TimerCirclePainter({
    required this.progress,
    required this.fillColor,
    required this.timeText,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final backgroundPaint =
        Paint()
          ..color = backgroundColor ?? Colors.grey[300]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.141592 * progress; // Угол заполнения
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592 / 2, // Начинаем с верхней точки
      sweepAngle,
      false,
      progressPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: timeText,
        style: AppTextStyles.timer.copyWith(color: fillColor),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
