#!/usr/bin/env bash
# Full cleanup: stop services, Docker prune, remove local artifacts.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() { printf '[cleanup] %s\n' "$*"; }

log "=== Phase 1: stop services ==="
bash "${ROOT}/scripts/stop.sh"

log "=== Phase 2: Docker ==="
if command -v docker >/dev/null 2>&1; then
  docker stop $(docker ps -q) 2>/dev/null || true
  docker container prune -f 2>/dev/null || true
  docker image prune -af 2>/dev/null || true
  docker volume prune -f 2>/dev/null || true
  docker network prune -f 2>/dev/null || true
  docker system prune -af --volumes 2>/dev/null || true
  log "Docker resources pruned"
else
  log "docker not installed — skipped"
fi

log "=== Phase 3: remove Python/Node/Istio artifacts ==="
find "$ROOT" \( \
  -name node_modules -o \
  -name venv -o \
  -name .venv -o \
  -name .pytest_cache -o \
  -name __pycache__ -o \
  -name .mypy_cache -o \
  -name '*istio*' -o \
  -name istio \
\) -print -prune -exec rm -rf {} + 2>/dev/null || true

find "$ROOT" -type f \( -name '*.pyc' -o -name '*.pyo' \) -delete 2>/dev/null || true

log "=== Phase 4: Flutter clean ==="
if command -v flutter >/dev/null 2>&1; then
  (cd "$ROOT" && flutter clean) 2>/dev/null || true
fi

log "=== Cleanup complete ==="
