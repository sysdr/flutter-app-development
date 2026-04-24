#!/usr/bin/env bash

# Root-level entrypoint for cleanup.
# Delegates to scripts/cleanup.sh to keep cleanup logic in one place.
bash "$(dirname "$0")/scripts/cleanup.sh"
