#!/usr/bin/env bash
set -euo pipefail

echo "[stop] stopping flutter/emulator related processes..."
for proc in flutter dart dartvm dartaotruntime adb emulator qemu-system-x86_64; do
  if command -v pkill >/dev/null 2>&1; then
    pkill -f "$proc" >/dev/null 2>&1 || true
  fi
done

echo "[stop] stopping running docker containers..."
if command -v docker >/dev/null 2>&1; then
  ids="$(docker ps -q 2>/dev/null || true)"
  if [ -n "${ids}" ]; then
    docker stop ${ids} >/dev/null 2>&1 || true
  fi
else
  echo "[stop] docker not found, skipping container stop."
fi

echo "[stop] done."
