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
- **Directories**: `providers/` (state), `services/` (logic), `models/` (data), `widgets/` (UI), `screens/` (screens), `enums/`, `events/`

## Platform-Specific Features

### Timer Service
- **Abstract**: `TimerService` interface
- **Linux**: `DesktopTimerService` uses `Timer.periodic` + `StreamController<TimerEvent>`
- **Future**: Android (WorkManager), Windows (similar to Linux)

### Notifications
- **Linux**: `flutter_local_notifications` with `LinuxInitializationSettings`
- **Config**: Position (10,10), icons per state, shows on state change/completion
- **Future**: Android (channels), Windows (toast)

### Window Management
- **Package**: `window_manager` (Linux desktop)
- **Behavior**: 400x800px, hide on close (not destroy), show/focus on startup
- **Future**: Windows (similar), Android (N/A)

### System Tray
- **Package**: `tray_manager` (Linux desktop)
- **Behavior**: Icon changes (red=activity, green=rest, gray=inactivity, yellow=paused), title shows MM:SS
- **Menu**: Show window, Exit, Collapse
- **Future**: Windows (similar), Android (N/A)

### Sound
- **Package**: `audioplayers` (cross-platform)
- **Files**: `request.mp3` (complete), `toggle.mp3` (actions)
- **Future**: All platforms supported, may need audio focus on Android

### Dependencies
- **Linux-specific**: `window_manager`, `tray_manager`, `flutter_local_notifications`
- **Cross-platform**: `audioplayers`, `hive_flutter`

## Main Application Flow

### Initialization
`main()` → `AppInitializer.init()` → Flutter bindings, window manager, notifications, Hive → `ProviderScope` → `App`

### Providers
- `timerServiceProvider` → `DesktopTimerService`
- `soundServiceProvider` → `SoundService`
- `systemNotificationServiceProvider` → `SystemNotificationService`
- `pomodoroSettingsProvider` → Hive storage
- `pomodoroSessionManagerProvider` → `PomodoroSessionManager`

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
- **Notifications**: `onStateChanged` (state change), `onSessionCompleted` (timer complete)
- **Sounds**: 'toggle' (user actions), 'request' (session complete)

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

**Main Features**: Timer functionality, session state management, initialization, state management architecture, service layer, major UI flow, persistence, notifications, sounds

**How**: Update "Main Application Flow" section with current flow, key components, state transitions

**Don't Document**: Bug fixes, styling, refactoring without behavior change, new features not affecting flow, performance optimizations

## Adding Platform Features
1. Create abstraction (interface/abstract class)
2. Implement for Linux
3. Document decision here
4. Add stubs for other platforms if needed
5. Update this file
