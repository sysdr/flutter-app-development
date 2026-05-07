#!/usr/bin/env bash
set -euo pipefail

echo "[cleanup] Stopping Docker containers (if any)…"
if command -v docker >/dev/null 2>&1; then
  docker ps -q | xargs -r docker stop >/dev/null 2>&1 || true
  echo "[cleanup] Pruning unused Docker resources…"
  docker system prune -af --volumes || true
else
  echo "[cleanup] docker not found; skipping Docker cleanup."
fi

echo "[cleanup] Stopping Android emulator (if running)…"
if command -v adb >/dev/null 2>&1; then
  adb devices | awk 'NR>1 && $1 ~ /^emulator-/ {print $1}' | while read -r serial; do
    echo "[cleanup] Killing emulator: $serial"
    adb -s "$serial" emu kill || true
  done
else
  echo "[cleanup] adb not found on PATH; skipping emulator shutdown."
fi

echo "[cleanup] Done."
