import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/enums/session_state.dart';
import 'package:pomodoro_sczuw/l10n/app_localizations.dart';
import 'package:pomodoro_sczuw/models/pomodoro_session.dart';
import 'package:pomodoro_sczuw/providers/pomodoro_settings_provider.dart';
import 'package:pomodoro_sczuw/providers/service_providers.dart';
import 'package:pomodoro_sczuw/providers/session_provider.dart';
import 'package:pomodoro_sczuw/providers/timer_provider.dart';
import 'package:pomodoro_sczuw/utils/consts/app_locale_preference.dart';
import 'package:pomodoro_sczuw/utils/consts/app_theme_palette.dart';
import 'package:pomodoro_sczuw/utils/consts/app_theme_preference.dart';
import 'package:pomodoro_sczuw/screens/home_screen.dart';
import 'package:pomodoro_sczuw/screens/rest_overlay_screen.dart';
import 'package:pomodoro_sczuw/services/integrations/integration_navigator_observer.dart';
import 'package:pomodoro_sczuw/services/l10n.dart';
import 'package:pomodoro_sczuw/services/rest_overlay_service.dart';
import 'package:pomodoro_sczuw/theme/app_themes.dart';
import 'package:pomodoro_sczuw/utils/consts/integration_constant.dart';
import 'package:pomodoro_sczuw/utils/platform_support.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WindowListener, TrayListener {
  late final IntegrationNavigatorObserver _integrationNavigatorObserver;
  late final RestOverlayService _restOverlayService;
  int _restTipIndex = 0;
  bool _restOverlayVisible = false;
  bool _trayReady = false;
  Menu? _trayMenu;
  String? _lastTrayIconPath;
  String? _lastTrayTitle;

  @override
  void initState() {
    super.initState();
    _integrationNavigatorObserver = IntegrationNavigatorObserver(ref.read(integrationBusProvider));
    _restOverlayService = ref.read(restOverlayServiceProvider);

    if (isDesktop) {
      windowManager.addListener(this);
      trayManager.addListener(this);
      _initTray();
      _initWindowManager();
    }

    // Ensure session manager (and its rest-overlay wiring) is created.
    ref.read(pomodoroSessionManagerProvider);

    _restOverlayVisible = _restOverlayService.isVisible;
    _restOverlayService.addListener(_onRestOverlayChanged);
  }

  void _onRestOverlayChanged() {
    final visible = _restOverlayService.isVisible;
    if (!mounted) return;
    setState(() {
      if (visible && !_restOverlayVisible) {
        _restTipIndex++;
      }
      _restOverlayVisible = visible;
    });
  }

  Menu _buildTrayMenu() {
    // No separators: AppIndicator/dbusmenu on Linux often renders them as blank
    // rows and can desync labeled items after icon/title updates.
    return Menu(
      items: [
        MenuItem(key: 'show_window', label: 'Show window'),
        MenuItem(key: 'collapse_window', label: 'Collapse window'),
        MenuItem(key: 'exit_app', label: 'Exit app'),
      ],
    );
  }

  Future<void> _applyTrayMenu() async {
    final menu = _trayMenu;
    if (menu == null) return;
    await trayManager.setContextMenu(menu);
  }

  Future<void> _initTray() async {
    _trayMenu = _buildTrayMenu();
    final iconPath = SessionState.activity.trayIcon();
    await trayManager.setIcon(iconPath);
    _lastTrayIconPath = iconPath;

    if (Platform.isWindows || Platform.isMacOS) {
      await trayManager.setToolTip('Pomodoro');
    }

    // Bind menu immediately, then again shortly after — AppIndicator activates
    // with an empty menu on first setIcon; a second bind restores labels.
    await _applyTrayMenu();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    await _applyTrayMenu();

    _trayReady = true;
  }

  Future<void> _initWindowManager() async {
    await windowManager.setPreventClose(true);

    const windowOptions = WindowOptions(
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

  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _exitApp() async {
    await trayManager.destroy();
    await windowManager.destroy();
  }

  void _updateTrayAttributes(PomodoroSession session) {
    if (!isDesktop || !_trayReady) return;

    final timeString = _formatTime(session.currentSeconds);
    // Avoid empty AppIndicator label — it can break dbusmenu item text sync.
    final label = session.state.isInactive() ? 'Pomodoro' : timeString;
    final iconPath = session.state.trayIcon(isPaused: session.isPaused);

    if (_lastTrayTitle != label) {
      _lastTrayTitle = label;
      if (Platform.isWindows || Platform.isMacOS) {
        trayManager.setToolTip(label);
      }
      if (!Platform.isWindows) {
        trayManager.setTitle(label);
      }
    }

    if (_lastTrayIconPath == iconPath) return;

    _lastTrayIconPath = iconPath;
    trayManager.setIcon(iconPath).then((_) async {
      // Re-bind menu after icon change so Linux AppIndicator keeps labels visible.
      if (Platform.isLinux && mounted) {
        await _applyTrayMenu();
      }
    });
  }

  @override
  void dispose() {
    _restOverlayService.removeListener(_onRestOverlayChanged);
    if (isDesktop) {
      windowManager.removeListener(this);
      trayManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowClose() async {
    if (_restOverlayService.isVisible) {
      await _restOverlayService.hide();
    }
    await windowManager.hide();
  }

  @override
  void onTrayIconMouseDown() {
    // Linux AppIndicator shows the context menu on left click; popUpContextMenu is unsupported.
    // Steal the click only on platforms where the menu is opened via right-click.
    if (Platform.isLinux) return;
    _showWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    if (Platform.isLinux) return;
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        _showWindow();
      case 'exit_app':
        _exitApp();
      case 'collapse_window':
        windowManager.minimize();
    }
  }

  ThemeMode _resolveThemeMode(String preference) {
    switch (AppThemePreference.normalize(preference)) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
      default:
        return ThemeMode.system;
    }
  }

  Locale? _resolveLocale(String preference) {
    switch (AppLocalePreference.normalize(preference)) {
      case AppLocalePreference.en:
        return const Locale('en');
      case AppLocalePreference.ru:
        return const Locale('ru');
      case AppLocalePreference.system:
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<PomodoroSession>>(timerProvider, (previous, next) {
      next.whenData((session) {
        _updateTrayAttributes(session);
      });
    });

    final settings = ref.watch(pomodoroSettingsProvider);
    final themePreference = settings.when(
      data: (s) => s.resolvedThemeMode,
      loading: () => AppThemePreference.system,
      error: (_, __) => AppThemePreference.system,
    );
    final themePalette = settings.when(
      data: (s) => s.resolvedThemePalette,
      loading: () => AppThemePalette.defaultPalette,
      error: (_, __) => AppThemePalette.defaultPalette,
    );
    final localePreference = settings.when(
      data: (s) => s.resolvedLocale,
      loading: () => AppLocalePreference.system,
      error: (_, __) => AppLocalePreference.system,
    );

    return MaterialApp(
      title: 'Pomodoro app',
      theme: buildAppTheme(themePalette, Brightness.light),
      darkTheme: buildAppTheme(themePalette, Brightness.dark),
      themeMode: _resolveThemeMode(themePreference),
      locale: _resolveLocale(localePreference),
      initialRoute: IntegrationConstant.homeRouteName,
      routes: {
        IntegrationConstant.homeRouteName: (_) => const HomeScreen(),
      },
      navigatorObservers: [_integrationNavigatorObserver],
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
        return Stack(
          children: [
            child!,
            if (_restOverlayVisible)
              Positioned.fill(
                child: RestOverlayScreen(
                  tipIndex: _restTipIndex,
                  onDismiss: () {
                    _restOverlayService.hide();
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
