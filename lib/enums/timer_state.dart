import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';

enum TimerState { rest, activity, inactivity, restDelay }

extension HasTimer on TimerState {
  bool hasTimer() {
    return [
      TimerState.rest,
      TimerState.activity,
      TimerState.restDelay,
    ].contains(this);
  }
}

extension Label on TimerState {
  String label() {
    var labels = {
      TimerState.activity: I10n().t.timerStateLabel_activity,
      TimerState.inactivity: I10n().t.timerStateLabel_inactivity,
      TimerState.rest: I10n().t.timerStateLabel_rest,
      TimerState.restDelay: I10n().t.timerStateLabel_restDelay,
    };
    return labels[this] ?? I10n().t.timerStateLabel_unknown;
  }
}

extension ColorLevel on TimerState {
  Color colorLevel(TimerColors colors) {
    Map<TimerState, Color> colorLevels = {
      TimerState.activity: colors.activity,
      TimerState.inactivity: colors.inactivity,
      TimerState.rest: colors.rest,
      TimerState.restDelay: colors.restDelay,
    };
    return colorLevels[this] ?? Colors.blueGrey;
  }
}

extension TypeCheck on TimerState {
  bool isInactive() {
    return this == TimerState.inactivity;
  }

  bool isActive() {
    return this == TimerState.activity;
  }

  bool isRestDelay() {
    return this == TimerState.restDelay;
  }

  bool isRest() {
    return this == TimerState.rest;
  }
}

extension NextState on TimerState {
  TimerState next() {
    if (isRest()) {
      return TimerState.activity;
    } else if (isRestDelay()) {
      return TimerState.rest;
    } else {
      return TimerState.restDelay;
    }
  }
}