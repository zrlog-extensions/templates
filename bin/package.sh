#!/usr/bin/env bash
set -euo pipefail
TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec "$TOOLKIT_ROOT/bin/theme" build "${1:?Usage: package.sh THEME_REPOSITORY [OUTPUT_DIRECTORY]}" --output-dir "${2:-dist}"
