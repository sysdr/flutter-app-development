#!/usr/bin/env bash
set -euo pipefail

echo "[stop] Attempting to stop all emulators…"
if command -v adb >/dev/null 2>&1; then
  adb devices | awk 'NR>1 && $1 ~ /^emulator-/ {print $1}' | while read -r serial; do
    echo "[stop] Killing emulator: $serial"
    adb -s "$serial" emu kill || true
  done
else
  echo "[stop] adb not found on PATH; nothing to stop."
fi

echo "[stop] Done."
