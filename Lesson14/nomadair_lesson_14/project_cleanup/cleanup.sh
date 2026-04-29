#!/usr/bin/env bash
set -eu

echo "[cleanup] stopping local services..."
bash "$(dirname "$0")/stop.sh" || true

if command -v docker >/dev/null 2>&1; then
  echo "[cleanup] stopping running containers..."
  docker ps -q | xargs -r docker stop || true
  echo "[cleanup] pruning unused containers/images/volumes/networks..."
  docker system prune -af --volumes || true
else
  echo "[cleanup] docker not available; skipping docker cleanup."
fi

echo "[cleanup] removing caches/artifacts..."
find . -type d \( -name "node_modules" -o -name "venv" -o -name ".venv" -o -name ".pytest_cache" -o -name "__pycache__" \) -prune -exec rm -rf {} +
find . -type f -name "*.pyc" -delete
find . -type f -iname "*istio*" -delete
find . -type d -iname "*istio*" -prune -exec rm -rf {} +

echo "[cleanup] complete."
