#!/usr/bin/env bash
set -eu

echo "[stop] Stopping Flutter/Dart processes..."
if command -v pkill >/dev/null 2>&1; then
  pkill -f "flutter run" || true
  pkill -f dart || true
fi

ADB_BIN="${ADB_BIN:-/c/Users/syste/AppData/Local/Android/sdk/platform-tools/adb.exe}"
if [ -x "$ADB_BIN" ]; then
  echo "[stop] Stopping Android emulator and adb server..."
  "$ADB_BIN" -s emulator-5554 emu kill >/dev/null 2>&1 || true
  "$ADB_BIN" kill-server >/dev/null 2>&1 || true
fi

if command -v docker >/dev/null 2>&1; then
  echo "[stop] Stopping running Docker containers..."
  docker ps -q | xargs -r docker stop || true
fi

echo "[stop] Done."
