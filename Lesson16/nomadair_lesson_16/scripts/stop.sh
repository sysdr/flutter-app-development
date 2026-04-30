#!/usr/bin/env bash
set -euo pipefail

echo "[stop] Stopping Flutter/Dart/emulator/docker processes..."
powershell.exe -NoProfile -Command "Get-Process flutter,dart,emulator,qemu-system-x86_64,docker,com.docker.backend -ErrorAction SilentlyContinue | Stop-Process -Force" || true

echo "[stop] Requesting emulator shutdown via adb..."
ADB_PATH="/mnt/c/Users/syste/AppData/Local/Android/sdk/platform-tools/adb.exe"
if [ -x "$ADB_PATH" ]; then
  "$ADB_PATH" -s emulator-5554 emu kill >/dev/null 2>&1 || true
fi

echo "[stop] Done."
