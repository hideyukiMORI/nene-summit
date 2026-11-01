#!/bin/bash
# swift build / swift test の出力に警告が残ったら失敗にする。
set -euo pipefail
cd "$(dirname "$0")/.."
log="$(mktemp)"
trap 'rm -f "$log"' EXIT
status=0
"$@" 2>&1 | tee "$log" || status=$?
if [ "$status" -ne 0 ]; then
    exit "$status"
fi
if grep -E '(^|: )warning: ' "$log" > /dev/null; then
    echo "swift-strict: 警告が残っている" >&2
    exit 1
fi
