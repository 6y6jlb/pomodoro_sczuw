# AGENTS.md - Guidelines for LLM Agents

## Platform Priorities
- **Primary**: Linux Ubuntu (test all changes here first)
- **Future**: Android/Windows (stubs OK, full implementations wait)
- Use abstraction layers (`TimerService`) for platform-specific code

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
- **Linux**: `DesktopTimerService` uses `Timer.periodic` + `StreamController<TimerEvent>`
- **Future**: Android (WorkManager), Windows (similar to Linux)

### Notifications
- **Linux**: `flutter_local_notifications` with `LinuxInitializationSettings` + per-state PNG icons
- **Windows**: `WindowsInitializationSettings` (appName / AUMID `com.pomodoro_sczuw.app` / fixed GUID) + `WindowsNotificationDetails`; unpackaged apps can `show` toasts, but cancel/getActive need MSIX
- **Config**: Linux position (10,10); shows on state change/completion via `SystemNotificationService` singleton (`instance` shared by `AppInitializer` and provider)
- **Future**: Android (channels)

### Window Management
- **Package**: `window_manager` (Linux + Windows desktop)
- **Behavior**: 400x800px, `setPreventClose(true)` then hide on close (not destroy), show/focus on startup
- **Rest overlay** (optional, `restOverlayEnabled` in Hive): on enter `rest` → show window, `setAlwaysOnTop(true)`, `setFullScreen(true)`, dimmed `RestOverlayScreen` with tip + dismiss; on leave rest / dismiss / disable setting / window close → restore bounds and flags via `RestOverlayService`
- **Future**: Android (N/A)

### System Tray
- **Package**: `tray_manager` (Linux + Windows desktop)
- **Behavior**: Icon changes (red=activity, green=rest, gray=inactivity, yellow=paused); Linux `setTitle(MM:SS)`, Windows/macOS `setToolTip(MM:SS)`
- **Icons**: PNG on Linux, ICO on Windows (`SessionState.trayIcon()`)
- **Clicks**: Linux left → system context menu (AppIndicator); Windows/macOS left → show/focus, right → context menu
- **Note**: `setToolTip` is Windows/macOS only — calling it on Linux aborts tray init before `setContextMenu`
- **Menu**: Show window, Exit, Collapse
- **Future**: Android (N/A)

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
- **Desktop (Linux + Windows)**: `window_manager`, `tray_manager`, `flutter_local_notifications` (Linux + Windows toast)
- **Cross-platform**: `audioplayers`, `hive_flutter`

## Main Application Flow

### Initialization
`main()` → `AppInitializer.init()` → Flutter bindings, window manager, notifications, Hive → `ProviderScope` → `App`

### Providers
- `timerServiceProvider` → `DesktopTimerService`
- `soundServiceProvider` → `SoundService`
- `systemNotificationServiceProvider` → `SystemNotificationService.instance`
- `restOverlayServiceProvider` → `RestOverlayService`
- `integrationBusProvider` → `IntegrationBus` (+ registered `Integration`s)
- `pomodoroSettingsProvider` → Hive storage (durations, Telegram, `restOverlayEnabled`, per-event sounds)
- `pomodoroSessionManagerProvider` → `PomodoroSessionManager` (also wires notifications, state sounds, rest overlay)

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
- `TimerService` (abstract) - Platform timer (`DesktopTimerService` for Linux)
- `TimerNotifier` - Riverpod provider for UI
- `SessionNotifier` - Wraps `TimerNotifier`, adds sounds
- `PomodoroSession` - Immutable session model
- `SessionState` - Enum: `activity`, `rest`, `inactivity`

### Notifications & Sounds
- **Notifications**: `onStateChanged` (state change), `onSessionCompleted` (timer complete) → Linux/Windows toasts
- **Sounds**: `playForEvent` from settings — user actions (`SessionNotifier`), session complete (`PomodoroSessionManager`), optional per-state sounds on `onStateChanged`
- **Rest overlay**: when `restOverlayEnabled`, enter `rest` → `RestOverlayService.show()` + UI overlay; leave rest / dismiss → `hide()`

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
