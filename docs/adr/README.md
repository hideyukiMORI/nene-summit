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
| [0011](0011-input-trace.md) | accepted | 実機の入力と速度はローカルファイルへ残せる。いつもの起動で書くことは 0013 が置き換えた |
| [0012](0012-up-right-jump.md) | accepted | 方向を押したジャンプは、押し続けているあいだ斜め上へ進む |
| [0013](0013-trace-debug.md) | accepted | 入力記録は `PlayTrace.debug` が真のときだけ書く。いまは偽 |
| [0014](0014-next-room.md) | accepted | 頂上のあと、道の次の部屋から進む。打ち切りは同じ部屋のまま |
| [0015](0015-mutter-strip.md) | accepted | 枠の外は毎フレーム消す。帯の位置と一人の日本語は 0016 が置き換えた |
| [0016](0016-color-screen.md) | accepted | 画面は固定の色面。英語の四人が順に話す |
| [0017](0017-lookahead.md) | accepted | 案内は advance の複製で短く先を見る。本番の状態は消費しない |
| [0018](0018-spring-and-deck.md) | accepted | ばねと動く床は advance の中で動き、道に三部屋足す |
| [0019](0019-logic-not-pictures.md) | accepted | 絵やアスキーアートは足さず、仕組みのロジックだけ取り込む |
| [0020](0020-wall-well.md) | accepted | 壁に沿って上る井戸を、上の床のあとに足す |
| [0021](0021-steady-pace.md) | accepted | 画面の刻みは枠の残りだけ待つ。描画は間引かない |
| [0022](0022-low-slot.md) | accepted | 低い隙間はダッシュで越す。井戸のあとに足す |
| [0023](0023-color-and-hud.md) | accepted | 色面を整え、右の欄を段で組む。箱線も得点も足さない |
| [0024](0024-depth-and-gleam.md) | accepted | 画面に枠と奥行きと、拾う光を足す。山の字形は 0025 |
| [0025](0025-line-marks.md) | accepted | 山は罫で描き、拾うものに字形を付ける。雪山の絵は 0026 |
| [0026](0026-ice-vista.md) | accepted | 奥は雲と稜線、手前は雪。旗一本は 0027 |
| [0027](0027-one-pennant.md) | accepted | 頂は一本の旗、奥の雲は輪郭 |
| [0028](0028-falling-traps.md) | accepted | 落ちる塊と崩れる床と結晶を足す |
| [0029](0029-flat-cloud-wide-fall.md) | accepted | 雲は平たい欠け、落ちる塊は大きく、その部屋は窓より広い |
| [0030](0030-locked-screen-lead.md) | accepted | 窓に収まる部屋はカメラを止め、広い部屋は先を見せる |
| [0031](0031-pillar-frames.md) | accepted | 部屋は高さの違う柱と、枠の一枚にする |
| [0032](0032-crumble-bridge.md) | accepted | 崩れる床は二つの岸のあいだの橋 |
| [0033](0033-screen-exits.md) | superseded | 途中の部屋の印は 0034 が置き換えた |
| [0034](0034-edge-rooms.md) | accepted | 端の開口を越えると隣の画面へ入る。旗は最後だけ。井戸の上抜けは 0035 |
| [0035](0035-required-gates.md) | accepted | 井戸は壁を蹴って右の端へ出る。道の上に崩れる橋を置く。橋のあとの右並びは 0036 |
| [0036](0036-folded-road.md) | accepted | 橋のあと、道は上、左、下、昇る塊、空中のダッシュで折れる。最初からの組み直しは 0037 |
| [0037](0037-rebuilt-road.md) | accepted | 道を最初から組み直し、空中でもう一度跳ぶ。画面は帯で組む。欄の分割は 0038 |
| [0038](0038-linked-rooms.md) | accepted | 右は一つの枠。出た側の反対から入る。右へ続く道は 0039 |
| [0039](0039-folded-summit.md) | accepted | 道は上下左右に折れる。旗は下から登った先 |
| [0040](0040-falling-entry.md) | accepted | 落ちた次は上から空中に入り、落ち続ける |

[テンプレート](0000-template.md) を複製し、連番と内容を表す名前を付ける。
状態: proposed / accepted / superseded。accepted は記録した技術判断の採用であり、施主の発言を意味しない。
残る判断は、さらに先の部屋、テーマ、配布。
