# Architecture Decision Records

| ADR | 状態 | 判断 |
| --- | --- | --- |
| [0001](0001-documentation-first.md) | accepted | 兄弟の原則を採用し、文書初期化と製品実装を分ける |
| [0002](0002-swift-strict-subset.md) | accepted | Swift の記述・整形・lint の正本と、コミットメッセージ検査を固定する |
| [0003](0003-measured-toolchain.md) | accepted | Swift 6.4.1 と SwiftLint 0.65.1 をこの環境の実測で固定する |
| [0004](0004-one-room-step.md) | accepted | 一部屋の状態は固定 tick の advance だけが進める |

[テンプレート](0000-template.md) を複製し、連番と内容を表す名前を付ける。
状態: proposed / accepted / superseded。accepted は記録した技術判断の採用であり、施主の発言を意味しない。
P0 のツール版・ゲート、P2 の物理、P3 の端末、P4 の AI と終了条件、P5 の配布で順に追加する。
