import 'package:hive_flutter/adapters.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(PomodoroSettingsAdapter());
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    try {
      print('HiveService: Opening box "$boxName"...');

      if (Hive.isBoxOpen(boxName)) {
        print('HiveService: Box "$boxName" is already open, returning existing instance');
        return Hive.box<T>(boxName);
      }

      final box = await Hive.openBox<T>(boxName);
      print('HiveService: Box "$boxName" opened successfully');
      return box;
    } catch (e, stackTrace) {
      print('HiveService: Failed to open box "$boxName" - $e');
      print('HiveService: Stack trace: $stackTrace');
      rethrow;
    }
  }
}
