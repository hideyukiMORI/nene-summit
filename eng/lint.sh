#!/bin/bash
# SwiftLint。有効にした規則が黙って飛ばされたら失敗にする。
set -euo pipefail
cd "$(dirname "$0")/.."
swiftlint="$1"
shift
mapfile -d '' files < <(eng/swift-sources.sh)
output="$("$swiftlint" lint --strict --quiet --no-cache "$@" "${files[@]}" 2>&1)" || status=$?
status="${status:-0}"
if [ -n "$output" ]; then
    printf '%s\n' "$output"
fi
if grep -q 'Skipping enabled rule' <<<"$output"; then
    echo "lint: 有効にした規則が実行されていない" >&2
    exit 1
fi
exit "$status"
