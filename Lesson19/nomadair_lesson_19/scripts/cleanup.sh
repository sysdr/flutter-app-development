#!/usr/bin/env bash
# Runs stop.sh, then prunes unused Docker data (images, containers, networks, build cache).
# Review before use on machines where you need to keep unused images.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "${SCRIPT_DIR}/stop.sh"

echo "[cleanup] Docker system prune (unused images, containers, networks, build cache)"
if command -v docker >/dev/null 2>&1; then
  docker system prune -af 2>/dev/null || true
  docker builder prune -af 2>/dev/null || true
else
  echo "[cleanup] docker not found; skipping prune."
fi

echo "[cleanup] Done."
