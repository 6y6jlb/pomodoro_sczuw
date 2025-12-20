# AGENTS.md - Guidelines for LLM Agents

This document provides guidelines for LLM agents working on the Pomodoro Timer Flutter application.

## Platform Priorities & Development Flow

### Primary Platform
- **Linux Ubuntu** - This is the primary and current development target
- All features and changes should be tested and verified on Linux Ubuntu first
- Platform-specific code should prioritize Linux Ubuntu implementation

### Future Platforms (Not Current Priority)
- **Android** - May be added in the future, but not currently in development
- **Windows** - May be added in the future, but not currently in development
- **Stubs are acceptable** - You can add stub implementations for other platforms to prepare for future support
- **Full implementations should wait** - Do not implement complete Android or Windows-specific features unless explicitly requested
- When making changes, ensure they don't break Linux Ubuntu functionality

### Development Flow
1. **Primary Focus**: Linux Ubuntu desktop application
2. **Testing**: All changes must work correctly on Linux Ubuntu
3. **Platform-Specific Code**: Use abstraction layers (like `TimerService`) to allow future platform support without breaking current functionality
4. **Stubs for Future Platforms**: Adding stub implementations (placeholder classes, empty implementations) for Android/Windows is acceptable to prepare architecture for future support
5. **Dependencies**: Be mindful of dependencies that may not work on other platforms, but prioritize Linux Ubuntu compatibility

## Code Style Principles

### Comments Policy
- **Avoid unnecessary comments** - Code should be self-documenting through clear naming
- **Only comment complex or non-obvious logic** - When business logic is intricate or requires explanation
- **No obvious comments** - Don't comment what the code clearly shows (e.g., `// Set value to 5` is unnecessary)
- **Prefer code clarity over comments** - If you need a comment, consider refactoring for clarity first

### Naming Conventions
- **Functions and variables must explain their functionality** - Names should be descriptive and self-explanatory
- Use clear, descriptive names:
  - ✅ `changeStateToNext()` instead of `next()`
  - ✅ `getDurationForState()` instead of `getDuration()`
  - ✅ `handleSessionComplete()` instead of `handleComplete()`
- **Private members** - Prefix with underscore (`_sessionManager`, `_timerService`)
- **Classes** - Use PascalCase (`PomodoroSession`, `TimerNotifier`)
- **Methods and variables** - Use camelCase (`currentSession`, `onSessionChange`)
- **Constants** - Use camelCase with descriptive names (`postponedSeconds`)

## Project Structure

### Architecture
- **State Management**: Riverpod (flutter_riverpod)
- **Architecture Pattern**: Provider/Service pattern with clear separation of concerns
- **Key Directories**:
  - `lib/providers/` - Riverpod providers for state management
  - `lib/services/` - Business logic and service implementations
  - `lib/models/` - Data models
  - `lib/widgets/` - UI components
  - `lib/screens/` - Screen-level widgets
  - `lib/enums/` - Enumerations
  - `lib/events/` - Event classes

### Code Organization
- Keep related functionality together
- Services handle business logic
- Providers expose state to UI
- Models are immutable data structures
- Widgets are presentation-only

## Coding Guidelines

### Dart/Flutter Best Practices
- Use `const` constructors when possible
- Prefer `final` over `var` for immutable values
- Use null safety features appropriately
- Follow Flutter widget composition patterns
- Use `copyWith` pattern for immutable models

### State Management
- Use `StreamNotifier` for reactive state
- Providers should delegate to services, not contain business logic
- Watch providers in widgets, read notifiers for actions
- Dispose resources properly (streams, timers, controllers)

### Error Handling
- Handle errors gracefully
- Use appropriate error types
- Provide meaningful error messages when necessary

### Testing Considerations
- Write testable code (dependency injection, pure functions)
- Keep business logic separate from UI
- Services should be easily mockable

## Examples

### Good Code (Self-Documenting)
```dart
void changeStateToNext() {
  final nextState = _currentSession.state.next();
  changeState(nextState);
}

PomodoroSession reset(int duration) {
  return copyWith(currentSeconds: duration, totalSeconds: duration, isPaused: true);
}
```

### Avoid (Unnecessary Comments)
```dart
// Bad: Obvious comment
void start() {
  // Start the timer
  _timerService.start();
}

// Good: Self-explanatory code
void start() {
  _timerService.start();
}
```

### Good Comment (Complex Logic)
```dart
// Only comment when logic is genuinely complex or non-obvious
void _handleTimerEvent(TimerEvent event) {
  // Pattern matching on sealed classes requires understanding of event types
  switch (event) {
    case TimerTick(:final remainingSeconds, :final totalSeconds):
      // Complex state update logic that might need explanation
      _updateSession(_currentSession.copyWith(...));
  }
}
```

## When Making Changes

1. **Read existing code first** - Understand the patterns and style
2. **Maintain consistency** - Follow existing naming and structure conventions
3. **Keep it simple** - Prefer straightforward solutions over clever ones
4. **Test your changes** - Ensure functionality works as expected
5. **Update related code** - If changing a pattern, update all instances

## Key Patterns in This Codebase

- **Session Management**: `PomodoroSessionManager` orchestrates timer lifecycle
- **Event-Driven**: Timer events flow through streams
- **Immutable Models**: Models use `copyWith` for state changes
- **Provider Pattern**: Riverpod providers wrap services for UI access
- **Service Abstraction**: Abstract interfaces (`TimerService`) allow platform-specific implementations

## Questions to Ask Before Adding Comments

1. Does the code name clearly explain what it does?
2. Is the logic genuinely complex or non-obvious?
3. Would a refactor make the code clearer than a comment?
4. Is this comment explaining "why" rather than "what"?

If the answer to #1 is "yes" and #2 is "no", skip the comment.
