#!/bin/bash
# 整形と lint の対象になる Swift ファイルを NUL 区切りで出す。
set -euo pipefail
cd "$(dirname "$0")/.."
git ls-files -z --cached --others --exclude-standard -- '*.swift' | sort -zu | while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
        printf '%s\0' "$file"
    fi
done
