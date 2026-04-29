#!/usr/bin/env bash
set -euo pipefail

echo "[cleanup] stopping Flutter/emulator/docker related processes"
for p in flutter dart adb emulator qemu-system-x86_64 java; do
  pkill -f "$p" 2>/dev/null || true
done

echo "[cleanup] stopping Docker containers (if docker is available)"
if command -v docker >/dev/null 2>&1; then
  docker ps -q | xargs -r docker stop || true
  docker container prune -f || true
  docker image prune -af || true
  docker volume prune -f || true
  docker network prune -f || true
else
  echo "[cleanup] docker not found, skipping docker cleanup"
fi

echo "[cleanup] removing local caches/artifacts"
rm -rf node_modules venv .venv .pytest_cache
find . -type d \( -name node_modules -o -name venv -o -name .venv -o -name .pytest_cache \) -prune -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
find . -iname "*istio*" -exec rm -rf {} + 2>/dev/null || true

echo "[cleanup] done"
