#!/bin/bash
set -euo pipefail

DOCKER_CONTAINER_NAME="travel_app_day3_container"

if command -v docker &>/dev/null; then
  docker stop "$DOCKER_CONTAINER_NAME" >/dev/null 2>&1 || true
  docker rm "$DOCKER_CONTAINER_NAME" >/dev/null 2>&1 || true
fi

pkill -f "flutter.*run.*travel_app_day3" 2>/dev/null || true

echo "Stopped Docker container (if any) and travel_app_day3 flutter run processes."
