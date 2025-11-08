import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/l10n/app_localizations.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';
import 'package:pomodoro_sczuw/screens/home_screen.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';
import 'package:pomodoro_sczuw/theme/alert_colors.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WindowListener, TrayListener {
  @override
  initState() {
    super.initState();
    windowManager.addListener(this);
    trayManager.addListener(this);
    _initTray();
    _initWindowManager();
  }

  void _initTray() {
    trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(key: 'show_window', label: 'Show Window'),
          MenuItem.separator(),
          MenuItem(key: 'exit_app', label: 'Exit App'),
        ],
      ),
    );
    trayManager.setIcon('assets/images/pomodoro_app_icon_red.png');
  }

  void _initWindowManager() {
    WindowOptions windowOptions = WindowOptions(
      size: Size(400, 800),
      center: false,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _updateTrayAttributes(PomodoroSession session) {
    if (session.state.isInactive()) {
      trayManager.setTitle('');
    } else {
      final timeString = _formatTime(session.currentSeconds);
      trayManager.setTitle(timeString);
    }
    if (session.isPaused) {
      trayManager.setIcon('assets/images/pomodoro_app_icon_yellow.png');
    } else {
      trayManager.setIcon(session.state.icon());
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      await windowManager.hide();
    }
  }

  @override
  void onWindowEvent(String eventName) {
    print('[WindowManager] onWindowEvent: $eventName');
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_window') {
      windowManager.show();
      windowManager.focus();
    } else if (menuItem.key == 'exit_app') {
      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<PomodoroSession>>(timerProvider, (previous, next) {
      next.whenData((session) {
        _updateTrayAttributes(session);
      });
    });

    return MaterialApp(
      title: 'Pomodoro app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
        appBarTheme: AppBarTheme(backgroundColor: Colors.green[400], foregroundColor: Colors.white),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green[400],
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        extensions: [
          AlertColors(
            info: Colors.blue.shade800,
            warning: Colors.orange.shade800,
            success: Colors.green.shade800,
            danger: Colors.red.shade800,
          ),
          TimerColors(
            activity: Colors.green[300]!,
            inactivity: Colors.grey[500]!,
            rest: Colors.blue[400]!,
            pause: Colors.yellow[300]!,
            postpone: Colors.deepPurple[300]!,
            resume: Colors.green[300]!,
          ),
        ],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[800]!, brightness: Brightness.dark),
        appBarTheme: AppBarTheme(backgroundColor: Colors.green[900], foregroundColor: Colors.white),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green[800],
          contentTextStyle: TextStyle(color: Colors.white),
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
            activity: Colors.green[800]!,
            inactivity: Colors.grey[700]!,
            rest: Colors.blue[900]!,
            pause: Colors.yellow[800]!,
            postpone: Colors.deepPurple[800]!,
            resume: Colors.green[300]!,
          ),
        ],
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }

        return const Locale('en', '');
      },
      builder: (context, child) {
        // Инициализация сервиса локализации
        L10n().initialize(context);
        return child!;
      },
    );
  }
}
