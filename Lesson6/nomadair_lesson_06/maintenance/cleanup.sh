#!/usr/bin/env bash
set -euo pipefail

echo "[cleanup] Starting Docker cleanup..."

if ! command -v docker >/dev/null 2>&1; then
  echo "[cleanup] Docker CLI not found. Skipping Docker cleanup."
  exit 0
fi

if ! docker info >/dev/null 2>&1; then
  echo "[cleanup] Docker daemon is not running or inaccessible. Skipping."
  exit 0
fi

echo "[cleanup] Stopping running containers (if any)..."
running_containers="$(docker ps -q || true)"
if [[ -n "${running_containers}" ]]; then
  docker stop ${running_containers}
else
  echo "[cleanup] No running containers found."
fi

echo "[cleanup] Removing all containers (if any)..."
all_containers="$(docker ps -aq || true)"
if [[ -n "${all_containers}" ]]; then
  docker rm ${all_containers}
else
  echo "[cleanup] No containers to remove."
fi

echo "[cleanup] Removing unused images, networks, cache, and volumes..."
docker system prune -a --volumes -f

echo "[cleanup] Docker cleanup complete."
