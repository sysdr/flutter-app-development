#!/usr/bin/env bash
# Stop containers, prune Docker resources, and optionally stop Docker service on Windows.
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found. Install Docker Desktop/Engine first."
  exit 1
fi

echo "==> Verifying Docker daemon..."
if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon not reachable."
  exit 1
fi

echo "==> Stopping running containers..."
RUNNING="$(docker ps -q || true)"
if [ -n "${RUNNING}" ]; then
  docker stop ${RUNNING}
else
  echo "    (none running)"
fi

echo "==> Removing stopped containers..."
docker container prune -f

echo "==> Removing unused images..."
docker image prune -a -f

echo "==> Removing unused volumes..."
docker volume prune -f

echo "==> Removing build cache..."
docker builder prune -f

echo "==> System prune (unused networks, etc.)..."
docker system prune -f

if command -v powershell.exe >/dev/null 2>&1; then
  echo "==> Attempting to stop Windows Docker service (com.docker.service)..."
  powershell.exe -NoProfile -Command "try { Stop-Service -Name com.docker.service -Force -ErrorAction Stop; Write-Output 'Stopped com.docker.service.' } catch { Write-Output 'Could not stop com.docker.service (not running, not found, or admin required).' }"
fi

echo "==> Done."
