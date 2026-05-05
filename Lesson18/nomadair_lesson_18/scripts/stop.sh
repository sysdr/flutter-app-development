#!/usr/bin/env bash
set -euo pipefail

echo "[stop] stopping emulator and local services..."

if command -v adb >/dev/null 2>&1; then
  adb emu kill >/dev/null 2>&1 || true
fi

# Stop common local processes if present.
pkill -f "flutter" || true
pkill -f "dart" || true
pkill -f "qemu-system" || true
pkill -f "emulator" || true
pkill -f "node" || true
pkill -f "python" || true

echo "[stop] done."

