# ADR 0003 — ツールチェーンの版をこの環境の実測で固定する

Status: accepted
Date: 2026-11-01
Scope: 初期方針の技術判断。施主の確定要件ではない。

## 背景

P0 は、Swift の版をこの作業環境で測って固定し、既にある `.swift-format` と `.swiftlint.yml` を
緩めずに `make check` へ接続する。兄弟リポジトリの版と checksum は、こちらの実測ではない。

## 判断

コンパイラと swift-format の版の正本は [`.swift-version`](../../.swift-version)。
2026-11-01 に、この作業木の `swift --version` と `swift-format --version` はどちらも 6.4.1 だった。
ローカルの実体は swiftly の `swift-6.4.1-RELEASE`（x86_64-unknown-linux-gnu）。

CI が入れる tarball の正本は [`eng/swift.lock`](../../eng/swift.lock)。
配布は ubuntu24.04。SHA-256 は `7d246c7114077ad01dba4ad897628446ada4c489d6c7dbcf39ae3f25cbe17e8b`。
同じ日に `~/.cache/swift-toolchain/swift-6.4.1-RELEASE-ubuntu24.04.tar.gz` を `sha256sum` し、lock と一致した。
署名の検証はしていない。入れる手順は [`eng/install-swift.sh`](../../eng/install-swift.sh)。ローカルの `make check` はこのスクリプトを回さない。

SwiftLint の版と配布物の正本は [`eng/swiftlint.lock`](../../eng/swiftlint.lock)。
2026-11-01 に `.tools/swiftlint version` は 0.65.1 だった。実体は git に入れない。

`Package.swift` の tools-version は 6.2。これは manifest API の版で、コンパイルするツールチェーンは 6.4.1。
より古い tools-version へ落として、同じ API が通るかは確かめていない。

版のファイルとこの ADR が食い違ったら、ファイルを直し、同じ変更でこの ADR を更新する。

## 比較した案

兄弟の lock をそのまま使う案は採らない。この環境で取得していない checksum を正本にしない。
ツールチェーンを git に同梱する案は採らない。tarball は大きく、lock と取得手順で足りる。
swift-format の `rules` で既定規則を切る案は採らない。理由は [ADR 0002](0002-swift-strict-subset.md)。

## 影響と検証

`make check` は、この版の swift、swift-format、SwiftLint が無ければ成功しない。
CI は `eng/install-swift.sh` のあとで同じ `make check` を呼ぶ。
どの規則が `active` かは [QUALITY_GATES](../QUALITY_GATES.md) だけが言う。
