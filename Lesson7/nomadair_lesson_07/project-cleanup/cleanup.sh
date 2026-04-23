#!/usr/bin/env bash
# Stops running Docker containers and prunes unused images, networks, and build cache.
# Aggressive: review before use on shared machines.
# Deps: ../requirements.txt (Python note for ../setup.py), ../pubspec.yaml (Flutter).

set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "[cleanup] docker: not in PATH; nothing to do."
  exit 0
fi

echo "[cleanup] Docker: $(docker version --format '{{.Client.Version}}' 2>/dev/null || echo ok)"

echo "[cleanup] Stopping running containers..."
RUNNING="$(docker ps -q 2>/dev/null || true)"
if [ -n "${RUNNING}" ]; then
  # shellcheck disable=SC2086
  docker stop ${RUNNING}
else
  echo "  (none running)"
fi

echo "[cleanup] Prune stopped containers, unused images, networks, build cache..."
docker container prune -f
docker system prune -af
docker network prune -f
docker volume prune -f
if docker buildx version >/dev/null 2>&1; then
  docker builder prune -af 2>/dev/null || true
fi

echo "[cleanup] Remaining images (if any):"
docker images || true

echo "[cleanup] Done."
