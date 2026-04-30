#!/usr/bin/env bash
# Stop local dev processes: Flutter tooling, Docker containers, Android emulators.
# Safe to run repeatedly; ignores missing tools.
# Run from Git Bash (Windows), WSL, macOS, or Linux.

set -u

echo "[stop.sh] Stopping Docker containers (if Docker CLI is available)..."
if command -v docker >/dev/null 2>&1; then
  ids="$(docker ps -q 2>/dev/null || true)"
  if [[ -n "${ids}" ]]; then
    docker stop ${ids} 2>/dev/null || true
  fi
fi

echo "[stop.sh] Stopping Flutter / Dart processes (Windows Git Bash / CMD helpers)..."
if command -v taskkill >/dev/null 2>&1; then
  taskkill //F //IM flutter.exe 2>/dev/null || true
  taskkill //F //IM dart.exe 2>/dev/null || true
fi

echo "[stop.sh] Stopping Android emulators via adb (if present)..."
ADB=""
if [[ -n "${ANDROID_HOME:-}" ]] && [[ -x "${ANDROID_HOME}/platform-tools/adb" ]]; then
  ADB="${ANDROID_HOME}/platform-tools/adb"
elif [[ -x "${LOCALAPPDATA:-}/Android/Sdk/platform-tools/adb.exe" ]]; then
  ADB="${LOCALAPPDATA}/Android/Sdk/platform-tools/adb.exe"
elif command -v adb >/dev/null 2>&1; then
  ADB="adb"
fi

if [[ -n "${ADB}" ]]; then
  while read -r line; do
    dev="$(echo "${line}" | awk '{print $1}')"
    if [[ "${dev}" == emulator-* ]]; then
      echo "[stop.sh]   emu kill ${dev}"
      "${ADB}" -s "${dev}" emu kill 2>/dev/null || true
    fi
  done < <("${ADB}" devices 2>/dev/null | tail -n +2 || true)
fi

echo "[stop.sh] Done."
