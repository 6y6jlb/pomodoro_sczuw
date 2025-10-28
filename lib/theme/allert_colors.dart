import 'package:flutter/material.dart';

class AlertColors extends ThemeExtension<AlertColors> {
  final Color info;
  final Color warning;
  final Color success;
  final Color danger;

  AlertColors({required this.info, required this.warning, required this.success, required this.danger});

  @override
  ThemeExtension<AlertColors> copyWith({Color? info, Color? warning, Color? success, Color? danger}) {
    return AlertColors(
      info: info ?? this.info,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      danger: danger ?? this.danger,
    );
  }

  @override
  ThemeExtension<AlertColors> lerp(ThemeExtension<AlertColors>? other, double t) {
    if (other is! AlertColors) return this;
    return AlertColors(
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}
