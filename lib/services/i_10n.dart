import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/l10n/app_localizations.dart';

class I10n {
  static final I10n _instance = I10n._internal();
  factory I10n() => _instance;
  I10n._internal();

  late AppLocalizations _localizations;

  void initialize(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get t => _localizations;

  // Проверяем, инициализирован ли I10n для использования в фоне
  bool get isInitialized {
    try {
      _localizations;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Безопасный доступ к локализации с fallback для фонового режима
  String safeGetText(String Function(AppLocalizations) getter, String fallback) {
    try {
      if (isInitialized) {
        return getter(_localizations);
      } else {
        print('I10n: Not initialized, using fallback text: $fallback');
        return fallback;
      }
    } catch (e) {
      print('I10n: Error accessing localization, using fallback: $e');
      return fallback;
    }
  }
}
