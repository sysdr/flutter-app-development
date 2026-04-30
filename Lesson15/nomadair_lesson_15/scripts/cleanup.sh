#!/usr/bin/env bash
# Stop services, prune Docker, clean Python caches and Flutter/Android build
# caches under this app only.
# Run from Git Bash (Windows), WSL, macOS, or Linux.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "[cleanup.sh] App folder: ${APP_ROOT}"

if [[ -f "${SCRIPT_DIR}/stop.sh" ]]; then
  bash "${SCRIPT_DIR}/stop.sh" || true
fi

echo "[cleanup.sh] Pruning unused Docker resources..."
if command -v docker >/dev/null 2>&1; then
  docker container prune -f 2>/dev/null || true
  docker image prune -f 2>/dev/null || true
  docker builder prune -f 2>/dev/null || true
  docker network prune -f 2>/dev/null || true
  docker system prune -f 2>/dev/null || true
else
  echo "[cleanup.sh] docker not found; skipping Docker steps."
fi

echo "[cleanup.sh] Removing Python caches under app folder (${APP_ROOT})..."
find "${APP_ROOT}" -type d \( \
  -name '__pycache__' -o -name '.pytest_cache' -o -name 'node_modules' -o -name 'venv' -o -name '.venv' \
\) 2>/dev/null | while IFS= read -r d; do
  [[ -z "${d}" ]] && continue
  echo "[cleanup.sh]   rm -rf ${d}"
  rm -rf "${d}"
done

find "${APP_ROOT}" -type f -name '*.pyc' -delete 2>/dev/null || true

echo "[cleanup.sh] Removing Istio-named YAML under app folder..."
find "${APP_ROOT}" -type f \( \
  -iname '*istio*.yaml' -o -iname '*istio*.yml' \
  -o -iname '*virtualservice*.yaml' -o -iname '*virtualservice*.yml' \
  -o -iname '*destinationrule*.yaml' -o -iname '*destinationrule*.yml' \
\) 2>/dev/null | while IFS= read -r f; do
  [[ -z "${f}" ]] && continue
  echo "[cleanup.sh]   rm ${f}"
  rm -f "${f}"
done

find "${APP_ROOT}" -type d -name 'istio' 2>/dev/null | while IFS= read -r d; do
  [[ -z "${d}" ]] && continue
  echo "[cleanup.sh]   rm -rf ${d}"
  rm -rf "${d}"
done

echo "[cleanup.sh] Removing Flutter/Android caches under app (${APP_ROOT})..."
for d in \
  "${APP_ROOT}/build" \
  "${APP_ROOT}/.dart_tool" \
  "${APP_ROOT}/coverage" \
  "${APP_ROOT}/.pub" \
  "${APP_ROOT}/android/.gradle" \
  "${APP_ROOT}/android/app/build" \
  "${APP_ROOT}/android/build" \
  "${APP_ROOT}/ios/Pods" \
  "${APP_ROOT}/ios/.symlinks" \
  "${APP_ROOT}/packages/core/.dart_tool" \
  "${APP_ROOT}/packages/core/build" \
  "${APP_ROOT}/packages/ui/.dart_tool" \
  "${APP_ROOT}/packages/ui/build"
do
  if [[ -e "${d}" ]]; then
    echo "[cleanup.sh]   rm -rf ${d}"
    rm -rf "${d}"
  fi
done

rm -f "${APP_ROOT}/android/local.properties" 2>/dev/null || true

echo "[cleanup.sh] Done. Next: flutter pub get && flutter run"
