# NeNe Summit

AI が山を登り続ける、端末向けのアクション・スクリーンセーバー。

**端末で一部屋を登れます。インストーラと Release はまだありません。**

[English](README.md) · [ドキュメント一覧](docs/README.md) · [Cursor への引き継ぎ](docs/CURSOR_HANDOFF.md)

走る・跳ぶ・壁を蹴る・空中をダッシュする登山アクションを構想しています。
自動プレイを眺め、失敗したら短く再挑戦し、登頂したら次の登山へ。
独自の地形・キャラクター・演出で作ります。

[NeNe Bolt](https://github.com/hideyukiMORI/nene-bolt) と
[NeNe Swarm](https://github.com/hideyukiMORI/nene-swarm) の Swift / ANSI 端末構成と厳格な開発方針を参考にします。
確定した依頼と設計案の区別は [REQUIREMENTS.md](docs/REQUIREMENTS.md) が正本です。

## Cursor で始める

このリポジトリのルートを開き、[AGENTS.md](AGENTS.md) と
[CURSOR_HANDOFF.md](docs/CURSOR_HANDOFF.md) を読んでください。後者に貼り付け用の最初の指示があります。

```sh
make bootstrap
make check
swift run nene-summit
```

必要なのは Git・Make・Python 3.10 以降と、`.swift-version` の Swift です。
`make check` は文書、コミットメッセージ、規約、整形、lint、debug / release のビルドとテスト、
PTY での起動と `q` を実行します。整形と lint の設定は緩めません。

矢印か `a` / `d` で移動します。`w` と `s` は上下、`space` で跳び、`k` でダッシュ、`q` で終えます。
押しっぱなしは、離すまで移動が残ります。離したことが届かない端末では、キーのくり返しが続くあいだ残ります。
同時に押した移動とジャンプは、同じ瞬間の入力です。方向を押したままスペースを押すと、その方向へ跳べます。
ジャンプとダッシュは、押し始めだけ発火します。
起動したときはオートです。`m` でマニュアルに切り替えます。オートでキーを離すと案内が登り、頂上のあと、または打ち切りで同じ部屋をやり直します。
マニュアルでは、キーを離してもその場に留まります。
ジャンプは低めです。画面の下に、ダッシュの印とキーが出ます。
速さは `MotionPolicy`、間と打ち切りは `Watch` の設計判断です。

ライセンスは兄弟と同じ [MIT](LICENSE)。開発参加は [CONTRIBUTING.md](CONTRIBUTING.md)。
