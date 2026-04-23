#!/usr/bin/env bash
set -euo pipefail

echo "[stop] stopping app/emulator services..."

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if command_exists taskkill; then
  taskkill //F //IM dart.exe //T >/dev/null 2>&1 || true
  taskkill //F //IM flutter.bat //T >/dev/null 2>&1 || true
fi

if command_exists adb; then
  adb -s emulator-5554 emu kill >/dev/null 2>&1 || true
fi

if command_exists taskkill; then
  taskkill //F //IM emulator.exe //T >/dev/null 2>&1 || true
  taskkill //F //IM qemu-system-x86_64.exe //T >/dev/null 2>&1 || true
fi

if command_exists docker; then
  docker ps -q | xargs -r docker stop >/dev/null 2>&1 || true
fi

echo "[stop] done."
