# Cursor への引き継ぎ

リポジトリのルートを Cursor で開く。最初は [AGENTS](../AGENTS.md)、
[現在地](todo/current.md)、[要件](REQUIREMENTS.md)、[アプローチ](APPROACH.md) を読む。
短い常時ルールを `.cursor/rules/00-project.mdc`、Swift 対象を `10-swift.mdc` に配置している。
ルールが添付されていても、リンク先を読んだことにはならない。

## 最初に貼り付ける指示

```text
NeNe Summit の実装を開始してください。
まず AGENTS.md、docs/CURSOR_HANDOFF.md、docs/todo/current.md と指定された規範を読んでください。
このリポジトリは文書初期化だけが完了しています。make check は文書検査だけです。
docs/APPROACH.md の P0 に対応する Issue とブランチから着手し、P0 の成果を一つの PR にまとめてください。
Swift の版を実測して固定し、最小 SwiftPM 構成、debug/release build、Swift Testing、整形、lint、
規約検査とその正例・反例をローカルと CI の make check に整えてください。
現在の Swift コード検出による制限は、実際の製品ゲートへ置き換えてください。
Bolt / Swarm は設計の参考です。完成済みコード・テスト結果・施主の承認を丸ごとコピーしないでください。
要件の確定/初期方針/設計案/未決を区別し、細かな設計は根拠を記録して進めてください。
P0 完了時は実行した検証、未実装の検査、変更した文書、次の作業を日本語で報告してください。
その後は同じ原則で P1〜P5 を一段階ずつ進められるよう、docs/todo/current.md を更新してください。
```

## 新しいセッションで再開する

current の次の Phase と該当 Issue / PR を確認し、git status と差分を読む。
前のエージェントの「成功」だけを証拠にせず、必要な検査を手元で実行する。
失敗・未実行・環境不足を区別して記録する。実装途中の変更を消して最初から作り直さない。

## 最初のつまずき

- `make check` が Swift ファイルを拒む: 初期の文書専用ゲート。P0 で製品用ゲートに移行する必要がある。
- Swift の版が書かれていない: 意図的。兄弟の版を候補にしても、このプロジェクトで確認して固定する。
- 人の操作・テーマ数などが決まっていない: 要件表の候補。まず無入力で一部屋を登る最小構成を優先する。
- 兄弟をローカルで見つけられない: [REFERENCES](REFERENCES.md) の公開 commit を読む。
