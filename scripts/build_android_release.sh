#!/usr/bin/env bash
# Builds a Release APK and copies it to dist/android/<name>.apk for distribution.
#
# File naming (default: version + build date/time):
#   ./scripts/build_android_release.sh
#   ./scripts/build_android_release.sh --folder-style Version      # Pomodoro-1.0.0+1.apk
#   ./scripts/build_android_release.sh --folder-style Date         # Pomodoro-2026-07-19_133045.apk
#   ./scripts/build_android_release.sh --folder-style VersionDate  # Pomodoro-1.0.0+1_2026-07-19_133045.apk
#
# Optional:
#   ./scripts/build_android_release.sh --target-platform android-arm64
#
# Prerequisites: Flutter SDK, Android SDK. App id: com.pomodoro_sczuw.app
# Note: current Gradle release config may still use debug signing — replace before store publish.

set -euo pipefail

FOLDER_STYLE='VersionDate'
TARGET_PLATFORM=''

while [[ $# -gt 0 ]]; do
  case "$1" in
    --folder-style)
      FOLDER_STYLE="${2:?--folder-style requires Version|Date|VersionDate}"
      shift 2
      ;;
    --target-platform)
      TARGET_PLATFORM="${2:?--target-platform requires a Flutter Android ABI, e.g. android-arm64}"
      shift 2
      ;;
    -h|--help)
      sed -n '2,15p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

case "$FOLDER_STYLE" in
  Version|Date|VersionDate) ;;
  *)
    echo "Invalid --folder-style: $FOLDER_STYLE (use Version, Date, or VersionDate)" >&2
    exit 1
    ;;
esac

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

if ! command -v flutter >/dev/null 2>&1; then
  echo 'flutter not found. Install Flutter or add it to PATH.' >&2
  exit 1
fi

get_pubspec_version() {
  local version
  version="$(sed -n 's/^[[:space:]]*version:[[:space:]]*//p' pubspec.yaml | head -n1 | tr -d '[:space:]')"
  if [[ -z "$version" ]]; then
    echo 'Could not read version from pubspec.yaml' >&2
    exit 1
  fi
  printf '%s' "$version"
}

dist_file_stem() {
  local style="$1"
  local app_version="$2"
  local stamp
  stamp="$(date +'%Y-%m-%d_%H%M%S')"
  case "$style" in
    Version) printf 'Pomodoro-%s' "$app_version" ;;
    Date) printf 'Pomodoro-%s' "$stamp" ;;
    VersionDate) printf 'Pomodoro-%s_%s' "$app_version" "$stamp" ;;
  esac
}

APP_VERSION="$(get_pubspec_version)"
DIST_STEM="$(dist_file_stem "$FOLDER_STYLE" "$APP_VERSION")"
DIST_ROOT="$PROJECT_ROOT/dist/android"
DIST_APK="$DIST_ROOT/${DIST_STEM}.apk"
SOURCE_APK="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-release.apk"

BUILD_ARGS=(build apk --release)
if [[ -n "$TARGET_PLATFORM" ]]; then
  BUILD_ARGS+=(--target-platform "$TARGET_PLATFORM")
fi

echo "Using Flutter: $(command -v flutter)"
echo "App version: $APP_VERSION"
echo "Name style: $FOLDER_STYLE"
echo "App id: com.pomodoro_sczuw.app"
if [[ -n "$TARGET_PLATFORM" ]]; then
  echo "Target platform: $TARGET_PLATFORM"
fi
echo "Running: flutter ${BUILD_ARGS[*]}"

flutter "${BUILD_ARGS[@]}"

if [[ ! -f "$SOURCE_APK" ]]; then
  echo "Build finished but APK not found at: $SOURCE_APK" >&2
  exit 1
fi

mkdir -p "$DIST_ROOT"
rm -f "$DIST_APK"

echo "Copying APK to: $DIST_APK"
cp -f "$SOURCE_APK" "$DIST_APK"

echo
echo 'Release APK ready.'
echo "APK: $DIST_APK"
echo 'Install with: adb install -r '"$DIST_APK"
echo 'MVP note: timer is foreground-only (no background service).'
