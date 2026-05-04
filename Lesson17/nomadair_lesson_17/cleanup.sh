#!/usr/bin/env bash
# Run stop.sh, remove common junk under this Flutter project, optionally prune Docker.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# This script lives at the repo root (nomadair_lesson_17/).
PROJECT_DIR="$SCRIPT_DIR"

echo "[cleanup] Project root: $PROJECT_DIR"
bash "$SCRIPT_DIR/stop.sh"

echo "[cleanup] Removing node_modules, Python venvs, caches, *.pyc, Istio-named paths..."
if command -v find >/dev/null 2>&1; then
  find "$PROJECT_DIR" -type d \( \
    -name "node_modules" -o -name "venv" -o -name ".venv" -o \
    -name ".pytest_cache" -o -name "__pycache__" \
    \) -prune -exec rm -rf {} + 2>/dev/null || true
  find "$PROJECT_DIR" -type f \( -name "*.pyc" -o -iname "*istio*" \) -delete 2>/dev/null || true
  find "$PROJECT_DIR" -type d -iname "*istio*" -prune -exec rm -rf {} + 2>/dev/null || true
else
  echo "[cleanup]  find not available; skip file tree cleanup."
fi

echo "[cleanup] Pruning unused Docker resources (containers, images, build cache)..."
if command -v docker >/dev/null 2>&1; then
  docker container prune -f 2>/dev/null || true
  docker image prune -af 2>/dev/null || true
  docker builder prune -af 2>/dev/null || true
  docker system prune -af --volumes 2>/dev/null || true
else
  echo "[cleanup]  docker not found; skip Docker prune."
fi

echo "[cleanup] Done."
