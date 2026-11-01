# 開発に参加する

最初に [AGENTS.md](AGENTS.md) と [開発手順](docs/DEVELOPMENT_WORKFLOW.md) を読む。
いまの到達点は [現在地](docs/todo/current.md)。

Git / Make / Python 3.10 以降に加え、[`.swift-version`](.swift-version) の Swift が要る。
`make bootstrap` と `make check` を実行する。`make check` は文書、コミットメッセージ、規約、整形、lint、
debug / release の build と Swift Testing、PTY での起動と `q` を実行する。
遊ぶときは `swift run nene-summit`。

Issue に目的・受け入れ条件・検証計画を記載し、焦点を一つにした PR を提出する。
ブランチとコミットの形は [コミット規約](docs/COMMIT_CONVENTIONS.md)、Swift の書き方は [コーディング規約](docs/CODING_RULES.md)。
規約変更には理由と ADR、振る舞い変更には必要なテストを添える。
相手の人格でなく変更内容を議論する。嫌がらせ・個人情報の掲載をしない。
第三者コード・素材の出典とライセンスを保持する。機密情報を添付しない。
