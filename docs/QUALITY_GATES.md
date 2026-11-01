# 品質ゲート

強制状態の唯一の正本。`active` はこのリポジトリで実装と実行証拠があるもの、
`planned` は規範だが未強制、`review` は人・エージェントによる判断が必要なもの。

## 現在のゲート（文書初期化）

`make bootstrap` は Git / Python を確認し、`make check` は文書の必須ファイル・相対リンクと検査器の正例・反例を検証する。
文書検査だけで Swift 実装を合格にしないため、Swift ソースまたは manifest の追加を検出したら失敗する。
P0 でこの制限を**実際の製品ゲートに置き換える**。制限だけを削除しない。

| ID | 対象 | 状態 | 実体・証拠 |
| --- | --- | --- | --- |
| DOC-001 | 必須文書・相対ファイルリンクの存在 | active | eng/check_docs.py / eng/test_check_docs.py / [証拠](quality/gate-proofs.md) |
| DOC-002 | 文書だけのゲートで製品コードを通さない | active | 同上 |
| QLT-001 | ローカルと CI の入口は make check 一つ | review | Makefile / CI を変更時レビュー |
| QLT-002 | 未検証の規則を active と書かない | review | 検査・正例・反例・証拠を同じ変更に含める |
| QLT-003 | 閾値・除外・必須 check の弱体化は ADR / 期限付き waiver | review | 無関係な変更を通すための無効化は禁止 |
| ARC-001〜011 | 憲章の全規則 | planned | P0 で構造検査、P2 以降で振る舞い検査を追加 |
| SWF-001〜012 | Swift 規約の全規則 | planned | P0 でコンパイラ・formatter・lint・conformance を整備 |
| GIT-001〜004 | Issue / branch / commit / PR 規約 | planned | 初期はレビュー。フック・規則保護は未導入 |
| TEST-001 | 決定性、衝突、ダッシュ、復帰、終了、不変条件 | planned | P2 / P4 |
| TERM-001 | PTY で入力・復元・リサイズを検証 | planned | P3 |
| REL-001 | 配布物・checksum・インストール確認 | planned | P5 |

## P0 以降の make check

ツール版確認 → 文書・規約整合 → 検査器の正例・反例 → 整形 → lint →
debug / release build → Swift Testing → 実装段階に応じた再生・PTY 検査。
ローカルと CI は同じコマンド。ゲートはソースを書き換えない。

Swift / lint / CI ツールは版と取得元・checksum を固定する。兄弟の lock を未検証で流用しない。
製品コード追加と同じ PR でビルド・テストを有効にする。
ルールごとの active 化には、狙った違反が狙った規則で落ち、正例が通る証拠が必要。

## 実装時の受け入れ

- 物理: 高速ダッシュで床・壁・棘・角をすり抜けない。斜め移動・負座標・着地と回復の同 tick を検証。
- AI: 固定 seed 集合で到達率・終了率・tick 数・停滞回数を測る。成功だけに seed を選び直さない。
- 表示: 80×24、広い画面、狭い画面、resize、ASCII 枠の確認。演出が当たり判定を隠さない。
- 端末: q / EOF / SIGINT / SIGTERM / 初期化失敗で可能な限り復元。SIGKILL や端末切断まで復元保証と書かない。
- 記録: CPU・描画量・長時間走行は機材と条件を添える。未実測値を性能保証にしない。

現行 DOC-001 はリンク先ファイルの存在だけを検査する。URL 疎通・見出し anchor・内容の意味は検査しない。
