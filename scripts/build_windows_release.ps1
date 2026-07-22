# Builds a runnable Windows Release bundle with Pomodoro.exe and copies it to
# dist\windows\<folder>\ for distribution.
#
# Folder naming (default: version + build date/time):
#   .\scripts\build_windows_release.ps1
#   .\scripts\build_windows_release.ps1 -FolderStyle Version      # Pomodoro-1.0.0+1
#   .\scripts\build_windows_release.ps1 -FolderStyle Date         # Pomodoro-2026-07-19_133045
#   .\scripts\build_windows_release.ps1 -FolderStyle VersionDate  # Pomodoro-1.0.0+1_2026-07-19_133045
#
# Prerequisites: Flutter SDK, Visual Studio 2022 Build Tools with C++ workload.

param(
  [ValidateSet('Version', 'Date', 'VersionDate')]
  [string]$FolderStyle = 'VersionDate'
)

$ErrorActionPreference = 'Stop'

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $ProjectRoot

function Get-PubspecVersion {
  $pubspecPath = Join-Path $ProjectRoot 'pubspec.yaml'
  foreach ($line in Get-Content $pubspecPath) {
    if ($line -match '^\s*version:\s*(.+)\s*$') {
      return $Matches[1].Trim()
    }
  }
  Write-Error 'Could not read version from pubspec.yaml'
}

function Get-DistFolderName {
  param(
    [string]$Style,
    [string]$AppVersion
  )

  $stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
  switch ($Style) {
    'Version' { return "Pomodoro-$AppVersion" }
    'Date' { return "Pomodoro-$stamp" }
    'VersionDate' { return "Pomodoro-${AppVersion}_$stamp" }
  }
}

$Flutter = $env:FLUTTER_ROOT
if ($Flutter) {
  $FlutterBat = Join-Path $Flutter 'bin\flutter.bat'
} else {
  $cmd = Get-Command flutter.bat -ErrorAction SilentlyContinue
  if ($cmd) {
    $FlutterBat = $cmd.Source
  } else {
    $candidates = @(
      'S:\dev\flutter\bin\flutter.bat',
      "$env:LOCALAPPDATA\flutter\bin\flutter.bat",
      'C:\flutter\bin\flutter.bat',
      'C:\src\flutter\bin\flutter.bat'
    )
    $FlutterBat = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
  }
}

if (-not $FlutterBat -or -not (Test-Path $FlutterBat)) {
  Write-Error 'flutter.bat not found. Install Flutter or set FLUTTER_ROOT / add flutter to PATH.'
}

$AppVersion = Get-PubspecVersion
$DistFolderName = Get-DistFolderName -Style $FolderStyle -AppVersion $AppVersion
$DistRoot = Join-Path $ProjectRoot 'dist\windows'
$DistDir = Join-Path $DistRoot $DistFolderName

Write-Host "Using Flutter: $FlutterBat"
Write-Host "App version: $AppVersion"
Write-Host "Folder style: $FolderStyle"
Write-Host 'Running: flutter build windows --release'

# Flutter may skip creating this when no package has Dart FFI native assets;
# CMake still expects the path unless windows/CMakeLists.txt guards with EXISTS.
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot 'build\native_assets\windows') | Out-Null

& $FlutterBat build windows --release
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

$ReleaseDir = Join-Path $ProjectRoot 'build\windows\x64\runner\Release'
$ExePath = Join-Path $ReleaseDir 'Pomodoro.exe'

if (-not (Test-Path $ExePath)) {
  Write-Error "Build finished but executable not found at: $ExePath"
}

New-Item -ItemType Directory -Force -Path $DistRoot | Out-Null
if (Test-Path $DistDir) {
  Remove-Item -Recurse -Force $DistDir
}

Write-Host "Copying release bundle to: $DistDir"
Copy-Item -Path $ReleaseDir -Destination $DistDir -Recurse

$DistExe = Join-Path $DistDir 'Pomodoro.exe'
if (-not (Test-Path $DistExe)) {
  Write-Error "Copy finished but executable not found at: $DistExe"
}

Write-Host ''
Write-Host 'Release build ready.'
Write-Host "Executable: $DistExe"
Write-Host "Distribute the entire folder: $DistDir"
Write-Host '(Pomodoro.exe alone is not enough - keep DLLs and data\ next to it.)'
