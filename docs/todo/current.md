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

実行の成否は [gate-proofs](../quality/gate-proofs.md)。この一覧は、コマンドが何を見るかを書く。

## 未着手

P1〜P5。Core の状態遷移、一部屋、物理、端末、自律登山、配布。
target 同士の依存グラフを表と照合する検査。
Issue、作業ブランチ、PR。この変更はまだコミットしていない。

## 次の作業

[APPROACH](../APPROACH.md) の P1。
受け入れ条件: Core の Input / State / Event、部屋と初期位置、固定 tick。
同じ入力列で同じ状態列。不正な部屋は検証済みの結果型で拒む。
P1 の成功を、遊べるゲームや P2 の物理の証明と呼ばない。

レビューのままの SWF は [QUALITY_GATES](../QUALITY_GATES.md)。機械検査が無いものを active にしない。
