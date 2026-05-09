#!/usr/bin/env bash
set -euo pipefail

echo "[stop] Stopping Flutter/ADB/emulator processes..."
pkill -f "flutter run" || true
pkill -f "dart" || true
pkill -f "adb" || true
pkill -f "emulator" || true
pkill -f "qemu-system" || true

if command -v adb >/dev/null 2>&1; then
  adb -s emulator-5554 emu kill || true
fi

echo "[stop] Done."
