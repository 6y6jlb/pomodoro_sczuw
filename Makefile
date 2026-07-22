# Convenience targets wrapping Flutter and platform release scripts.
#
# Usage:
#   make help
#   make pub-get
#   make run-linux | run-windows | run-android
#   make build-linux | build-windows | build-android
#   make release-linux | release-windows | release-android
#
# Optional:
#   make release-linux FOLDER_STYLE=Version
#   make release-android TARGET_PLATFORM=android-arm64
#   make release-windows FOLDER_STYLE=Date

.DEFAULT_GOAL := help

FOLDER_STYLE ?= VersionDate
TARGET_PLATFORM ?=

.PHONY: help pub-get doctor \
	run-linux run-windows run-android \
	build-linux build-windows build-android \
	release-linux release-windows release-android

help:
	@echo 'Pomodoro make targets'
	@echo ''
	@echo '  make pub-get                 flutter pub get'
	@echo '  make doctor                  flutter doctor'
	@echo '  make run-linux               flutter run -d linux'
	@echo '  make run-windows             flutter run -d windows'
	@echo '  make run-android             flutter run -d android'
	@echo '  make build-linux             flutter build linux --release'
	@echo '  make build-windows           flutter build windows --release'
	@echo '  make build-android           flutter build apk --release'
	@echo '  make release-linux           scripts/build_linux_release.sh -> dist/linux/'
	@echo '  make release-windows         scripts/build_windows_release.ps1 -> dist/windows/'
	@echo '  make release-android         scripts/build_android_release.sh -> dist/android/'
	@echo ''
	@echo 'Variables:'
	@echo '  FOLDER_STYLE=Version|Date|VersionDate   (default: VersionDate)'
	@echo '  TARGET_PLATFORM=android-arm64           (android release only)'

pub-get:
	flutter pub get

doctor:
	flutter doctor

run-linux:
	flutter run -d linux

run-windows:
	flutter run -d windows

run-android:
	flutter run -d android

build-linux:
	flutter build linux --release

build-windows:
	flutter build windows --release

build-android:
	flutter build apk --release

release-linux:
	./scripts/build_linux_release.sh --folder-style $(FOLDER_STYLE)

release-windows:
ifeq ($(OS),Windows_NT)
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./scripts/build_windows_release.ps1 -FolderStyle $(FOLDER_STYLE)
else
	@echo 'release-windows must be run on Windows (PowerShell + VS C++ toolchain).' >&2
	@exit 1
endif

release-android:
ifeq ($(TARGET_PLATFORM),)
	./scripts/build_android_release.sh --folder-style $(FOLDER_STYLE)
else
	./scripts/build_android_release.sh --folder-style $(FOLDER_STYLE) --target-platform $(TARGET_PLATFORM)
endif
