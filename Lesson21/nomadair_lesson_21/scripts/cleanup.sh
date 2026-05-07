#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "[cleanup] Project root: $PROJECT_ROOT"

bash "$SCRIPT_DIR/stop.sh"

echo "[cleanup] Docker cleanup (if available)..."
if command -v docker >/dev/null 2>&1; then
  docker ps -q | xargs -r docker stop || true
  docker container prune -f || true
  docker image prune -af || true
  docker system prune -af || true
else
  echo "[cleanup] docker not found, skipping docker cleanup."
fi

echo "[cleanup] Removing local caches/artifacts..."
find "$PROJECT_ROOT" -type d \( -name node_modules -o -name venv -o -name .venv -o -name .pytest_cache -o -iname "*istio*" \) -prune -exec rm -rf {} + || true
find "$PROJECT_ROOT" -type f \( -name "*.pyc" -o -iname "*istio*" \) -delete || true

echo "[cleanup] Done."
