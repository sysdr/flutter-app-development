#!/usr/bin/env bash
set -eu

echo "[stop] stopping flutter/dart/python/node services..."
pkill -f "flutter run" || true
pkill -f "dart" || true
pkill -f "python" || true
pkill -f "node" || true

if command -v adb >/dev/null 2>&1; then
  echo "[stop] stopping emulator via adb..."
  adb emu kill || true
fi

echo "[stop] done."
