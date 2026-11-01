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
速さなどの数は `MotionPolicy` の設計判断です。

ライセンスは兄弟と同じ [MIT](LICENSE)。開発参加は [CONTRIBUTING.md](CONTRIBUTING.md)。
