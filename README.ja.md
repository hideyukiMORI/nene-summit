# NeNe Summit

AI が山を登り続ける、端末向けのアクション・スクリーンセーバー。

**現在はドキュメント初期化段階です。ゲーム本体・インストーラ・Release はまだありません。**

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
```

必要なのは Git・Make・Python 3.10 以降です。現時点の検査範囲は文書と文書検査器だけです。
Swift の版固定・ビルド・ゲームのテストは最初の実装マイルストーンで整備します。

ライセンスは兄弟と同じ [MIT](LICENSE)。開発参加は [CONTRIBUTING.md](CONTRIBUTING.md)。
