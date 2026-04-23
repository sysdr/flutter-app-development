#!/usr/bin/env bash
# Stops local Flutter / Dart / emulator processes for this project (best effort).
# Run from Git Bash or WSL:  chmod +x stop.sh && ./stop.sh
# Does not uninstall the app from a device; it only stops tooling processes.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_NAME="nomadair_lesson_07"

echo "[stop] ${PROJECT_NAME}: stopping local Flutter / emulator services..."

run_if_exists() {
  local cmd="$1"
  shift || true
  if command -v "$cmd" >/dev/null 2>&1; then
    "$cmd" "$@" || true
  fi
}

# Android emulator: graceful shutdown (default first device if set)
if command -v adb >/dev/null 2>&1; then
  if adb devices 2>/dev/null | grep -q "emulator-5554[[:space:]]*device"; then
    run_if_exists adb -s emulator-5554 emu kill
  else
    # Any emulator serial
    emu="$(adb devices 2>/dev/null | awk '/^emulator-[0-9]+/ {print $1; exit}')"
    if [[ -n "${emu}" ]]; then
      run_if_exists adb -s "${emu}" emu kill
    fi
  fi
  run_if_exists adb kill-server
fi

# Prefer killing processes whose command line mentions this project path (narrower than global dart kill)
if command -v pkill >/dev/null 2>&1; then
  pkill -f "${SCRIPT_DIR}" 2>/dev/null || true
  pkill -f "flutter run.*${PROJECT_NAME}" 2>/dev/null || true
  pkill -f "flutter tools run" 2>/dev/null || true
fi

# Broad fallback (same as other NomadAir lessons) if project-scoped patterns miss
if command -v pkill >/dev/null 2>&1; then
  pkill -f "flutter run" 2>/dev/null || true
  pkill -f "dart" 2>/dev/null || true
  pkill -f "qemu-system" 2>/dev/null || true
  pkill -f "emulator" 2>/dev/null || true
fi

echo "[stop] Done. If something is still running, close the terminal or Android Emulator UI."
