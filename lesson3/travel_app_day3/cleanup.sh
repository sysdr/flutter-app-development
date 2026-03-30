#!/usr/bin/env bash
# Convenience wrapper so you can run from inside the app folder.
#
# Run: bash cleanup.sh

set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$APP_DIR/../.." && pwd)"

bash "$REPO_ROOT/cleanup.sh"

