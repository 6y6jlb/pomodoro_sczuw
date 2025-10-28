import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/theme/processing_colors.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';

enum ProcessingState { rest, activity, inactivity, restDelay }

extension HasTimer on ProcessingState {
  bool hasTimer() {
    return [
      ProcessingState.rest,
      ProcessingState.activity,
      ProcessingState.restDelay,
    ].contains(this);
  }
}

extension Label on ProcessingState {
  String label() {
    var labels = {
      ProcessingState.activity: I10n().t.processingStateLabel_activity,
      ProcessingState.inactivity: I10n().t.processingStateLabel_inactivity,
      ProcessingState.rest: I10n().t.processingStateLabel_rest,
      ProcessingState.restDelay: I10n().t.processingStateLabel_restDelay,
    };
    return labels[this] ?? I10n().t.processingStateLabel_unknown;
  }
}

extension ColorLevel on ProcessingState {
  Color colorLevel(ProcessingColors colors) {
    Map<ProcessingState, Color> colorLevels = {
      ProcessingState.activity: colors.activity,
      ProcessingState.inactivity: colors.inactivity,
      ProcessingState.rest: colors.rest,
      ProcessingState.restDelay: colors.restDelay,
    };
    return colorLevels[this] ?? Colors.blueGrey;
  }
}

extension TypeCheck on ProcessingState {
  bool isInactive() {
    return this == ProcessingState.inactivity;
  }

  bool isActive() {
    return this == ProcessingState.activity;
  }

  bool isRestDelay() {
    return this == ProcessingState.restDelay;
  }

  bool isRest() {
    return this == ProcessingState.rest;
  }
}
