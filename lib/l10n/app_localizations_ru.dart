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
  String action_postpone(Object duration) {
    return '+$duration';
  }

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
  String get action_resetToDefaults => 'Сбросить настройки';

  @override
  String get action_collapseWindow => 'Свернуть окно';

  @override
  String get action_exitApp => 'Выйти из приложения';

  @override
  String get action_showWindow => 'Показать окно';

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

  @override
  String get telegram_sectionTitle => 'Telegram';

  @override
  String get telegram_notificationsEnabled => 'Уведомления в Telegram';

  @override
  String get telegram_botTokenLabel => 'Токен бота';

  @override
  String get telegram_chatIdLabel => 'Chat ID';

  @override
  String get telegram_setupHint => 'Создайте бота у @BotFather, напишите ему /start, узнайте chat_id через @userinfobot и вставьте значения выше.';

  @override
  String get telegram_sendTest => 'Отправить тест';

  @override
  String get telegram_sendingTest => 'Отправка…';

  @override
  String get telegram_testSent => 'Telegram: тестовое сообщение отправлено';

  @override
  String telegram_testError(Object error) {
    return 'Telegram: $error';
  }

  @override
  String get telegram_notConfigured => 'Telegram выключен или не заполнены token/chat id';

  @override
  String get telegram_started => 'Pomodoro: запуск';

  @override
  String get telegram_stopped => 'Pomodoro: остановка';

  @override
  String telegram_statusChanged(Object from, Object to) {
    return 'Pomodoro: $from → $to';
  }

  @override
  String telegram_paused(Object state) {
    return 'Pomodoro: пауза ($state)';
  }

  @override
  String telegram_resumed(Object state) {
    return 'Pomodoro: продолжение ($state)';
  }

  @override
  String get telegram_test => 'Pomodoro: тест';

  @override
  String get restOverlay_sectionTitle => 'Оверлей отдыха';

  @override
  String get restOverlay_enabled => 'Показывать поверх всех окон при отдыхе';

  @override
  String get restOverlay_title => 'Пора отдохнуть';

  @override
  String get restOverlay_subtitle => 'Сделайте короткий перерыв — глаза и тело скажут спасибо.';

  @override
  String get restOverlay_dismiss => 'Понятно';

  @override
  String get restOverlay_tip1 => 'Встаньте, пройдитесь пару минут и разомните шею.';

  @override
  String get restOverlay_tip2 => 'Посмотрите вдаль на 20 секунд, чтобы дать глазам отдохнуть.';

  @override
  String get restOverlay_tip3 => 'Выпейте воды и сделайте несколько глубоких вдохов.';

  @override
  String get restOverlay_tip4 => 'Отойдите от экрана и сделайте лёгкую разминку плеч.';

  @override
  String get sounds_sectionTitle => 'Звуки';

  @override
  String get sounds_userAction => 'Действия пользователя';

  @override
  String get sounds_sessionComplete => 'Завершение таймера';

  @override
  String get sounds_stateActivity => 'Переход в работу';

  @override
  String get sounds_stateRest => 'Переход в отдых';

  @override
  String get sounds_stateInactivity => 'Переход в неактивность';

  @override
  String get sounds_presetOff => 'Выкл';

  @override
  String get sounds_presetToggle => 'toggle';

  @override
  String get sounds_presetRequest => 'request';

  @override
  String get sounds_chooseFile => 'Выбрать файл';

  @override
  String get sounds_resetDefault => 'По умолчанию';

  @override
  String get sounds_defaultLabel => 'По умолчанию';

  @override
  String get sounds_customFileInvalid => 'Недопустимый или отсутствующий аудиофайл';

  @override
  String get theme_sectionTitle => 'Тема';

  @override
  String get theme_system => 'Системная';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_dark => 'Тёмная';
}
