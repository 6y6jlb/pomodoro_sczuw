import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';
import 'package:pomodoro_sczuw/utils/consts/settings_constant.dart';

enum SessionState { rest, activity, inactivity, restDelay }

extension HasTimer on SessionState {
  bool hasTimer() {
    return [SessionState.rest, SessionState.activity, SessionState.restDelay].contains(this);
  }
}

extension Label on SessionState {
  String label() {
    var labels = {
      SessionState.activity: I10n().t.timerStateLabel_activity,
      SessionState.inactivity: I10n().t.timerStateLabel_inactivity,
      SessionState.rest: I10n().t.timerStateLabel_rest,
      SessionState.restDelay: I10n().t.timerStateLabel_restDelay,
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
      SessionState.restDelay: colors.restDelay,
    };
    return colorLevels[this] ?? Colors.blueGrey;
  }
}

extension Icon on SessionState {
  String icon() {
    Map<SessionState, String> icons = {
       SessionState.activity: 'assets/images/pomodoro_app_icon_green.png',
      SessionState.inactivity: 'assets/images/pomodoro_app_icon_gray.png',
      SessionState.rest: 'assets/images/pomodoro_app_icon_blue.png',
      SessionState.restDelay: 'assets/images/pomodoro_app_icon_purple.png',
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

  bool isRestDelay() {
    return this == SessionState.restDelay;
  }

  bool isRest() {
    return this == SessionState.rest;
  }
}

extension NextState on SessionState {
  SessionState next() {
    if (isRest()) {
      return SessionState.activity;
    } else if (isRestDelay()) {
      return SessionState.rest;
    } else {
      return SessionState.restDelay;
    }
  }
}

extension DefaultSessionDuration on SessionState {
  int get defaultDuration => SettingsConstant.sessionDurationInSeconds[this]!;
}
