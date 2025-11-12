// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settingsScreenTitle => 'Настройки';

  @override
  String get timerStateLabel_activity => 'Активно';

  @override
  String get timerStateLabel_inactivity => 'Неактивно';

  @override
  String get timerStateLabel_rest => 'Перерыв';

  @override
  String get timerStateLabel_unknown => 'Неизвестно';

  @override
  String get pomodoroModeLabel_custom => 'Пользовательский';

  @override
  String get pomodoroModeLabel_schedule => 'Расписание';

  @override
  String get operationModeLabel => 'Режим:';

  @override
  String get sessionDurationLabel => 'Длительность сессии:';

  @override
  String get restDurationLabel => 'Длительность перерыва:';

  @override
  String get action_stop => 'Стоп';

  @override
  String get action_start => 'Старт';

  @override
  String get action_continue => 'Продолжить';

  @override
  String get action_resume => 'Возобновить';

  @override
  String get action_postpone => '+5мин';

  @override
  String get action_rest => 'Перерыв';

  @override
  String get action_break => 'Отдых';

  @override
  String get action_confirm => 'Подтвердить';

  @override
  String get action_pause => 'Пауза';

  @override
  String get action_unknown => 'Неизвестно';

  @override
  String get unitShort_minute => 'мин.';

  @override
  String get unitShort_seconds => 'с.';

  @override
  String get unitShort_hours => 'ч.';

  @override
  String get unitShort_days => 'д.';

  @override
  String get timerLabel => 'Таймер';

  @override
  String get scheduleStateLabel_active => 'Рассписание: активно';

  @override
  String get scheduleStateLabel_inactive => 'Рассписание: неактивно';

  @override
  String get scheduleHasNotActiveDay => 'Нет активных дней в расписании';

  @override
  String scheduleWillStartAt(Object day, Object time) {
    return 'Расписание начнется: $day в $time';
  }

  @override
  String scheduleWillEndAt(Object time) {
    return 'Расписание закончится: $time';
  }

  @override
  String get scheduleScheduleModeDescription => 'Настройте активные дни и часы — таймер будет работать только тогда, когда нужно.';

  @override
  String get scheduleCustomModeDescription => 'Выбирайте длительность работы и отдыха без привязки к графику.';

  @override
  String get scheduleActiveDaysLabel => 'Активные дни:';

  @override
  String get scheduleActiveHoursLabel => 'Активные часы:';

  @override
  String get scheduleExceptionsLabel => 'Исключения:';

  @override
  String get scheduleExceptionAddLabel => 'Добавить исключение';

  @override
  String get scheduleExceptionShowLabel => 'Показать исключение';

  @override
  String notification_stateChanged(Object state) {
    return 'Статус изменён: $state';
  }

  @override
  String notification_exceptionAdded(Object day) {
    return 'Добавленно исключение для $day';
  }

  @override
  String get notification_activity_title => 'Pomodoro - Время работы! 🍅';

  @override
  String get notification_activity_body => 'Начинается рабочая сессия. Сосредоточьтесь на задаче!';

  @override
  String get notification_rest_title => 'Pomodoro - Время отдыха! ☕';

  @override
  String get notification_rest_body => 'Начинается перерыв. Расслабьтесь и отдохните!';

  @override
  String get notification_inactivity_title => 'Pomodoro - Остановлено';

  @override
  String get notification_inactivity_body => 'Таймер остановлен. Готовы начать новую сессию?';

  @override
  String get notification_activity_complete_title => 'Рабочая сессия завершена! ✅';

  @override
  String get notification_activity_complete_body => 'Отличная работа! Время для заслуженного перерыва.';

  @override
  String get notification_rest_complete_title => 'Перерыв завершён! 🔄';

  @override
  String get notification_rest_complete_body => 'Отдых завершён. Готовы к новой рабочей сессии?';

  @override
  String get notification_inactivity_complete_title => 'Сессия завершена';

  @override
  String get notification_inactivity_complete_body => 'Готовы начать новую сессию?';

  @override
  String get loading => 'Загружается...';

  @override
  String get error_retry => 'Ошибка. Нажмите для повтора';
}
