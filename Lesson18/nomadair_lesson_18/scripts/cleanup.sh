#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[cleanup] root: $ROOT_DIR"

echo "[cleanup] stopping emulator/local services..."
bash "$ROOT_DIR/scripts/stop.sh" || true

echo "[cleanup] removing disposable artifacts..."
find "$ROOT_DIR" -type d \( -name node_modules -o -name venv -o -name .venv -o -name .pytest_cache \) -prune -exec rm -rf {} +
find "$ROOT_DIR" -type f -name "*.pyc" -delete
find "$ROOT_DIR" -iname "*istio*" -exec rm -rf {} + || true

echo "[cleanup] stopping containers and pruning docker..."
if command -v docker >/dev/null 2>&1; then
  docker ps -q | xargs -r docker stop >/dev/null 2>&1 || true
  docker system prune -af --volumes || true
else
  echo "[cleanup] docker not found, skipping."
fi

echo "[cleanup] complete."

