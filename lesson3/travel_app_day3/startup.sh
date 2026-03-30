#!/bin/bash
set -euo pipefail

export FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/development/flutter}"
FLUTTER_BIN="$FLUTTER_ROOT/bin/flutter"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/pubspec.yaml" ]]; then
  APP_DIR="$SCRIPT_DIR"
  LESSON_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
  APP_DIR="$SCRIPT_DIR/travel_app_day3"
  LESSON_ROOT="$SCRIPT_DIR"
fi

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

if pgrep -af "flutter" 2>/dev/null | grep -q "travel_app_day3.*run"; then
  echo "⚠️  Another Flutter run for travel_app_day3 may already be active:"
  pgrep -af "flutter" || true
  STOP_HINT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/stop.sh"
  echo "   Stop duplicates with: bash $STOP_HINT"
fi

cd "$APP_DIR"
exec "$FLUTTER_BIN" run -d web-server --web-hostname 0.0.0.0 --web-port 8080 "$@"
