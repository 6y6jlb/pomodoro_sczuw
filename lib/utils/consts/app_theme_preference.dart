/// Persisted app theme preference values (Hive string).
class AppThemePreference {
  static const String system = 'system';
  static const String light = 'light';
  static const String dark = 'dark';

  static const Set<String> all = {system, light, dark};

  static bool isAllowed(String value) => all.contains(value);

  static String normalize(String value) => isAllowed(value) ? value : system;
}
