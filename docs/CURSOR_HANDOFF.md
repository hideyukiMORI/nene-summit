# Cursor への引き継ぎ

リポジトリのルートを Cursor で開く。最初は [AGENTS](../AGENTS.md)、
[現在地](todo/current.md)、この引き継ぎを読み、続ける正本は [作業別の索引](README.md) から開く。
常時ルールは `.cursor/rules/00-project.mdc` と `30-git.mdc`。
Swift 対象は `10-swift.mdc`、文書対象は `20-docs.mdc`。どれも入口であり、規範の全文は [作業別の正本](README.md) から開く。
ルールが添付されていても、リンク先を読んだことにはならない。

## 最初に貼り付ける指示

```text
NeNe Summit は、端末で二部屋を人が登れ、キーを離すと案内が登り、頂上のあと次の部屋へ進むところまで入っています。
まず AGENTS.md、docs/CURSOR_HANDOFF.md、docs/todo/current.md と、作業に必要な規範を読んでください。
判断は docs/adr/0005-playable-climb.md と docs/adr/0006-unattended-retry.md です。
0004 の「位置を変えない」「初期の向きは上」は 0005 が置き換えています。
起動は swift run nene-summit。矢印か a d で移動、w と s、space で跳ぶ、k でダッシュ、q で終了です。
起動はオートです。m でマニュアルに切り替えます。オートでキーが無い tick は Guide が Input を返し、Watch が advance だけを呼びます。
マニュアルでは、キーが無くても Guide を呼びません。
方向を押したままのジャンプは docs/adr/0012-up-right-jump.md です。押しているあいだ斜め上へ進めてください。走る速さの空中は 0010 が置き換わっています。ジャンプキーはスペースのままです。
実機の入力は docs/adr/0013-trace-debug.md です。PlayTrace.debug が真のときだけ残します。いまは偽です。この記録のために物理を変えないでください。
頂上のあとの次の部屋は docs/adr/0014-next-room.md です。道は Trail だけが持ち、状態は advance だけが進めてください。案内の跳び方を部屋ごとに足さないでください。
ジャンプの高さは docs/adr/0007-shorter-jump.md です。全力でも体のおよそ 3 倍に収めてください。
押しっぱなしと同時押しは docs/adr/0008-held-keys.md です。固定 tick の残りで押したことにしないでください。
参照作品の部屋や絵や台詞を写さないでください。画面は docs/adr/0016-color-screen.md です。毎フレーム同じ大きさの色面にしてください。行はカーソル位置で書き、改行で送らないでください。一フレームは末尾まで書いてください。山に文字を置かず、題と右の状態と英語のボヤキとキーだけを書いてください。声は四人です。得点も配色の切替も足さないでください。
位置を変える経路を SummitState.advance 以外に足さないでください。数は MotionPolicy と Watch に置き、文書へ写さないでください。
数は設計判断であり、施主の確定要件ではありません。
.swift-format と .swiftlint.yml は緩めないでください。
先読みは docs/adr/0017-lookahead.md です。複製した状態へ advance し、本番の状態を消費しないでください。別の物理を足さないでください。
次はさらに先の部屋です。P2 をゼロからやり直さないでください。
復元とリサイズは未検査です。TERM-001 を active にしないでください。
Bolt / Swarm は設計の参考です。完成済みコード・テスト結果・施主の承認を丸ごとコピーしないでください。
終了時は実行した検証、未実装の検査、変更した文書、次の作業を日本語で報告し、docs/todo/current.md を更新してください。
```

## 新しいセッションで再開する

current の次の Phase と該当 Issue / PR を確認し、git status と差分を読む。
前のエージェントの「成功」だけを証拠にせず、必要な検査を手元で実行する。
失敗・未実行・環境不足を区別して記録する。実装途中の変更を消して最初から作り直さない。

## 最初のつまずき

- `make check` が swift を起動できない: `.swift-version` の版が PATH に要る。CI は `eng/install-swift.sh` が lock の tarball を入れる。
- `make check` がコミットメッセージで落ちる: GIT-003。新しいコミットには `(#N)` が要る。初期化コミットだけが例外。
- 整形を通すために `.swift-format` の `rules` を足したくなった: 足さない。既定規則のまま、コードを直す。
- どの SWF が機械で守られているか: [QUALITY_GATES](QUALITY_GATES.md)。設定ファイルがあることと active は別。
- テーマ数などが決まっていない: 要件表の候補。いま遊べるのは二部屋と一つの案内。
- 兄弟をローカルで見つけられない: [REFERENCES](REFERENCES.md) の公開 commit を読む。
