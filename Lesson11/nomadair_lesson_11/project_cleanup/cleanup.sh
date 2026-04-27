#!/usr/bin/env bash
set -eu

echo "[cleanup] Starting cleanup for Lesson11..."

if command -v docker >/dev/null 2>&1; then
  echo "[cleanup] Stopping running Docker containers..."
  docker ps -q | xargs -r docker stop || true

  echo "[cleanup] Removing stopped containers..."
  docker container prune -f || true

  echo "[cleanup] Removing dangling and unused Docker images/networks/volumes..."
  docker system prune -af --volumes || true
else
  echo "[cleanup] Docker not found in PATH, skipping Docker cleanup."
fi

echo "[cleanup] Stopping emulator and Flutter helper processes..."
if command -v taskkill >/dev/null 2>&1; then
  taskkill //F //IM emulator.exe >/dev/null 2>&1 || true
  taskkill //F //IM qemu-system-x86_64.exe >/dev/null 2>&1 || true
  taskkill //F //IM adb.exe >/dev/null 2>&1 || true
  taskkill //F //IM dart.exe >/dev/null 2>&1 || true
  taskkill //F //IM dartvm.exe >/dev/null 2>&1 || true
  taskkill //F //IM dartaotruntime.exe >/dev/null 2>&1 || true
fi

echo "[cleanup] Removing local cache folders/files..."
ROOT_DIR="${CLEANUP_ROOT:-$(pwd)}"
find "$ROOT_DIR" -type d \( -name node_modules -o -name venv -o -name .venv -o -name .pytest_cache -o -name __pycache__ \) -prune -exec rm -rf {} +
find "$ROOT_DIR" -type f \( -name "*.pyc" -o -name "*.pyo" -o -name "*.pyd" \) -delete

echo "[cleanup] Done."
