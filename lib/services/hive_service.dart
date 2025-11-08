import 'package:hive_flutter/adapters.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    //TOOD: register adapters
  }
}