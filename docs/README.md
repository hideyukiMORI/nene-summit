# ドキュメント案内

初期化日: 2026-11-01。日本語が規範の正本。README の紹介と食い違う場合は、この索引から辿る規範を優先し、両方を直す。

ファイルは移動しない。作業ごとに開く正本は一つ。Cursor ルールは入口だけで、本文を複製しない。
`active` / `planned` / `review` を書く場所は [QUALITY_GATES](QUALITY_GATES.md) だけ。

## Cursor の読み順

1. [AGENTS](../AGENTS.md)、[現在地](todo/current.md)、[引き継ぎ](CURSOR_HANDOFF.md)
2. 下の表で、今回の作業の行だけを開く
3. 強制できているかは [QUALITY_GATES](QUALITY_GATES.md) を見る

## 作業別の正本

| 作業 | 開く正本 | Cursor ルール |
| --- | --- | --- |
| 方針が確定か提案か | [REQUIREMENTS](REQUIREMENTS.md) | `00-project` |
| 状態と依存の境界 | [ARCHITECTURE_CONSTITUTION](ARCHITECTURE_CONSTITUTION.md)、[PROJECT_LAYOUT](PROJECT_LAYOUT.md)、[ADR](adr/README.md) | `10-swift` |
| Swift を書く、整形、lint | [CODING_RULES](CODING_RULES.md)、[`../.swift-format`](../.swift-format)、[`../.swiftlint.yml`](../.swiftlint.yml) | `10-swift` |
| ゲートを変える | [QUALITY_GATES](QUALITY_GATES.md)、[証拠](quality/gate-proofs.md) | `20-docs` |
| コミット、ブランチ、PR | [COMMIT_CONVENTIONS](COMMIT_CONVENTIONS.md) | `30-git` |
| 手順と実装順 | [DEVELOPMENT_WORKFLOW](DEVELOPMENT_WORKFLOW.md)、[APPROACH](APPROACH.md)、[現在地](todo/current.md) | `00-project` |
| 表現、通信、出典 | [ASSET_POLICY](ASSET_POLICY.md)、[PRIVACY](PRIVACY.md)、[REFERENCES](REFERENCES.md) | `20-docs` |
| 期限付きの例外 | [Waivers](waivers/README.md) | `10-swift` |

## ファイル一覧

| 文書 | 役割 |
| --- | --- |
| [CURSOR_HANDOFF](CURSOR_HANDOFF.md) | 最初に渡す指示、再開方法、つまずき |
| [REQUIREMENTS](REQUIREMENTS.md) | 確定依頼、初期方針、設計案、未決 |
| [APPROACH](APPROACH.md) | 実装順序と受け入れ条件 |
| [ARCHITECTURE_CONSTITUTION](ARCHITECTURE_CONSTITUTION.md) | 状態、境界、正典経路 |
| [PROJECT_LAYOUT](PROJECT_LAYOUT.md) | 予定 target と依存方向 |
| [CODING_RULES](CODING_RULES.md) | Swift で書いてよい形。ID は SWF-001〜018 |
| [QUALITY_GATES](QUALITY_GATES.md) | 強制状態の唯一の正本 |
| [DEVELOPMENT_WORKFLOW](DEVELOPMENT_WORKFLOW.md) | Issue から PR までの進め方 |
| [COMMIT_CONVENTIONS](COMMIT_CONVENTIONS.md) | ブランチ、コミット、PR の形。ID は GIT-001〜005 |
| [GLOSSARY](GLOSSARY.md) | 用語 |
| [ASSET_POLICY](ASSET_POLICY.md) | 独自表現と出典 |
| [PRIVACY](PRIVACY.md) | 通信と保存 |
| [REFERENCES](REFERENCES.md) | 参照した兄弟と、写さなかったもの |
| [ADR](adr/README.md) | 長期的な設計判断 |
| [Waivers](waivers/README.md) | 期限付き例外 |
| [Gate proofs](quality/gate-proofs.md) | 検査の証拠 |
| [Current](todo/current.md) | 現在地と次の作業 |

ライセンス、参加、セキュリティは [LICENSE](../LICENSE)、[CONTRIBUTING](../CONTRIBUTING.md)、[SECURITY](../SECURITY.md)。
