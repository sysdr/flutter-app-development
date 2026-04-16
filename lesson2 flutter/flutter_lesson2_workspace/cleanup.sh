#!/usr/bin/env bash
set -euo pipefail

echo "[cleanup] Starting Docker cleanup..."

if command -v docker >/dev/null 2>&1; then
  # Stop all running containers
  running_ids="$(docker ps -q || true)"
  if [[ -n "${running_ids}" ]]; then
    echo "[cleanup] Stopping running containers..."
    docker stop ${running_ids} >/dev/null || true
  else
    echo "[cleanup] No running containers."
  fi

  # Remove unused Docker resources
  echo "[cleanup] Pruning unused Docker resources..."
  docker container prune -f || true
  docker image prune -af || true
  docker volume prune -f || true
  docker network prune -f || true
  docker builder prune -af || true
  docker system prune -af --volumes || true
else
  echo "[cleanup] Docker CLI not found; skipping docker resource cleanup."
fi

# Try to stop Docker service on Linux systems
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl stop docker >/dev/null 2>&1 || true
  sudo systemctl stop containerd >/dev/null 2>&1 || true
fi

# Try to stop Docker service on SysV systems
if command -v service >/dev/null 2>&1; then
  sudo service docker stop >/dev/null 2>&1 || true
fi

echo "[cleanup] Done."
