import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';
import 'package:pomodoro_sczuw/utils/consts/settings_constant.dart';

enum SessionState { rest, activity, inactivity }

extension HasTimer on SessionState {
  bool hasTimer() {
    return [SessionState.rest, SessionState.activity].contains(this);
  }
}

extension Label on SessionState {
  String label() {
    var labels = {
      SessionState.activity: I10n().t.timerStateLabel_activity,
      SessionState.inactivity: I10n().t.timerStateLabel_inactivity,
      SessionState.rest: I10n().t.timerStateLabel_rest,
    };
    return labels[this] ?? I10n().t.timerStateLabel_unknown;
  }
}

extension ColorLevel on SessionState {
  Color colorLevel(TimerColors colors) {
    Map<SessionState, Color> colorLevels = {
      SessionState.activity: colors.activity,
      SessionState.inactivity: colors.inactivity,
      SessionState.rest: colors.rest,
    };
    return colorLevels[this] ?? Colors.blueGrey;
  }
}

extension Icon on SessionState {
  String icon() {
    Map<SessionState, String> icons = {
      SessionState.activity: 'assets/images/pomodoro_app_icon_red.png',
      SessionState.inactivity: 'assets/images/pomodoro_app_icon_gray.png',
      SessionState.rest: 'assets/images/pomodoro_app_icon_green.png',
    };
    return icons[this] ?? 'assets/images/pomodoro_app_icon_gray.png';
  }
}

extension TypeCheck on SessionState {
  bool isInactive() {
    return this == SessionState.inactivity;
  }

  bool isActive() {
    return this == SessionState.activity;
  }

  bool isRest() {
    return this == SessionState.rest;
  }
}

extension NextState on SessionState {
  SessionState next() {
    return switch (this) {
      SessionState.activity => SessionState.rest,
      SessionState.inactivity => SessionState.activity,
      SessionState.rest => SessionState.activity,
    };
  }
}

extension DefaultSessionDuration on SessionState {
  int get defaultDuration => SettingsConstant.sessionDurationInSeconds[this]!;
}
