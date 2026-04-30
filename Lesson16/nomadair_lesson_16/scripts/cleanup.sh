#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "[cleanup] Project: $PROJECT_DIR"
bash "$SCRIPT_DIR/stop.sh"

echo "[cleanup] Removing local caches/artifacts..."
find "$PROJECT_DIR" -type d \( -name "node_modules" -o -name "venv" -o -name ".venv" -o -name ".pytest_cache" -o -name "__pycache__" \) -prune -exec rm -rf {} +
find "$PROJECT_DIR" -type f \( -name "*.pyc" -o -iname "*istio*" \) -delete
find "$PROJECT_DIR" -type d -iname "*istio*" -prune -exec rm -rf {} +

echo "[cleanup] Pruning Docker resources..."
if command -v docker >/dev/null 2>&1; then
  docker ps -aq | xargs -r docker stop >/dev/null 2>&1 || true
  docker ps -aq | xargs -r docker rm >/dev/null 2>&1 || true
  docker image prune -af >/dev/null 2>&1 || true
  docker container prune -f >/dev/null 2>&1 || true
  docker system prune -af --volumes >/dev/null 2>&1 || true
else
  echo "[cleanup] docker not found in PATH, skipping Docker prune."
fi

echo "[cleanup] Done."
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "[cleanup] Project: $PROJECT_DIR"
bash "$SCRIPT_DIR/stop.sh"

echo "[cleanup] Removing local caches/artifacts..."
find "$PROJECT_DIR" -type d \( -name "node_modules" -o -name "venv" -o -name ".venv" -o -name ".pytest_cache" -o -name "__pycache__" \) -prune -exec rm -rf {} +
find "$PROJECT_DIR" -type f \( -name "*.pyc" -o -iname "*istio*" \) -delete
find "$PROJECT_DIR" -type d -iname "*istio*" -prune -exec rm -rf {} +

echo "[cleanup] Pruning Docker resources..."
if command -v docker >/dev/null 2>&1; then
  docker ps -aq | xargs -r docker stop >/dev/null 2>&1 || true
  docker ps -aq | xargs -r docker rm >/dev/null 2>&1 || true
  docker image prune -af >/dev/null 2>&1 || true
  docker container prune -f >/dev/null 2>&1 || true
  docker system prune -af --volumes >/dev/null 2>&1 || true
else
  echo "[cleanup] docker not found in PATH, skipping Docker prune."
fi

echo "[cleanup] Done."
