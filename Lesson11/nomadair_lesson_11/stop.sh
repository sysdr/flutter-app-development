#!/usr/bin/env bash
set -eu

echo "[stop] Stopping Flutter/Android helper processes..."
if command -v taskkill >/dev/null 2>&1; then
  taskkill //F //IM dart.exe >/dev/null 2>&1 || true
  taskkill //F //IM dartvm.exe >/dev/null 2>&1 || true
  taskkill //F //IM dartaotruntime.exe >/dev/null 2>&1 || true
  taskkill //F //IM adb.exe >/dev/null 2>&1 || true
  taskkill //F //IM emulator.exe >/dev/null 2>&1 || true
  taskkill //F //IM qemu-system-x86_64.exe >/dev/null 2>&1 || true
fi

echo "[stop] Stopping Docker containers (if Docker exists)..."
if command -v docker >/dev/null 2>&1; then
  docker ps -q | xargs -r docker stop || true
fi

echo "[stop] Done."
