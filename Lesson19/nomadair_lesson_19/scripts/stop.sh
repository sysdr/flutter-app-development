#!/usr/bin/env bash
# Stops local Android emulator hooks, Docker containers, and common emulator processes.
# Safe to run repeatedly; ignores missing tools.
set -euo pipefail

echo "[stop] Android / adb"
if command -v adb >/dev/null 2>&1; then
  adb emu kill 2>/dev/null || true
  adb kill-server 2>/dev/null || true
fi

# Windows (Git Bash): terminate emulator binaries if still running
if command -v taskkill >/dev/null 2>&1; then
  taskkill //F //IM emulator.exe 2>/dev/null || true
  taskkill //F //IM qemu-system-x86_64.exe 2>/dev/null || true
  taskkill //F //IM qemu-system-aarch64.exe 2>/dev/null || true
fi

echo "[stop] Docker containers (running)"
if command -v docker >/dev/null 2>&1; then
  ids="$(docker ps -q 2>/dev/null || true)"
  if [ -n "${ids}" ]; then
    # shellcheck disable=SC2086
    docker stop ${ids} 2>/dev/null || true
  fi
fi

echo "[stop] Done."
