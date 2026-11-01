#!/bin/bash
# CI に .swift-version の Swift を、eng/swift.lock の tarball から入れる。
# ローカルは swiftly の同じ版を使い、このスクリプトは回さない。
set -euo pipefail
cd "$(dirname "$0")/.."

version="$(tr -d '[:space:]' < .swift-version)"
read -r _ platform sha < <(grep -E "^${version//./\\.} " eng/swift.lock)
if [ -z "${sha:-}" ]; then
    echo "install-swift: eng/swift.lock に ${version} の行が無い" >&2
    exit 1
fi
dir_platform="${platform//./}"
name="swift-${version}-RELEASE-${platform}"
url="https://download.swift.org/swift-${version}-release/${dir_platform}/swift-${version}-RELEASE/${name}.tar.gz"
cache="${HOME}/.cache/swift-toolchain"
mkdir -p "$cache"
if [ ! -f "$cache/${name}.tar.gz" ]; then
    curl -fL --retry 3 -o "$cache/${name}.tar.gz.part" "$url"
    mv "$cache/${name}.tar.gz.part" "$cache/${name}.tar.gz"
fi
echo "${sha}  $cache/${name}.tar.gz" | sha256sum --check --quiet

if [ "$(id -u)" -eq 0 ]; then
    apt-get update -qq
    apt-get install -y -qq binutils git unzip gnupg2 libc6-dev libcurl4-openssl-dev libedit2 \
        libgcc-13-dev libpython3-dev libsqlite3-0 libstdc++-13-dev libxml2-dev libncurses-dev \
        libz3-dev pkg-config tzdata zlib1g-dev > /dev/null
else
    sudo apt-get update -qq
    sudo apt-get install -y -qq binutils git unzip gnupg2 libc6-dev libcurl4-openssl-dev libedit2 \
        libgcc-13-dev libpython3-dev libsqlite3-0 libstdc++-13-dev libxml2-dev libncurses-dev \
        libz3-dev pkg-config tzdata zlib1g-dev > /dev/null
fi

prefix="${HOME}/swift-toolchain"
rm -rf "$prefix"
mkdir -p "$prefix"
tar -xzf "$cache/${name}.tar.gz" -C "$prefix" --strip-components=1
if [ -n "${GITHUB_PATH:-}" ]; then
    echo "${prefix}/usr/bin" >> "$GITHUB_PATH"
fi
"${prefix}/usr/bin/swift" --version
