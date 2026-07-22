#!/usr/bin/env bash
# Builds a runnable Linux Release bundle and copies it to
# dist/linux/<folder>/ for distribution.
#
# Folder naming (default: version + build date/time):
#   ./scripts/build_linux_release.sh
#   ./scripts/build_linux_release.sh --folder-style Version      # Pomodoro-1.0.0+1
#   ./scripts/build_linux_release.sh --folder-style Date         # Pomodoro-2026-07-19_133045
#   ./scripts/build_linux_release.sh --folder-style VersionDate  # Pomodoro-1.0.0+1_2026-07-19_133045
#
# Prerequisites: Flutter SDK, Linux desktop toolchain (clang, cmake, ninja, GTK).

set -euo pipefail

FOLDER_STYLE='VersionDate'

while [[ $# -gt 0 ]]; do
  case "$1" in
    --folder-style)
      FOLDER_STYLE="${2:?--folder-style requires Version|Date|VersionDate}"
      shift 2
      ;;
    -h|--help)
      sed -n '2,12p' "$0"
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

case "$(uname -m)" in
  x86_64) ARCH='x64' ;;
  aarch64|arm64) ARCH='arm64' ;;
  *)
    echo "Unsupported Linux arch: $(uname -m)" >&2
    exit 1
    ;;
esac

get_pubspec_version() {
  local version
  version="$(sed -n 's/^[[:space:]]*version:[[:space:]]*//p' pubspec.yaml | head -n1 | tr -d '[:space:]')"
  if [[ -z "$version" ]]; then
    echo 'Could not read version from pubspec.yaml' >&2
    exit 1
  fi
  printf '%s' "$version"
}

dist_folder_name() {
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
DIST_FOLDER_NAME="$(dist_folder_name "$FOLDER_STYLE" "$APP_VERSION")"
DIST_ROOT="$PROJECT_ROOT/dist/linux"
DIST_DIR="$DIST_ROOT/$DIST_FOLDER_NAME"
RELEASE_DIR="$PROJECT_ROOT/build/linux/$ARCH/release/bundle"
BINARY_PATH="$RELEASE_DIR/pomodoro_sczuw"

echo "Using Flutter: $(command -v flutter)"
echo "App version: $APP_VERSION"
echo "Folder style: $FOLDER_STYLE"
echo "Linux arch: $ARCH"
echo 'Running: flutter build linux --release'

flutter build linux --release

if [[ ! -x "$BINARY_PATH" ]]; then
  echo "Build finished but executable not found at: $BINARY_PATH" >&2
  exit 1
fi

mkdir -p "$DIST_ROOT"
rm -rf "$DIST_DIR"

echo "Copying release bundle to: $DIST_DIR"
cp -a "$RELEASE_DIR" "$DIST_DIR"

DIST_BINARY="$DIST_DIR/pomodoro_sczuw"
if [[ ! -x "$DIST_BINARY" ]]; then
  echo "Copy finished but executable not found at: $DIST_BINARY" >&2
  exit 1
fi

echo
echo 'Release build ready.'
echo "Executable: $DIST_BINARY"
echo "Distribute the entire folder: $DIST_DIR"
echo '(pomodoro_sczuw alone is not enough — keep lib/ and data/ next to it.)'
