# AGENTS.md - Guidelines for LLM Agents

## Platform Priorities

- **Primary**: Linux Ubuntu (test all changes here first)
- **Supported**: Android (foreground service timer + ongoing notification; desktop shell skipped via `isDesktop` in `platform_support.dart`), Windows desktop
- Use abstraction layers (`TimerService`) for platform-specific code; guard `window_manager` / `tray_manager` with `isDesktop`

## Code Style

- **Comments**: Only for complex/non-obvious logic. Code should be self-documenting.
- **Naming**: Functions/variables must explain functionality
  - ✅ `changeStateToNext()` not `next()`
  - ✅ `getDurationForState()` not `getDuration()`
- **Conventions**: PascalCase (classes), camelCase (methods/vars), underscore prefix (private)



## Architecture

- **State Management**: Riverpod (`flutter_riverpod`)
- **Pattern**: Provider/Service separation
- **Directories**: `providers/` (state), `services/` (logic, including `integrations/`), `models/` (data), `widgets/` (UI), `screens/` (screens), `enums/`, `events/`



## Platform-Specific Features



### Timer Service

- **Abstract**: `TimerService` interface
- **Desktop**: `DesktopTimerService` uses `Timer.periodic` + `StreamController<TimerEvent>`
- **Android**: `AndroidTimerService` uses wall-clock countdown (`DateTime` end time) + `Timer.periodic` ticks in the main isolate; `flutter_foreground_task` FGS keeps the process alive while a session is active (`stopWithTask=true` — swipe from recents stops the timer)
- **Future**: restore after process kill (AlarmManager / WorkManager)



### Notifications

- **Linux**: `flutter_local_notifications` with `LinuxInitializationSettings` + per-state PNG icons
- **Windows**: `WindowsInitializationSettings` (appName / AUMID `com.pomodoro_sczuw.app` / fixed GUID) + `WindowsNotificationDetails`; unpackaged apps can `show` toasts, but cancel/getActive need MSIX
- **Android**:
  - **Alerts**: `flutter_local_notifications` — channel `pomodoro_session`, state-change / completion toasts (`AndroidNotificationDetails`, runtime `POST_NOTIFICATIONS`)
  - **Ongoing (tray analog)**: `flutter_foreground_task` — channel `pomodoro_foreground`, current status (no per-second MM:SS) + pause/resume/stop actions + tap-to-open; updated on state/pause changes only
- **Config**: Linux position (10,10); alerts on state change/completion via `SystemNotificationService` singleton (`instance` shared by `AppInitializer` and provider)
- **App id**: `com.pomodoro_sczuw.app`; Gradle needs core library desugaring for `flutter_local_notifications`



### Window Management

- **Package**: `window_manager` (Linux + Windows desktop only; skipped when `!isDesktop`)
- **Behavior**: 400x800px, `setPreventClose(true)` then hide on close (not destroy), show/focus on startup
- **Rest overlay** (optional, `restOverlayEnabled` in Hive): on enter `rest` → `RestOverlayService.show()` + dimmed `RestOverlayScreen`; on leave rest / dismiss / disable setting / window close → `hide()`
  - **Desktop**: also show window, `setAlwaysOnTop(true)`, `setFullScreen(true)`, restore bounds/flags on hide
  - **Android**: in-app overlay only (no window flags)



### System Tray

- **Package**: `tray_manager` (Linux + Windows desktop only; skipped when `!isDesktop`)
- **Behavior**: Icon changes (red=activity, green=rest, gray=inactivity, yellow=paused); Linux `setTitle(MM:SS)`, Windows/macOS `setToolTip(MM:SS)`
- **Icons**: PNG on Linux, ICO on Windows (`SessionState.trayIcon()`)
- **Clicks**: Linux left → system context menu (AppIndicator); Windows/macOS left → show/focus, right → context menu
- **Note**: `setToolTip` is Windows/macOS only — calling it on Linux aborts tray init before `setContextMenu`
- **Menu**: Show window, Collapse, Exit (no separators — AppIndicator/dbusmenu on Linux can drop labels when separators + frequent icon/title updates are used)
- **Android**: N/A



### Sound

- **Package**: `audioplayers` (cross-platform)
- **Events** (`SoundEvent`): `userAction`, `sessionComplete`, `stateActivity`, `stateRest`, `stateInactivity`
- **Values**: off (`''`), bundled defaults (`toggle` / `request`), or absolute path to `.mp3`/`.wav`/`.ogg`/`.m4a`/`.aac` (validated; no `..`)
- **Defaults**: userAction→toggle, sessionComplete→request, state*→off
- **Settings UI**: choose file / reset default / off per event (`file_selector`)
- **Future**: Android audio focus



### Integrations

- **Abstract**: `Integration` (`id`, `handle(IntegrationEvent)`, `dispose()`)
- **Bus**: `IntegrationBus` fans out typed events fire-and-forget; errors isolated per integration
- **Events**: `SessionStatusChanged`, `SessionPaused`/`SessionResumed`, `SessionCompleted`, `UserActionPressed`, `PageNavigated`
- **Publishers**: session callbacks in `pomodoroSessionManagerProvider`; button actions in `SessionNotifier`; navigation via `IntegrationNavigatorObserver`
- **Implementation (HTTP)**: `Esp32LedIntegration` maps status/pause/resume → `TimerPhase` then LED pattern — yellow `/yellow` for 0.5s then activity→steady `/green`, rest→alternate `/green`/`/yellow` every 0.5s, paused→`/yellow` immediately, inactivity→`/off`. Phase dedupe lives inside the adapter
- **Implementation (Telegram)**: `TelegramIntegration` sends personal `sendMessage` via Bot API — start/stop (`UserActionPressed`), status (`SessionStatusChanged`), pause/resume. Per-user bot token + chat_id from Hive (`PomodoroSettings`); no shared token in code. Credentials read via `credentialsProvider` on each send
- **Config**: `IntegrationConstant.esp32BaseUrl` (default `http://192.168.0.102`); Telegram: `telegramEnabled` / `telegramBotToken` / `telegramChatId` in Hive + Settings UI
- **Extensibility**: Implement `Integration`, register in `integrationBusProvider` (webhooks, Home Assistant, email, ...)
- **Future**: All platforms supported (network/IO based)



### Dependencies

- **Desktop (Linux + Windows)**: `window_manager`, `tray_manager` (initialized only when `isDesktop`)
- **Android**: `flutter_foreground_task` (FGS + ongoing notification; initialized only on Android)
- **Cross-platform**: `flutter_local_notifications` (Linux / Windows / Android), `audioplayers`, `hive_flutter`



## Main Application Flow



### Initialization

`main()` → `AppInitializer.init()` → Flutter bindings → (Android) FGS communication port → (desktop only) window manager → notifications → (Android) FGS plugin init → Hive → `ProviderScope` → `App` (tray/window init only when `isDesktop`)

### Providers

- `timerServiceProvider` → `DesktopTimerService` (desktop) / `AndroidTimerService` (Android)
- `androidForegroundControllerProvider` → `AndroidForegroundController` (Android FGS / ongoing notification)
- `soundServiceProvider` → `SoundService`
- `systemNotificationServiceProvider` → `SystemNotificationService.instance`
- `restOverlayServiceProvider` → `RestOverlayService`
- `integrationBusProvider` → `IntegrationBus` (+ registered `Integration`s)
- `pomodoroSettingsProvider` → Hive storage (durations, Telegram, `restOverlayEnabled`, per-event sounds, `themeMode`: system/light/dark, `themePalette`: default/sage/mist/sand, `locale`: system/en/ru)
- `pomodoroSessionManagerProvider` → `PomodoroSessionManager` (also wires notifications, state sounds, rest overlay, Android FGS updates/actions)



### Timer Lifecycle

User Action → `SessionNotifier` → `TimerNotifier` → `PomodoroSessionManager` → `TimerService` → `TimerEvent` stream → `_handleTimerEvent()` → `_updateSession()` → UI rebuild

### State Transitions

- **Initial**: `SessionState.inactivity`
- **Flow**: `inactivity` ↔ `activity` ↔ `rest` ↔ `activity` (cycles)
- **Methods**: `changeStateToNext()`, `changeStateToInactivity()`, `changeState()`



### Timer Events

- `TimerStarted`, `TimerTick` (every second), `TimerPaused`, `TimerResumed`, `TimerStopped`, `TimerReset`, `TimerCompleted` (triggers state transition + sound)



### Key Components

- `PomodoroSessionManager` - Timer lifecycle, session state, event handling
- `TimerService` (abstract) - Platform timer (`DesktopTimerService` / `AndroidTimerService`)
- `AndroidForegroundController` - Android FGS lifecycle, ongoing notification status + pause/resume/stop
- `TimerNotifier` - Riverpod provider for UI
- `SessionNotifier` - Wraps `TimerNotifier`, adds sounds
- `PomodoroSession` - Immutable session model
- `SessionState` - Enum: `activity`, `rest`, `inactivity`



### Notifications & Sounds

- **Notifications**: `onStateChanged` / `onSessionCompleted` → Linux/Windows/Android alert toasts
- **Android ongoing**: while activity/rest → FGS notification with status (not MM:SS); actions → `SessionNotifier` pause/resume/stop; tap → open app
- **Sounds**: `playForEvent` from settings — user actions (`SessionNotifier`), session complete (`PomodoroSessionManager`), optional per-state sounds on `onStateChanged`
- **Rest overlay**: when `restOverlayEnabled`, enter `rest` → `RestOverlayService.show()` + UI overlay; leave rest / dismiss → `hide()` (desktop also toggles fullscreen window flags)



### Integrations (runtime)

- **Session**: `onStateChanged` / pause / resume / complete → `IntegrationBus.publish(...)`
- **UI actions**: `SessionNotifier` → `UserActionPressed`
- **Navigation**: `IntegrationNavigatorObserver` → `PageNavigated`
- Registered adapters (`Esp32LedIntegration`, `TelegramIntegration`) decide which events to handle
- **Telegram settings**: Settings screen → Hive → `credentialsProvider` in `integrationBusProvider`



## Key Patterns

- Event-driven: Timer events via streams
- Immutable models: `copyWith` pattern
- Provider pattern: Riverpod wraps services
- Service abstraction: Interfaces for platform-specific code



## When Making Changes

1. Read existing code first
2. Maintain consistency
3. Keep it simple
4. Test on Linux Ubuntu
5. Update related code
6. **Document main flow changes** (see below)



## Documenting Main Flow Changes

**Rule**: When core features or main flow changes, update AGENTS.md

**Main Features**: Timer functionality, session state management, initialization, state management architecture, service layer, integrations bus, major UI flow, persistence, notifications, sounds

**How**: Update "Main Application Flow" section with current flow, key components, state transitions

**Don't Document**: Bug fixes, styling, refactoring without behavior change, new features not affecting flow, performance optimizations

## Adding Platform Features

1. Create abstraction (interface/abstract class)
2. Implement for Linux
3. Document decision here
4. Add stubs for other platforms if needed
5. Update this file

