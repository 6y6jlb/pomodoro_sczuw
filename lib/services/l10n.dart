import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/l10n/app_localizations.dart';

class L10n {
  static final L10n _instance = L10n._internal();
  factory L10n() => _instance;
  L10n._internal();

  late AppLocalizations _localizations;

  void initialize(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get t => _localizations;

  // Проверяем, инициализирован ли L10n для использования в фоне
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
        print('L10n: Not initialized, using fallback text: $fallback');
        return fallback;
      }
    } catch (e) {
      print('L10n: Error accessing localization, using fallback: $e');
      return fallback;
    }
  }
}
