/// Persisted app locale preference values (Hive string).
class AppLocalePreference {
  static const String system = 'system';
  static const String en = 'en';
  static const String ru = 'ru';

  static const Set<String> all = {system, en, ru};

  static bool isAllowed(String value) => all.contains(value);

  static String normalize(String value) => isAllowed(value) ? value : system;
}
