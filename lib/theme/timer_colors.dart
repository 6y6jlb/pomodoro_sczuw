import 'package:flutter/material.dart';

class TimerColors extends ThemeExtension<TimerColors> {
  final Color activity;
  final Color inactivity;
  final Color rest;
  final Color pause;
  final Color postpone;
  final Color resume;

  TimerColors({required this.activity, required this.inactivity, required this.rest, required this.pause, required this.postpone, required this.resume});

  @override
  ThemeExtension<TimerColors> copyWith({Color? activity, Color? inactivity, Color? rest, Color? pause, Color? postpone, Color? resume}) {
    return TimerColors(
      activity: activity ?? this.activity,
      inactivity: inactivity ?? this.inactivity,
      rest: rest ?? this.rest,
      pause: pause ?? this.pause,
      postpone: postpone ?? this.postpone,
      resume: resume ?? this.resume,
    );
  }

  @override
  ThemeExtension<TimerColors> lerp(ThemeExtension<TimerColors>? other, double t) {
    if (other is! TimerColors) return this;
    return TimerColors(
      activity: Color.lerp(activity, other.activity, t)!,
      inactivity: Color.lerp(inactivity, other.inactivity, t)!,
      rest: Color.lerp(rest, other.rest, t)!,
      pause: Color.lerp(pause, other.pause, t)!,
      postpone: Color.lerp(postpone, other.postpone, t)!,
      resume: Color.lerp(resume, other.resume, t)!,
    );
  }
}
