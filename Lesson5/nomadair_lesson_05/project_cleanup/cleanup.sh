#!/usr/bin/env bash
set -eu

echo "[cleanup] Stopping running Docker containers..."
if command -v docker >/dev/null 2>&1; then
  containers="$(docker ps -q || true)"
  if [[ -n "${containers}" ]]; then
    docker stop ${containers} >/dev/null
  fi

  echo "[cleanup] Pruning unused Docker resources..."
  docker container prune -f >/dev/null || true
  docker image prune -a -f >/dev/null || true
  docker system prune -f >/dev/null || true
else
  echo "[cleanup] docker command not found; skipping Docker cleanup."
fi

echo "[cleanup] Done."

