#!/usr/bin/env bash
set -euo pipefail
TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_SOURCE="$(cd "${1:?Usage: verify-preview.sh THEME_DIRECTORY [PORT] [THEME_ID]}" && pwd)"
PREVIEW_PORT="${2:-17081}"
THEME_ID="${3:-$(basename "$THEME_SOURCE")}"
EVIDENCE="$TOOLKIT_ROOT/target/preview-check/$THEME_ID"
mkdir -p "$EVIDENCE"
PREVIEW_PID=''
stop_preview() {
    if [[ -n "$PREVIEW_PID" ]]; then
        kill "$PREVIEW_PID" 2>/dev/null || true
        wait "$PREVIEW_PID" 2>/dev/null || true
        PREVIEW_PID=''
    fi
}
trap stop_preview EXIT INT TERM
check_preview() {
    local source="$1" mode="$2"
    "$TOOLKIT_ROOT/bin/theme" preview "$source" --id "$THEME_ID" --port "$PREVIEW_PORT" > "$EVIDENCE/$mode.log" 2>&1 &
    PREVIEW_PID=$!
    local ready=false
    for attempt in {1..45}; do
        if ! kill -0 "$PREVIEW_PID" 2>/dev/null; then
            cat "$EVIDENCE/$mode.log" >&2
            return 1
        fi
        if curl --noproxy '*' --fail --silent --max-time 2 "http://127.0.0.1:$PREVIEW_PORT/" >/dev/null; then
            ready=true
            break
        fi
        sleep 1
    done
    if [[ "$ready" != true ]]; then
        cat "$EVIDENCE/$mode.log" >&2
        return 1
    fi
    "$TOOLKIT_ROOT/bin/theme" smoke --base-url "http://127.0.0.1:$PREVIEW_PORT" > "$EVIDENCE/$mode.json"
    stop_preview
}
"$TOOLKIT_ROOT/bin/theme" check "$THEME_SOURCE"
check_preview "$THEME_SOURCE" directory
"$TOOLKIT_ROOT/bin/theme" package "$THEME_SOURCE" --output "$EVIDENCE/$THEME_ID.zip"
check_preview "$EVIDENCE/$THEME_ID.zip" zip
echo "Directory and installed ZIP verified: $EVIDENCE"
