/// Persisted app theme palette values (Hive string).
class AppThemePalette {
  static const String defaultPalette = 'default';
  static const String sage = 'sage';
  static const String mist = 'mist';
  static const String sand = 'sand';

  static const Set<String> all = {defaultPalette, sage, mist, sand};

  static bool isAllowed(String value) => all.contains(value);

  static String normalize(String value) => isAllowed(value) ? value : defaultPalette;
}
