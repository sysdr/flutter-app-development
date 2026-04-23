#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[cleanup] project root: $PROJECT_ROOT"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

echo "[cleanup] stopping flutter/dart processes..."
if command_exists taskkill; then
  taskkill //F //IM dart.exe //T >/dev/null 2>&1 || true
  taskkill //F //IM flutter.bat //T >/dev/null 2>&1 || true
fi

echo "[cleanup] stopping emulator processes..."
if command_exists adb; then
  adb -s emulator-5554 emu kill >/dev/null 2>&1 || true
fi
if command_exists taskkill; then
  taskkill //F //IM emulator.exe //T >/dev/null 2>&1 || true
  taskkill //F //IM qemu-system-x86_64.exe //T >/dev/null 2>&1 || true
fi

echo "[cleanup] stopping containers and pruning docker resources..."
if command_exists docker; then
  docker ps -q | xargs -r docker stop >/dev/null 2>&1 || true
  docker container prune -f >/dev/null 2>&1 || true
  docker image prune -af >/dev/null 2>&1 || true
  docker volume prune -f >/dev/null 2>&1 || true
  docker network prune -f >/dev/null 2>&1 || true
  docker system prune -af --volumes >/dev/null 2>&1 || true
else
  echo "[cleanup] docker not installed, skipping docker cleanup."
fi

echo "[cleanup] deleting project caches and generated artifacts..."
find "$PROJECT_ROOT" -type d -name "node_modules" -prune -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_ROOT" -type d -name "venv" -prune -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_ROOT" -type d -name ".venv" -prune -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_ROOT" -type d -name ".pytest_cache" -prune -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_ROOT" -type d -name "__pycache__" -prune -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_ROOT" -type f -name "*.pyc" -delete 2>/dev/null || true

echo "[cleanup] done."
