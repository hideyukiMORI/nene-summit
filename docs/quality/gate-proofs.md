# ゲートの証拠

兄弟の実測を転載しない。成否は、このリポジトリで実行したコマンドだけを書く。

## 文書

正例と反例は `eng/test_check_docs.py`。

| ID | ケース | 期待 |
| --- | --- | --- |
| DOC-001 | 必須ファイルと有効な相対リンク | 成功 |
| DOC-001 | AGENTS.md の削除 | DOC-001 で失敗 |
| DOC-001 | 存在しない相対リンク | DOC-001 で失敗 |
| DOC-001 | リポジトリ外への相対リンク | DOC-001 で失敗 |
| 文書検査 | Sources に Swift を追加 | 成功。拒否は製品ゲートが持つ |

## コミットメッセージ

正例と反例は `eng/test_validate_commit_message.py`。

| ID | ケース | 期待 |
| --- | --- | --- |
| GIT-003 | 正準の件名、scope なし、初期化コミットの `(#N)` 省略、`BREAKING CHANGE` の対 | 成功 |
| GIT-003 | Issue 番号なし、未知の type、大文字 scope、英語の説明、101 文字超、空行なし、`!` だけでフッタなし | 失敗 |
| GIT-003 | 同期した main の `origin/main..HEAD` | 対象 0 件で成功。初期化コミットは範囲の外 |
| GIT-003 | 親の無い初期化コミットを含む `HEAD` | `(#N)` 省略を許して成功 |

## 字句の規約

正例と反例は `eng/test_conformance.py`。

| ID | ケース | 期待 |
| --- | --- | --- |
| conformance | 最小の struct、整形設定、lint 設定、manifest | 0 件 |
| CNF-001 | 型名の禁止語尾 | 失敗 |
| CNF-002 | 最上位の型が 2 つ | 失敗 |
| CNF-003 | 製品コードの `throws`。テスト側の `throws` は成功 | 製品だけ失敗 |
| CNF-004 | `import Foundation` と `import XCTest`。コメント内の import は成功 | import だけ失敗 |
| CNF-005 | `async` | 失敗 |
| CNF-006 | `Any` | 失敗 |
| CNF-007 | waiver の無い `swiftlint:disable:next` | 失敗 |
| CNF-008 | `.swift-format` の `rules` | 失敗 |
| CNF-009 | `.swiftlint.yml` の `excluded` | 失敗 |
| CNF-010 | ExistentialAny の無い manifest | 失敗 |
| CNF-011 | `public var` | 失敗 |
| CNF-012 | Terminal 以外の `unsafeBitCast` | 失敗 |

## 整形、lint、警告のエラー化

正例と反例は `eng/test_tool_rules.py`。道具が無いときは失敗する。

| ケース | 期待 |
| --- | --- |
| 短い struct を、リポジトリの `.swiftlint.yml` で lint | 成功。Skipping enabled rule は出ない |
| `only_rules` の各規則に、その名前を含む違反を 1 つ植える | その規則名で失敗 |
| 130 文字を超える行を swift-format に渡す | 失敗 |
| 製品の Swift ソースを swift-format に渡す | 成功 |
| 未使用の `let` を、製品と同じ manifest 設定で `swift build` | 失敗。使用する関数だけにすると成功 |

## 実行記録

2026-11-01、この作業木で `make check` は成功した。

- `eng/install-tools.sh` は、既にある `.tools/swiftlint` 0.65.1 をそのまま使った。
- `origin/main..HEAD` のコミットは 0 件、違反 0。
- `python3 -m unittest discover -s eng -p 'test_*.py' -v` は 35 件成功。
- `python3 eng/check_docs.py` は成功。`python3 eng/conformance.py` は 0 件。
- `swift-format lint --strict` は製品の Swift ソースに違反 0。
- SwiftLint は違反 0。`Skipping enabled rule` は出ていない。
- `swift build` と `swift build -c release` は成功。警告は残っていない。
- `swift test` と `swift test -c release` は、Swift Testing の 2 件がどちらも成功。
  その前に XCTest の空スイートが 0 件で表示される。製品もテストも `import XCTest` はしていない。空スイートを消す設定は入れていない。

同じ日に、`swift --version` と `swift-format --version` は 6.4.1、`.tools/swiftlint version` は 0.65.1。
`~/.cache/swift-toolchain/swift-6.4.1-RELEASE-ubuntu24.04.tar.gz` の SHA-256 は `eng/swift.lock` と一致した。
CI の `eng/install-swift.sh` はこの作業木では実行していない。GitHub Actions も実行していない。
ゲームの再生、PTY、物理の不変条件は未実行。
