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
  String get processingStateLabel_activity => 'Активно';

  @override
  String get processingStateLabel_inactivity => 'Неактивно';

  @override
  String get processingStateLabel_rest => 'Перерыв';

  @override
  String get processingStateLabel_restDelay => 'Отложенный перерыв';

  @override
  String get processingStateLabel_unknown => 'Неизвестно';

  @override
  String get pomodoroModeLabel_custom => 'Пользовательский';

  @override
  String get pomodoroModeLabel_schedule => 'Расписание';

  @override
  String get operationModeLabel => 'Режим:';

  @override
  String get sessionDurationLabel => 'Длительность сессии:';

  @override
  String get breakDurationLabel => 'Длительность перерыва:';

  @override
  String get action_stop => 'Стоп';

  @override
  String get action_start => 'Запуск';

  @override
  String get action_continue => 'Продолжить';

  @override
  String get action_delay => 'Отложить';

  @override
  String get action_rest => 'Перерыв';

  @override
  String get action_confirm => 'Подтвердить';

  @override
  String get unitShort_minute => 'мин.';

  @override
  String get unitShort_seconds => 'с.';

  @override
  String get unitShort_hours => 'ч.';

  @override
  String get unitShort_days => 'д.';

  @override
  String get delayedChangeStateLabel => 'Подтвердите смену статуса';

  @override
  String get delayedRestLabel => 'Пора сделать перерыв!';

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
}
