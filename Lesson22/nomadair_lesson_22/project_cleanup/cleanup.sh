#!/usr/bin/env bash
set -euo pipefail

echo "[cleanup] Stop local app/emulator services..."
"$(dirname "$0")/stop.sh" || true

echo "[cleanup] Stopping Docker containers..."
if command -v docker >/dev/null 2>&1 && docker version >/dev/null 2>&1; then
  docker ps -q | xargs -r docker stop || true
  echo "[cleanup] Removing all containers..."
  docker ps -aq | xargs -r docker rm -f || true
  echo "[cleanup] Removing all images..."
  docker images -q | xargs -r docker rmi -f || true
  echo "[cleanup] Pruning unused Docker resources..."
  docker system prune -af --volumes || true
else
  echo "[cleanup] Docker CLI/daemon unavailable in this shell, skipping Docker cleanup."
fi

echo "[cleanup] Done."
