#!/usr/bin/env bash
# Stops local dev services: Android emulators (ADB), Docker containers, common Flutter/Dart processes.
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resolve_adb() {
  if command -v adb >/dev/null 2>&1; then
    command -v adb
    return 0
  fi
  if [ -n "${ANDROID_HOME:-}" ] && [ -x "${ANDROID_HOME}/platform-tools/adb" ]; then
    echo "${ANDROID_HOME}/platform-tools/adb"
    return 0
  fi
  if [ -n "${ANDROID_SDK_ROOT:-}" ] && [ -x "${ANDROID_SDK_ROOT}/platform-tools/adb" ]; then
    echo "${ANDROID_SDK_ROOT}/platform-tools/adb"
    return 0
  fi
  if [ -n "${LOCALAPPDATA:-}" ]; then
    win="${LOCALAPPDATA}/Android/Sdk/platform-tools/adb.exe"
    if [ -x "$win" ]; then
      echo "$win"
      return 0
    fi
  fi
  # WSL: Windows env LOCALAPPDATA is often unset; try common profile layout
  if [ -n "${USER:-}" ]; then
    wsl_adb="/mnt/c/Users/${USER}/AppData/Local/Android/Sdk/platform-tools/adb.exe"
    if [ -x "$wsl_adb" ]; then
      echo "$wsl_adb"
      return 0
    fi
  fi
  return 1
}

echo "[stop] Android emulators (ADB emu kill)..."
if ADB_BIN="$(resolve_adb)"; then
  "$ADB_BIN" devices 2>/dev/null | tail -n +2 | while read -r serial _; do
    case "$serial" in
      emulator-*) echo "[stop]   killing $serial"; "$ADB_BIN" -s "$serial" emu kill 2>/dev/null || true ;;
      *) ;;
    esac
  done
else
  echo "[stop]   adb not found; skip emulator kill."
fi

echo "[stop] Docker — stopping running containers..."
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker ps -q 2>/dev/null | while read -r id; do
    [ -z "$id" ] && continue
    docker stop "$id" >/dev/null 2>&1 || true
  done
else
  echo "[stop]   docker not available; skip."
fi

echo "[stop] Process hints (Flutter/Dart/qemu; best-effort)..."
if command -v pkill >/dev/null 2>&1; then
  pkill -f "[f]lutter run" 2>/dev/null || true
  pkill -f "[d]art.*flutter_tool" 2>/dev/null || true
  pkill -f "[q]emu-system" 2>/dev/null || true
else
  echo "[stop]   pkill not found; skip."
fi

echo "[stop] Done (script dir: $SCRIPT_DIR)."
