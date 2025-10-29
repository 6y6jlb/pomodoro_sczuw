import 'package:flutter/material.dart';

class TimerColors extends ThemeExtension<TimerColors> {
  final Color activity;
  final Color inactivity;
  final Color rest;
  final Color restDelay;

  TimerColors({required this.activity, required this.inactivity, required this.rest, required this.restDelay});

  @override
  ThemeExtension<TimerColors> copyWith({Color? activity, Color? inactivity, Color? rest, Color? restDelay}) {
    return TimerColors(
      activity: activity ?? this.activity,
      inactivity: inactivity ?? this.inactivity,
      rest: rest ?? this.rest,
      restDelay: restDelay ?? this.restDelay,
    );
  }

  @override
  ThemeExtension<TimerColors> lerp(ThemeExtension<TimerColors>? other, double t) {
    if (other is! TimerColors) return this;
    return TimerColors(
      activity: Color.lerp(activity, other.activity, t)!,
      inactivity: Color.lerp(inactivity, other.inactivity, t)!,
      rest: Color.lerp(rest, other.rest, t)!,
      restDelay: Color.lerp(restDelay, other.restDelay, t)!,
    );
  }
}
