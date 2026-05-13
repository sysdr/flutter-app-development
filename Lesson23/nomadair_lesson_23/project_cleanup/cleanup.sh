#!/usr/bin/env bash
# Runs stop.sh, prunes unused Docker data, removes common local junk under this Flutter app only.
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "[cleanup] Project root: ${PROJECT_ROOT}"

echo "[cleanup] Running stop.sh..."
bash "${SCRIPT_DIR}/stop.sh" || true

echo "[cleanup] Docker — prune unused networks, stopped containers, dangling images..."
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker container prune -f >/dev/null 2>&1 || true
  docker image prune -a -f >/dev/null 2>&1 || true
  docker network prune -f >/dev/null 2>&1 || true
  docker builder prune -f >/dev/null 2>&1 || true
  docker system prune -f >/dev/null 2>&1 || true
else
  echo "[cleanup]   docker not available; skip Docker prune."
fi

echo "[cleanup] Project tree — remove node_modules, venv, .pytest_cache, __pycache__, *.pyc, *istio*..."
if command -v find >/dev/null 2>&1; then
  find "${PROJECT_ROOT}" \( -name node_modules -o -name venv -o -name .venv -o -name .pytest_cache -o -name __pycache__ \) -type d -prune 2>/dev/null | while read -r d; do
    rm -rf "$d" 2>/dev/null || true
  done
  find "${PROJECT_ROOT}" -name '*.pyc' -type f 2>/dev/null | while read -r f; do
    rm -f "$f" 2>/dev/null || true
  done
  find "${PROJECT_ROOT}" -iname '*istio*' 2>/dev/null | while read -r p; do
    rm -rf "$p" 2>/dev/null || true
  done
else
  echo "[cleanup]   find not available; skip filesystem sweep."
fi

echo "[cleanup] Done."
