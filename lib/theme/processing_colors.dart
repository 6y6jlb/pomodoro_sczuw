import 'package:flutter/material.dart';

class ProcessingColors extends ThemeExtension<ProcessingColors> {
  final Color activity;
  final Color inactivity;
  final Color rest;
  final Color restDelay;

  ProcessingColors({required this.activity, required this.inactivity, required this.rest, required this.restDelay});

  @override
  ThemeExtension<ProcessingColors> copyWith({Color? activity, Color? inactivity, Color? rest, Color? restDelay}) {
    return ProcessingColors(
      activity: activity ?? this.activity,
      inactivity: inactivity ?? this.inactivity,
      rest: rest ?? this.rest,
      restDelay: restDelay ?? this.restDelay,
    );
  }

  @override
  ThemeExtension<ProcessingColors> lerp(ThemeExtension<ProcessingColors>? other, double t) {
    if (other is! ProcessingColors) return this;
    return ProcessingColors(
      activity: Color.lerp(activity, other.activity, t)!,
      inactivity: Color.lerp(inactivity, other.inactivity, t)!,
      rest: Color.lerp(rest, other.rest, t)!,
      restDelay: Color.lerp(restDelay, other.restDelay, t)!,
    );
  }
}
