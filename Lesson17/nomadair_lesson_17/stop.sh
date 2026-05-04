#!/usr/bin/env bash
# Stop Android emulators (adb) and running Docker containers.
set -euo pipefail

echo "[stop] Stopping Android emulators (adb)..."
ADB=""
if command -v adb >/dev/null 2>&1; then
  ADB="$(command -v adb)"
elif [ -n "${ANDROID_HOME:-}" ] && [ -x "${ANDROID_HOME}/platform-tools/adb" ]; then
  ADB="${ANDROID_HOME}/platform-tools/adb"
elif [ -n "${LOCALAPPDATA:-}" ] && [ -x "${LOCALAPPDATA}/Android/Sdk/platform-tools/adb" ]; then
  ADB="${LOCALAPPDATA}/Android/Sdk/platform-tools/adb"
fi

if [ -n "$ADB" ]; then
  for serial in $($ADB devices 2>/dev/null | awk '/emulator/ {print $1}'); do
    echo "[stop]  adb -s $serial emu kill"
    $ADB -s "$serial" emu kill 2>/dev/null || true
  done
else
  echo "[stop]  adb not found; skip emulator shutdown."
fi

echo "[stop] Stopping Docker containers..."
if command -v docker >/dev/null 2>&1; then
  running="$(docker ps -q 2>/dev/null || true)"
  if [ -n "$running" ]; then
    docker stop $running 2>/dev/null || true
  else
    echo "[stop]  no running containers."
  fi
else
  echo "[stop]  docker not found; skip."
fi

echo "[stop] Done."
