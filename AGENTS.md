# NeNe Summit — Agent Guide

Cursor を含む全エージェント共通の入口。規範の正本は `docs/`。説明・報告は日本語、識別子は英語。

## 最初に読む順序

1. [現在地](docs/todo/current.md) と [Cursor 引き継ぎ](docs/CURSOR_HANDOFF.md)
2. [要件・決定の状態](docs/REQUIREMENTS.md)
3. [アーキテクチャ憲章](docs/ARCHITECTURE_CONSTITUTION.md) と [構成](docs/PROJECT_LAYOUT.md)
4. [コーディング規約](docs/CODING_RULES.md) と [品質ゲート](docs/QUALITY_GATES.md)
5. [開発手順](docs/DEVELOPMENT_WORKFLOW.md) と [コミット規約](docs/COMMIT_CONVENTIONS.md)
6. [実装アプローチ](docs/APPROACH.md)、該当 [ADR](docs/adr/README.md)、[waiver](docs/waivers/README.md)

## 常に守ること

- 一つの意味には一つの正典経路。AI 用の別物理・状態の直接書き換えを作らない。
- Core は整数の固定刻みで進む純粋な状態遷移。時計・環境・外部乱数源は合成ルートだけ。
- 外部ゲームエンジンを追加しない。Swift / SwiftPM、製品の外部パッケージなしを初期方針とする。
- ゲートを弱めて通さない。`planned` を実装・正例・反例の証拠なしに `active` にしない。
- 兄弟のテスト結果・承認・Release 状態を本プロジェクトの事実としてコピーしない。
- 提案を施主の確定要件と書かない。作業依頼の範囲で進め、細かな設計判断は理由を記録する。
- 元作品の名前・キャラクター・ステージ・アセットを製品へ持ち込まない。独自に作る。
- 実行していない検証を成功と報告しない。現在の `make check` は文書検査だけ。
- 認証情報・ローカル会話ログ・個人パスをコミットしない。

現在は文書初期化段階。ゲーム実装に着手するときは P0 から開始し、Swift ソースを足す変更で製品用ゲートも整える。
兄弟の規約に書かれた自動マージ・Release 公開の許可を、このリポジトリの許可と解釈しない。

完了報告: 対象 Issue / 規則 ID、変更した振る舞い、実行した検証と結果、文書変更、waiver、残る課題。
