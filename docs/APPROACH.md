# 実装アプローチ

まず「一部屋を AI が登って再挑戦する」縦切りを完成させ、その後に部屋と演出を増やす。
文書初期化完了はゲーム完成ではない。
人が一部屋を登るところまでは [現在地](todo/current.md) と [ADR 0005](adr/0005-playable-climb.md)。
無入力で登ってやり直すところは [ADR 0006](adr/0006-unattended-retry.md)。
押しっぱなしと同時押しは [ADR 0008](adr/0008-held-keys.md)。
オートとマニュアルの切替は [ADR 0009](adr/0009-attendance-toggle.md)。
ジャンプ中の左右は [ADR 0010](adr/0010-jump-steer.md)。
実機の入力記録は [ADR 0013](adr/0013-trace-debug.md)。
方向を押したジャンプの斜めは [ADR 0012](adr/0012-up-right-jump.md)。
次の部屋は [ADR 0014](adr/0014-next-room.md)。
画面の下のボヤキと、枠の外を消すことは [ADR 0015](adr/0015-mutter-strip.md)。
固定の色面と英語の四人は [ADR 0016](adr/0016-color-screen.md)。
先読みは [ADR 0017](adr/0017-lookahead.md)。
ばねと動く床は [ADR 0018](adr/0018-spring-and-deck.md)。
絵は足さずロジックだけ取り込むことは [ADR 0019](adr/0019-logic-not-pictures.md)。
壁に沿って上る井戸は [ADR 0020](adr/0020-wall-well.md)。
画面の刻みは [ADR 0021](adr/0021-steady-pace.md)。
低い隙間は [ADR 0022](adr/0022-low-slot.md)。
色面と右の欄は [ADR 0023](adr/0023-color-and-hud.md)。
画面の枠と奥行きと拾う光は [ADR 0024](adr/0024-depth-and-gleam.md)。
山の罫と拾うものは [ADR 0025](adr/0025-line-marks.md)。
雪山の雲と稜線は [ADR 0026](adr/0026-ice-vista.md)。
頂の旗一本は [ADR 0027](adr/0027-one-pennant.md)。
落ちる塊と崩れる床と結晶は [ADR 0028](adr/0028-falling-traps.md)。
雲の欠けと、大きな塊と、窓より広い部屋は [ADR 0029](adr/0029-flat-cloud-wide-fall.md)。
下の表は当初の区切りであり、P2 をゼロからやり直す指示ではない。

| Phase | 成果 | 受け入れ条件 |
| --- | --- | --- |
| P0: 道具と規約 | Swift 版を実測・固定、最小 SwiftPM、共通 make check、lint / 規約検査 | debug / release が通り、植えた違反が狙った検査で落ちる。文書のみ制限を製品ゲートへ置換。既存の `.swift-format` と `.swiftlint.yml` は緩めず、実測した版で接続してから SWF を active にする |
| P1: 状態と一部屋 | Core の Input / State / Event、部屋と初期位置、固定 tick | 同じ入力列で同じ状態列。不正な部屋を検証済み結果で拒む |
| P2: 移動と復帰 | 重力、走る、跳ぶ、壁蹴り、ダッシュ、棘、チェックポイント | 高速衝突・角・消費回復・死亡復帰の不変条件が通る。倍率・tick・速度を ADR に固定 |
| P3: 端末の縦切り | Render / Terminal / executable、簡易 AI、カメラ、HUD | 80×24 の一部屋を無入力で遊び、再挑戦する。q・割り込み・resize を PTY で確認 |
| P4: 自律登山 | 小部屋列、Core step を使う先読み、登頂・遠征終了、停滞対策 | 固定 seed 集合の到達率と長さを記録。AI が壁の前で永久停止しない |
| P5: 表現と配布準備 | 山の背景、残像、配色、候補機能の選別、Release 手順 | 実機で視認性確認。全 gate と配布物検証。公開操作はその時点の依頼範囲で実施 |

## 物理と AI

Core の衝突判定を微小ステップか swept 判定の一方式に統一する。最大速度と地形の最小厚みから方式を選ぶ。
8 方向ダッシュは整数の方向表を候補とし、斜めの距離と丸め誤差を測る。
失敗時に同じ部屋で無限に足踏みしないよう、試行数 / tick 上限から遠征終了へ遷移する。

AI は最初は小さな行動候補の評価でよい。登る高さだけでなく、着地の安全性・ダッシュ回復・次の足場への到達を評価する。
探索は複製した状態で Core の step を呼ぶ。学習サービス・外部 API・別物理モデルは入れない。
完璧な AI を作る前に部屋が到達可能かを固定入力リプレイで確認する。

## 引き継ぐものと新しく考えるもの

Bolt の端末入力・復元・セル描画・規約検査は参照候補。ファイル単位で目的・依存・テスト・出典を確認して移植する。
Swarm は固定刻みループ・自動プレイ循環・表示の参照。
射撃・敵・ボス・残機の前提を登山へ流し込まない。部屋設計・ダッシュ・壁蹴り・復帰は Summit 固有として設計する。

各 Phase は独立した Issue / PR に分ける。まとめて巨大実装にしない。
毎回 [current](todo/current.md) に実装済み・実行済み・未着手を分けて残す。
