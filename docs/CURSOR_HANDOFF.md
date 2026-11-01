# Cursor への引き継ぎ

リポジトリのルートを Cursor で開く。最初は [AGENTS](../AGENTS.md)、
[現在地](todo/current.md)、この引き継ぎを読み、続ける正本は [作業別の索引](README.md) から開く。
常時ルールは `.cursor/rules/00-project.mdc` と `30-git.mdc`。
Swift 対象は `10-swift.mdc`、文書対象は `20-docs.mdc`。どれも入口であり、規範の全文は [作業別の正本](README.md) から開く。
ルールが添付されていても、リンク先を読んだことにはならない。

## 最初に貼り付ける指示

```text
NeNe Summit の P1 を開始してください。
まず AGENTS.md、docs/CURSOR_HANDOFF.md、docs/todo/current.md と、作業に必要な規範を読んでください。
P0 の道具は make check に接続済みです。Swift の版は .swift-version、判断は docs/adr/0003-measured-toolchain.md です。
.swift-format と .swiftlint.yml は緩めないでください。
docs/APPROACH.md の P1 を Issue とブランチに分けてください。
Core の Input / State / Event、一部屋、固定 tick を足し、同じ入力列が同じ状態列になること、
不正な部屋を結果型で拒むことを Swift Testing で確かめてください。
P1 の成功を、遊べるゲームや P2 以降の物理の証明と呼ばないでください。
Bolt / Swarm は設計の参考です。完成済みコード・テスト結果・施主の承認を丸ごとコピーしないでください。
要件の確定/初期方針/設計案/未決を区別し、細かな設計は根拠を記録して進めてください。
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
- 人の操作・テーマ数などが決まっていない: 要件表の候補。まず無入力で一部屋を登る最小構成を優先する。
- 兄弟をローカルで見つけられない: [REFERENCES](REFERENCES.md) の公開 commit を読む。
