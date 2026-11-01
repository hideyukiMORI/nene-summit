# 現在地

更新: 2026-11-01。

## 完了

- リポジトリ初期化用の規範・要件・設計案・アプローチ・ポリシーを整備。
- Cursor ルール、AGENTS の読み順、貼り付け用指示を用意。
- Swift の記述・整形・lint の正本を CODING_RULES / `.swift-format` / `.swiftlint.yml` に固定。
- コミットメッセージの形を検証器、フック、make check で検査する。文書の入口を作業別索引に寄せた。
- P0 の道具。Swift の版は `.swift-version`、判断は [ADR 0003](../adr/0003-measured-toolchain.md)。
  最小 target は NeNeSummitCore。`make check` は文書、GIT-003、conformance、整形、lint、
  debug / release build、Swift Testing を実行する。
- 文書検査が Swift ソースを拒む制限は外し、同じ `make check` の製品ゲートへ置き換えた。
- P1 の一部屋。判断は [ADR 0004](../adr/0004-one-room-step.md)。
  `RoomId` と `Room` が不正な部屋を拒み、`SummitState.advance` が tick を 1 進める。
  同じ入力列は `Replay.states` で同じ状態列になる。位置は初期位置のまま。

実行の成否は [gate-proofs](../quality/gate-proofs.md)。

## 未着手

P2〜P5。重力、走る、跳ぶ、壁蹴り、ダッシュ、棘、チェックポイント、端末、自律登山、配布。
target 同士の依存グラフを表と照合する検査。
tick と秒の対応、固定小数点の倍率。

## 次の作業

[APPROACH](../APPROACH.md) の P2。
受け入れ条件: 高速衝突、角、消費と回復、死亡復帰の不変条件。倍率・tick・速度は ADR に固定する。
P2 の成功を、端末で遊べることや AI の証明と呼ばない。

レビューのままの SWF は [QUALITY_GATES](../QUALITY_GATES.md)。機械検査が無いものを active にしない。
