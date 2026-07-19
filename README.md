# Pomodoro

Desktop Pomodoro timer (Flutter). Primary target: Linux; Windows desktop supported.

## Linux

```bash
flutter build linux --release
flutter run -d linux
```

## Windows

Prerequisites:
- Flutter SDK
- [Visual Studio 2022 Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) with workload **Desktop development with C++** (MSVC, Windows SDK)

Run / debug:

```powershell
flutter run -d windows
```

Release `.exe` bundle:

```powershell
.\scripts\build_windows_release.ps1
```

Copies the runnable folder into `dist\windows\` with version and timestamp, e.g. `Pomodoro-1.0.0+1_2026-07-19_133045`.

Other naming styles:

```powershell
.\scripts\build_windows_release.ps1 -FolderStyle Version      # Pomodoro-1.0.0+1
.\scripts\build_windows_release.ps1 -FolderStyle Date         # Pomodoro-2026-07-19_133045
.\scripts\build_windows_release.ps1 -FolderStyle VersionDate  # default
```

Version is taken from `pubspec.yaml` (`version: 1.0.0+1`). Distribute the **whole** folder (not only `Pomodoro.exe`).
