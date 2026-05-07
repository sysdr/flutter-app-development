#!/usr/bin/env bash
set -euo pipefail

echo "[stop] Stopping Flutter/Android/Docker related processes..."

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "\
\$names=@('flutter.exe','dart.exe','dartvm.exe','dartaotruntime.exe','gradle.exe','java.exe','adb.exe','emulator.exe','qemu-system-x86_64.exe','com.docker.backend.exe','com.docker.build.exe','docker-sandbox.exe','Docker Desktop.exe'); \
foreach(\$n in \$names){ taskkill /F /IM \$n 2>\$null | Out-Null }; \
Write-Output 'PROCESS_STOP_DONE'"

echo "[stop] Done."
