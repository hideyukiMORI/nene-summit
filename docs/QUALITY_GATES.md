# 品質ゲート

強制状態の唯一の正本。`active` はこのリポジトリで実装と実行証拠があるもの、
`planned` は規範だが未強制、`review` は人・エージェントによる判断が必要なもの。

## 現在のゲート

`make bootstrap` は Git / Python を確認し、このリポジトリだけの `core.hooksPath` を `.githooks` にする。
続けて、[`.swift-version`](../.swift-version) と同じ Swift と swift-format、[`eng/swiftlint.lock`](../eng/swiftlint.lock) どおりの SwiftLint を確かめる。
`make check` はコミットメッセージ、必須文書と相対リンク、検査器の正例と反例、字句の規約検査、整形、lint、
debug / release の build、Swift Testing を実行する。

文書検査は、Swift ソースを追加してもそれだけでは失敗しない。
以前の DOC-002 は、文書だけの成功で製品コードを通さないための拒否だった。
その拒否は外し、同じ `make check` の整形、lint、conformance、build、test へ置き換えた。

| ID | 対象 | 状態 | 実体・証拠 |
| --- | --- | --- | --- |
| DOC-001 | 必須文書・相対ファイルリンクの存在 | active | eng/check_docs.py / eng/test_check_docs.py / [証拠](quality/gate-proofs.md) |
| QLT-001 | ローカルと CI の入口は make check 一つ | review | Makefile / CI を変更時レビュー |
| QLT-002 | 未検証の規則を active と書かない | review | 検査・正例・反例・証拠を同じ変更に含める |
| QLT-003 | 閾値・除外・必須 check の弱体化は ADR / 期限付き waiver | review | 機械側は CNF-008 と CNF-009 |
| ARC-001〜011 | 憲章の全規則 | planned | 構造検査は未実装。振る舞い検査は P2 以降 |
| 整形 | `swift-format lint --strict` | active | `.swift-format` / eng/test_tool_rules.py の長行と製品ソース / [証拠](quality/gate-proofs.md) |
| SWF-002 の fallthrough | `fallthrough` を書かない | active | `.swiftlint.yml` の `fallthrough` / eng/test_tool_rules.py |
| SWF-004 | 強制アンラップ、暗黙アンラップ、Optional の Bool とコレクション、`as!`、`try!` | active | `.swiftlint.yml` の対応する only_rules / eng/test_tool_rules.py |
| SWF-005 | 製品コードの `throw` / `throws` / `try` / `catch` | active | eng/conformance.py の CNF-003 / eng/test_conformance.py |
| SWF-006 | `Any` 系と、3 要素以上のタプル | active | CNF-006 と `.swiftlint.yml` の `large_tuple` |
| SWF-009 | 列挙した unsafe は Terminal 以外で拒否 | active | CNF-012。植えた語は `unsafeBitCast` |
| SWF-010 | 禁止する型名の語尾 | active | CNF-001 |
| SWF-011 | 最上位の型は 1 つ。ファイル名と一致 | active | CNF-002 |
| SWF-012 | 複雑度、長さ、入れ子、引数の数 | active | `.swiftlint.yml` の対応する only_rules / eng/test_tool_rules.py |
| SWF-013 | `async` / `await` / `actor` / `Task` | active | CNF-005。植えた語は `async` |
| SWF-014 | Foundation 系の import | active | CNF-004。植えたのは `import Foundation` |
| SWF-015 | 抑制は行単位かつ waiver 付き。範囲と `all` は拒否 | active | CNF-007 と `superfluous_disable_command` と `blanket_disable_command` |
| SWF-016 | XCTest を import しない | active | CNF-004。植えたのは `import XCTest` |
| CNF-008 / CNF-009 | 整形の余分な鍵と、lint の除外・一括有効化を拒む | active | eng/test_conformance.py |
| コンパイラ | Swift 6、警告のエラー化、ExistentialAny、本ビルド | active | Package.swift / CNF-010 / 未使用の `let` が `swift build` で落ちる / Makefile の build と test |
| SWF-001 | 単位と不変条件は専用の型 | review | 機械検査は未実装 |
| SWF-002 の網羅 | 全捕捉を書かない | review | `fallthrough` 以外は未実装 |
| SWF-003 | 公開状態は不変 | review | `public var` と `open` は CNF-011。それ以外は未実装 |
| SWF-007 | 構築は唯一のファクトリ | review | 機械検査は未実装 |
| SWF-008 | `fileprivate` より `private` | review | 植えた違反は無い |
| SWF-017 | 制御のネストと bool の切替引数 | review | 機械検査は未実装 |
| SWF-018 | 公開 API でクラスを返さない | review | `open class` は CNF-011。戻り値の class は未検査 |
| GIT-001 | Issue から始める | planned | 初期化と読み取り調査だけ例外。本文検査は未導入 |
| GIT-002 | ブランチ名 | planned | 名前の検査と main 保護は未導入 |
| GIT-003 | コミットメッセージの形 | active | eng/validate-commit-message.py / eng/test_validate_commit_message.py / .githooks/commit-msg / [証拠](quality/gate-proofs.md) |
| GIT-004 | PR と squash merge | planned | 手順として守る。ruleset は未導入。兄弟の保護設定を転記しない |
| GIT-005 | PR タイトル | planned | 人が GIT-003 に揃える。タイトル検査は未導入 |
| TEST-001 | 決定性、衝突、ダッシュ、復帰、終了、不変条件 | planned | P2 / P4 |
| TERM-001 | PTY で入力・復元・リサイズを検証 | planned | P3 |
| REL-001 | 配布物・checksum・インストール確認 | planned | P5 |

## make check の中身

ツール版の確認 → コミットメッセージ → 文書と相対リンク → 検査器の正例と反例 → conformance → 整形 → lint →
debug / release build → Swift Testing。
再生と PTY は、その段階の実装と同じ変更で足す。
ローカルと CI は同じ `make check`。CI はその前に [`eng/install-swift.sh`](../eng/install-swift.sh) で lock のツールチェーンを入れる。
ゲートはソースを書き換えない。

版と checksum の正本は [ADR 0003](adr/0003-measured-toolchain.md)。兄弟の lock を未検証で流用しない。
`.swift-format` と `.swiftlint.yml` の中身を緩めて通さない。
ルールを active にするには、狙った違反が狙った検査で落ち、正例が通る証拠が要る。
製品コードを足す変更は、同じ変更で build と test を通す。

## 実装時の受け入れ

- 物理: 高速ダッシュで床・壁・棘・角をすり抜けない。斜め移動・負座標・着地と回復の同 tick を検証。
- AI: 固定 seed 集合で到達率・終了率・tick 数・停滞回数を測る。成功だけに seed を選び直さない。
- 表示: 80×24、広い画面、狭い画面、resize、ASCII 枠の確認。演出が当たり判定を隠さない。
- 端末: q / EOF / SIGINT / SIGTERM / 初期化失敗で可能な限り復元。SIGKILL や端末切断まで復元保証と書かない。
- 記録: CPU・描画量・長時間走行は機材と条件を添える。未実測値を性能保証にしない。

現行 DOC-001 はリンク先ファイルの存在だけを検査する。URL 疎通・見出し anchor・内容の意味は検査しない。
