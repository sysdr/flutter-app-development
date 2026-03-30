#!/bin/bash
set -euo pipefail

export FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/development/flutter}"
FLUTTER_BIN="$FLUTTER_ROOT/bin/flutter"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Script may live in lesson2/ or lesson2/travel_app/
if [[ -f "$SCRIPT_DIR/pubspec.yaml" ]]; then
  APP_DIR="$SCRIPT_DIR"
  LESSON_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
  APP_DIR="$SCRIPT_DIR/travel_app"
  LESSON_ROOT="$SCRIPT_DIR"

if [[ ! -x "$FLUTTER_BIN" ]]; then
  echo "🚨 Flutter SDK not found or not executable: $FLUTTER_BIN"
  echo "   Set FLUTTER_ROOT or install: https://docs.flutter.dev/get-started/install/linux"
  exit 1
fi
export PATH="$FLUTTER_ROOT/bin:$PATH"

if [[ ! -d "$APP_DIR" ]]; then
  echo "🚨 Missing Flutter app at $APP_DIR — run setup first:"
  echo "   bash $LESSON_ROOT/setup.sh"
  exit 1
fi

if [[ ! -f "$APP_DIR/pubspec.yaml" ]]; then
  echo "🚨 Invalid app (no pubspec.yaml): $APP_DIR"
  exit 1
fi

# Warn if another flutter run for this project may already be active
if pgrep -af "flutter.*run" | grep -q "travel_app"; then
  echo "⚠️  Another Flutter run involving travel_app may already be running:"
  pgrep -af "flutter" || true
  echo "   Stop duplicate instances (Ctrl+C in those terminals) to avoid port/device conflicts."
fi

cd "$APP_DIR"
exec "$FLUTTER_BIN" run "$@"
