import 'package:pomodoro_sczuw/enums/page_navigation_action.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/enums/user_action.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';

sealed class IntegrationEvent {
  const IntegrationEvent();
}

final class SessionStatusChanged extends IntegrationEvent {
  final SessionState from;
  final SessionState to;
  final PomodoroSession session;

  const SessionStatusChanged({
    required this.from,
    required this.to,
    required this.session,
  });
}

final class SessionPaused extends IntegrationEvent {
  final SessionState state;
  final PomodoroSession session;

  const SessionPaused({required this.state, required this.session});
}

final class SessionResumed extends IntegrationEvent {
  final SessionState state;
  final PomodoroSession session;

  const SessionResumed({required this.state, required this.session});
}

final class SessionCompleted extends IntegrationEvent {
  final SessionState completedState;
  final PomodoroSession session;

  const SessionCompleted({
    required this.completedState,
    required this.session,
  });
}

final class UserActionPressed extends IntegrationEvent {
  final UserAction action;
  final int? durationSeconds;

  const UserActionPressed({
    required this.action,
    this.durationSeconds,
  });
}

final class PageNavigated extends IntegrationEvent {
  final String? fromRouteName;
  final String? toRouteName;
  final PageNavigationAction action;

  const PageNavigated({
    required this.fromRouteName,
    required this.toRouteName,
    required this.action,
  });
}
