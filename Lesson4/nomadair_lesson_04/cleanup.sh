#!/usr/bin/env bash
set -euo pipefail

echo "[cleanup] Starting Docker cleanup..."

if ! command -v docker >/dev/null 2>&1; then
  echo "[cleanup] Docker CLI not found. Skipping Docker cleanup."
  exit 0
fi

if ! docker info >/dev/null 2>&1; then
  echo "[cleanup] Docker daemon is not reachable. Start Docker Desktop and retry."
  exit 0
fi

running_containers="$(docker ps -q || true)"
if [[ -n "${running_containers}" ]]; then
  echo "[cleanup] Stopping running containers..."
  docker stop ${running_containers}
else
  echo "[cleanup] No running containers found."
fi

all_containers="$(docker ps -aq || true)"
if [[ -n "${all_containers}" ]]; then
  echo "[cleanup] Removing containers..."
  docker rm -f ${all_containers}
else
  echo "[cleanup] No containers to remove."
fi

echo "[cleanup] Pruning unused Docker resources..."
docker system prune -a --volumes -f

echo "[cleanup] Docker cleanup completed."
