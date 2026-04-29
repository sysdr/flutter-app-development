#!/usr/bin/env bash
set -euo pipefail

echo "[stop] stopping Flutter/emulator related processes"
for p in flutter dart adb emulator qemu-system-x86_64 java; do
  pkill -f "$p" 2>/dev/null || true
done

echo "[stop] stopping Docker containers (if docker is available)"
if command -v docker >/dev/null 2>&1; then
  docker ps -q | xargs -r docker stop || true
else
  echo "[stop] docker not found, skipping container stop"
fi

echo "[stop] done"
