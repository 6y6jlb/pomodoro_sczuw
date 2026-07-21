import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/theme/alert_colors.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:pomodoro_sczuw/utils/consts/app_theme_palette.dart';

ThemeData buildAppTheme(String palette, Brightness brightness) {
  final normalized = AppThemePalette.normalize(palette);
  final isLight = brightness == Brightness.light;

  switch (normalized) {
    case AppThemePalette.sage:
      return _buildPastelTheme(
        seed: const Color(0xFF8FA896),
        brightness: brightness,
        appBar: isLight ? const Color(0xFF7A9A84) : const Color(0xFF3D4F42),
        snackBar: isLight ? const Color(0xFF7A9A84) : const Color(0xFF5A7362),
        timer: isLight
            ? const TimerColors(
                activity: Color(0xFFA8C4B0),
                inactivity: Color(0xFF9AA09C),
                rest: Color(0xFF9BB0C4),
                pause: Color(0xFFD4C99A),
                postpone: Color(0xFFB5A8C4),
                resume: Color(0xFFA8C4B0),
              )
            : const TimerColors(
                activity: Color(0xFF5A7362),
                inactivity: Color(0xFF5C635E),
                rest: Color(0xFF4A5E70),
                pause: Color(0xFF8A7E4E),
                postpone: Color(0xFF6B5E7A),
                resume: Color(0xFFA8C4B0),
              ),
        alerts: isLight
            ? const AlertColors(
                info: Color(0xFF5A7A8E),
                warning: Color(0xFFA08050),
                success: Color(0xFF5A7362),
                danger: Color(0xFFA06060),
              )
            : const AlertColors(
                info: Color(0xFF7A9AAE),
                warning: Color(0xFFC0A070),
                success: Color(0xFF7A9A84),
                danger: Color(0xFFC08080),
              ),
      );
    case AppThemePalette.mist:
      return _buildPastelTheme(
        seed: const Color(0xFF8E9BB5),
        brightness: brightness,
        appBar: isLight ? const Color(0xFF7A8AA4) : const Color(0xFF3A4458),
        snackBar: isLight ? const Color(0xFF7A8AA4) : const Color(0xFF5A6A80),
        timer: isLight
            ? const TimerColors(
                activity: Color(0xFFA0B0C8),
                inactivity: Color(0xFF9A9EA8),
                rest: Color(0xFFA8B8C8),
                pause: Color(0xFFC8C0A0),
                postpone: Color(0xFFB0A8C0),
                resume: Color(0xFFA0B0C8),
              )
            : const TimerColors(
                activity: Color(0xFF5A6A80),
                inactivity: Color(0xFF555A64),
                rest: Color(0xFF4A5A6E),
                pause: Color(0xFF7A7250),
                postpone: Color(0xFF655A78),
                resume: Color(0xFFA0B0C8),
              ),
        alerts: isLight
            ? const AlertColors(
                info: Color(0xFF5A6A88),
                warning: Color(0xFF9A8050),
                success: Color(0xFF5A7A6A),
                danger: Color(0xFF9A6068),
              )
            : const AlertColors(
                info: Color(0xFF8A9AB8),
                warning: Color(0xFFBAA070),
                success: Color(0xFF7A9A8A),
                danger: Color(0xFFB88088),
              ),
      );
    case AppThemePalette.sand:
      return _buildPastelTheme(
        seed: const Color(0xFFB5A894),
        brightness: brightness,
        appBar: isLight ? const Color(0xFFA89880) : const Color(0xFF4A4338),
        snackBar: isLight ? const Color(0xFFA89880) : const Color(0xFF6E6454),
        timer: isLight
            ? const TimerColors(
                activity: Color(0xFFC0B49A),
                inactivity: Color(0xFFA8A49C),
                rest: Color(0xFFA8B4B8),
                pause: Color(0xFFD0C090),
                postpone: Color(0xFFB8A8B0),
                resume: Color(0xFFC0B49A),
              )
            : const TimerColors(
                activity: Color(0xFF6E6454),
                inactivity: Color(0xFF5E5A54),
                rest: Color(0xFF4A5558),
                pause: Color(0xFF8A7A48),
                postpone: Color(0xFF6A5A64),
                resume: Color(0xFFC0B49A),
              ),
        alerts: isLight
            ? const AlertColors(
                info: Color(0xFF6A7880),
                warning: Color(0xFFA08048),
                success: Color(0xFF6A7A60),
                danger: Color(0xFFA06860),
              )
            : const AlertColors(
                info: Color(0xFF8A98A0),
                warning: Color(0xFFC0A068),
                success: Color(0xFF8A9A80),
                danger: Color(0xFFC08880),
              ),
      );
    case AppThemePalette.defaultPalette:
    default:
      return _buildDefaultTheme(brightness);
  }
}

ThemeData _buildDefaultTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: isLight ? Colors.green : Colors.green[800]!,
      brightness: brightness,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: isLight ? Colors.green[400] : Colors.green[900],
      foregroundColor: Colors.white,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isLight ? Colors.green[400] : Colors.green[800],
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
    useMaterial3: true,
    extensions: [
      AlertColors(
        info: Colors.blue.shade800,
        warning: Colors.orange.shade800,
        success: Colors.green.shade800,
        danger: Colors.red.shade800,
      ),
      TimerColors(
        activity: isLight ? Colors.green[300]! : Colors.green[800]!,
        inactivity: isLight ? Colors.grey[500]! : Colors.grey[700]!,
        rest: isLight ? Colors.blue[400]! : Colors.blue[900]!,
        pause: isLight ? Colors.yellow[300]! : Colors.yellow[800]!,
        postpone: isLight ? Colors.deepPurple[300]! : Colors.deepPurple[800]!,
        resume: Colors.green[300]!,
      ),
    ],
  );
}

ThemeData _buildPastelTheme({
  required Color seed,
  required Brightness brightness,
  required Color appBar,
  required Color snackBar,
  required TimerColors timer,
  required AlertColors alerts,
}) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
    appBarTheme: AppBarTheme(backgroundColor: appBar, foregroundColor: Colors.white),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: snackBar,
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
    useMaterial3: true,
    extensions: [alerts, timer],
  );
}
