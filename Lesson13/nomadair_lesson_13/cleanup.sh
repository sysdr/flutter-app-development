#!/usr/bin/env bash
set -euo pipefail

echo "[cleanup] stopping flutter/emulator related processes..."
for proc in flutter dart dartvm dartaotruntime adb emulator qemu-system-x86_64; do
  if command -v pkill >/dev/null 2>&1; then
    pkill -f "$proc" >/dev/null 2>&1 || true
  fi
done

echo "[cleanup] stopping docker containers..."
if command -v docker >/dev/null 2>&1; then
  ids="$(docker ps -aq 2>/dev/null || true)"
  if [ -n "${ids}" ]; then
    docker stop ${ids} >/dev/null 2>&1 || true
    docker rm ${ids} >/dev/null 2>&1 || true
  fi

  echo "[cleanup] pruning unused docker resources..."
  docker system prune -af --volumes >/dev/null 2>&1 || true
else
  echo "[cleanup] docker not found, skipping docker cleanup."
fi

echo "[cleanup] done."
