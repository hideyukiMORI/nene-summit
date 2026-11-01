# 現在地

更新: 2026-11-01。

## 完了

- リポジトリ初期化用の規範・要件・設計案・アプローチ・ポリシーを整備。
- Cursor ルール、AGENTS の読み順、貼り付け用指示を用意。
- Swift の記述・整形・lint の正本を CODING_RULES / `.swift-format` / `.swiftlint.yml` に固定。
- コミットメッセージの形を検証器、フック、make check で検査する。文書の入口を作業別索引に寄せた。
- P0 の道具。Swift の版は `.swift-version`、判断は [ADR 0003](../adr/0003-measured-toolchain.md)。
  `make check` は文書、GIT-003、conformance、整形、lint、debug / release build、Swift Testing、
  PTY での起動と `q` を実行する。
- 文書検査が Swift ソースを拒む制限は外し、同じ `make check` の製品ゲートへ置き換えた。
- P1 の一部屋。判断は [ADR 0004](../adr/0004-one-room-step.md)。
  `RoomId` と `Room` が不正な部屋を拒み、`SummitState.advance` が tick を 1 進める。
  同じ入力列は `Replay.states` で同じ状態列になる。
- 人が一部屋を遊ぶ。判断は [ADR 0005](../adr/0005-playable-climb.md)。
  走る、跳ぶ、壁蹴り、ダッシュ、棘、チェックポイント、登頂、`q` で終了。
  数は `MotionPolicy` の設計判断であり、施主の確定要件ではない。
  起動は `swift run nene-summit`。矢印か a d、w と s、space、k、q。
- 無入力の案内。判断は [ADR 0006](../adr/0006-unattended-retry.md)。
  キーが無い tick は右へ跳ぶ案内が `advance` だけを呼ぶ。
  頂上のあと、または打ち切りで、同じ部屋を最初からやり直す。
  人の入力がある tick は人が勝つ。間と打ち切りは `Watch` の設計判断。
- 短いジャンプと、一部屋の読み、画面下の案内。判断は [ADR 0007](../adr/0007-shorter-jump.md)。
  全力のジャンプは体のおよそ 3 倍。数は `MotionPolicy`。参照作品の地形は写していない。
  部屋は、チェックポイント、棘、ジャンプでは越せない隙間、短い階段、頂上の順。
  画面の下に題、ダッシュの印、キーの一行。
- 押しっぱなしと同時押し。判断は [ADR 0008](../adr/0008-held-keys.md)。
  離すまで移動が残り、1 回の読みの複数キーは一つの `Input`。
  ジャンプとダッシュは押し始めだけ。ジャンプを離すと、上がっている速度を一度短くする。
  窓の長さは `HeldPresses`、短縮は `MotionPolicy`。施主の実測ではない。
- オートとマニュアルの切替。判断は [ADR 0009](../adr/0009-attendance-toggle.md)。
  起動はオート。`m` の押し始めだけで切り替える。マニュアルでは、キーが無くても案内を呼ばない。
  モードは `Input` に入れない。

実行の成否は [gate-proofs](../quality/gate-proofs.md)。

## 未着手

複数の部屋、移動する床、先読み、カメラ、テーマ、リサイズと終了後の復元の検査、配布。
target 同士の依存グラフを表と照合する検査。
いまの案内は、この一部屋の隙間と階段を進む。別の部屋を解く保証はない。
TERM-001 は起動と `q` だけを見ていて、planned のまま。

## 次の作業

部屋を足すか、`advance` の複製で先読みする。新しい物理経路を足さない。
`.swift-format` と `.swiftlint.yml` は緩めない。
レビューのままの SWF は [QUALITY_GATES](../QUALITY_GATES.md)。機械検査が無いものを active にしない。
