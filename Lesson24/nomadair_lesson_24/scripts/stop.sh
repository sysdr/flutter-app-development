#!/usr/bin/env bash
# Stop Flutter/Dart, Gradle daemons, Android emulator, and app on device.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG="com.nomadair.nomadair_lesson_24"

log() { printf '[stop] %s\n' "$*"; }

# Android SDK tools
ADB="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/AppData/Local/Android/Sdk}}/platform-tools/adb"
if [[ ! -x "$ADB" && -f "/c/Users/$USER/AppData/Local/Android/Sdk/platform-tools/adb.exe" ]]; then
  ADB="/c/Users/$USER/AppData/Local/Android/Sdk/platform-tools/adb.exe"
fi
if [[ ! -x "$ADB" ]]; then
  ADB="$(command -v adb 2>/dev/null || true)"
fi

log "Stopping Flutter/Dart processes (project: nomadair_lesson_24)…"
if command -v taskkill >/dev/null 2>&1; then
  taskkill //F //IM dart.exe 2>/dev/null || true
  taskkill //F //IM dartaotruntime.exe 2>/dev/null || true
  taskkill //F //IM java.exe 2>/dev/null || true
elif command -v pkill >/dev/null 2>&1; then
  pkill -f "flutter.*nomadair_lesson_24" 2>/dev/null || true
  pkill -f "dart.*nomadair_lesson_24" 2>/dev/null || true
fi

if [[ -n "$ADB" && -x "$ADB" ]]; then
  log "Force-stopping app: ${PKG}"
  "$ADB" shell am force-stop "$PKG" 2>/dev/null || true
  log "Killing emulator (if running)…"
  "$ADB" emu kill 2>/dev/null || true
else
  log "adb not found — skipped app/emulator stop"
fi

if [[ -d "${ROOT}/android" ]]; then
  log "Stopping Gradle daemons…"
  (cd "${ROOT}/android" && ./gradlew --stop 2>/dev/null) || \
  (cd "${ROOT}/android" && gradlew.bat --stop 2>/dev/null) || true
fi

log "Done."
