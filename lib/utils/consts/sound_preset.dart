import 'dart:io';

import 'package:path/path.dart' as p;

/// Built-in defaults and validation for sound setting values.
///
/// Empty string = muted. `toggle` / `request` = bundled assets (defaults).
/// Any other value must be an absolute path to an allowed audio file.
class SoundPreset {
  static const String off = '';
  static const String toggle = 'toggle';
  static const String request = 'request';

  static const Set<String> bundled = {toggle, request};

  static const Set<String> allowedExtensions = {
    '.mp3',
    '.wav',
    '.ogg',
    '.m4a',
    '.aac',
  };

  static bool isBundled(String key) => bundled.contains(key);

  static bool isOff(String key) => key.isEmpty;

  static bool isAllowed(String key) {
    if (isOff(key) || isBundled(key)) return true;
    return isValidCustomPath(key);
  }

  static bool isValidCustomPath(String path) {
    if (path.isEmpty) return false;
    if (!p.isAbsolute(path)) return false;
    if (path.contains('\x00')) return false;

    final normalized = p.normalize(path);
    if (normalized.contains('..')) return false;

    final extension = p.extension(normalized).toLowerCase();
    if (!allowedExtensions.contains(extension)) return false;

    try {
      final file = File(normalized);
      return file.existsSync() && file.statSync().type == FileSystemEntityType.file;
    } catch (_) {
      return false;
    }
  }

  static String? defaultForEvent(String eventName) {
    switch (eventName) {
      case 'userAction':
        return toggle;
      case 'sessionComplete':
        return request;
      default:
        return off;
    }
  }
}
