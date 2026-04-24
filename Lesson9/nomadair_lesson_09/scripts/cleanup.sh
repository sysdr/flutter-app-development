#!/usr/bin/env bash

echo "[cleanup] Starting cleanup..."

if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then
    echo "[cleanup] Stopping running Docker containers..."
    docker ps -q | xargs -r docker stop

    echo "[cleanup] Pruning unused Docker resources..."
    docker system prune -af --volumes
  else
    echo "[cleanup] Docker daemon is not running; skipping Docker cleanup."
  fi
else
  echo "[cleanup] Docker not found; skipping Docker cleanup."
fi

if command -v adb >/dev/null 2>&1; then
  echo "[cleanup] Stopping Android emulator(s) via adb..."
  while read -r serial state; do
    if [[ "$serial" == emulator-* && "$state" == "device" ]]; then
      adb -s "$serial" emu kill || true
    fi
  done < <(adb devices | awk 'NR>1 && NF>=2 {print $1, $2}')
else
  echo "[cleanup] adb not found; skipping emulator shutdown."
fi

echo "[cleanup] Stopping leftover emulator/qemu/adb processes (if any)..."
pkill -f "emulator|qemu-system|adb" || true

echo "[cleanup] Cleanup complete."
