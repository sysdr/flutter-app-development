#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "[cleanup] Workspace: $ROOT_DIR"

if command -v docker >/dev/null 2>&1; then
  echo "[cleanup] Docker detected. Cleaning containers/images/resources..."
  docker ps -q | xargs -r docker stop || true
  docker ps -aq | xargs -r docker rm -f || true
  docker images -q | xargs -r docker rmi -f || true
  docker system prune -a -f --volumes || true
else
  echo "[cleanup] Docker CLI not found. Skipping Docker resource cleanup."
fi

# Attempt to stop Docker service/processes on Windows.
if command -v powershell.exe >/dev/null 2>&1; then
  echo "[cleanup] Attempting to stop Docker Windows service/processes..."
  powershell.exe -NoProfile -Command "Stop-Service -Name com.docker.service -Force -ErrorAction SilentlyContinue" || true
  powershell.exe -NoProfile -Command "Get-Process 'Docker Desktop','com.docker.backend','dockerd' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue" || true
fi

echo "[cleanup] Removing local cache artifacts..."
find "$ROOT_DIR" -type d \( -name "node_modules" -o -name "venv" -o -name ".venv" -o -name ".pytest_cache" -o -name "__pycache__" \) -prune -exec rm -rf {} +
find "$ROOT_DIR" -type f -name "*.pyc" -delete
find "$ROOT_DIR" -iname "*istio*" -exec rm -rf {} +

echo "[cleanup] Done."

