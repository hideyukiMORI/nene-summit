# Architecture Decision Records

| ADR | 状態 | 判断 |
| --- | --- | --- |
| [0001](0001-documentation-first.md) | accepted | 兄弟の原則を採用し、文書初期化と製品実装を分ける |
| [0002](0002-swift-strict-subset.md) | accepted | Swift の記述・整形・lint の正本と、コミットメッセージ検査を固定する |
| [0003](0003-measured-toolchain.md) | accepted | Swift 6.4.1 と SwiftLint 0.65.1 をこの環境の実測で固定する |
| [0004](0004-one-room-step.md) | accepted | 一部屋の状態は固定 tick の advance だけが進める。位置と初期の向きは 0005 が置き換えた |
| [0005](0005-playable-climb.md) | accepted | 端末から一部屋を登り切る。数値は MotionPolicy の設計判断 |
| [0006](0006-unattended-retry.md) | accepted | 無入力では案内が登り、頂上か打ち切りで同じ部屋をやり直す。跳び方は 0007 が置き換えた |
| [0007](0007-shorter-jump.md) | accepted | ジャンプを体のおよそ 3 倍に抑え、一部屋の読みと画面下の案内にする |
| [0008](0008-held-keys.md) | accepted | 押しっぱなしと同時押しは、端末が届ける押す・離すか文字のくり返しで受ける |
| [0009](0009-attendance-toggle.md) | accepted | `m` でオートとマニュアルを切り替える。マニュアルは案内を呼ばない |
| [0010](0010-jump-steer.md) | accepted | 方向を押したジャンプは走る速さで跳び、空中の左右もその速さへ届く |
| [0011](0011-input-trace.md) | accepted | 実機の入力と速度は、起動のたびにローカルファイルへ残す |

[テンプレート](0000-template.md) を複製し、連番と内容を表す名前を付ける。
状態: proposed / accepted / superseded。accepted は記録した技術判断の採用であり、施主の発言を意味しない。
残る判断は、複数の部屋、先読み、テーマ、配布。
