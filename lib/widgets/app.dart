import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/l10n/app_localizations.dart';
import 'package:pomodoro_sczuw/screens/home_screen.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';
import 'package:pomodoro_sczuw/theme/alert_colors.dart';
import 'package:pomodoro_sczuw/theme/timer_colors.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WindowListener, TrayListener {
  @override
  void onWindowEvent(String eventName) {
    print('[WindowManager] onWindowEvent: $eventName');
  }

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
    trayManager.setIcon('assets/images/pomodoro_app_icon.png');
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
            restDelay: Colors.deepPurple[300]!,
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
            restDelay: Colors.deepPurple[800]!,
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
        I10n().initialize(context);
        return child!;
      },
    );
  }
}
