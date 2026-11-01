# コミット・ブランチ規約

| ID | 規範 |
| --- | --- |
| GIT-001 | 変更は一つの Issue から始める。初期化コミットと読み取り調査は例外 |
| GIT-002 | ブランチは `<type>/<issue番号>-<short-kebab-summary>`。初期化後は main で直接開発しない |
| GIT-003 | コミットは `<type>(<scope>): <日本語の説明> (#N)`。scope は省略可、件名 100 文字以内 |
| GIT-004 | 初期化後は Draft PR → 最終 HEAD の make check / CI → Ready → squash merge |

type: feat / fix / docs / refactor / test / build / ci / chore。
例: `feat/1-fixed-tick-core`、`feat(core): 登山状態を固定刻みで進める (#1)`。
初期化コミットだけは Issue 末尾を省略できる。PR タイトルもコミットと同じ形式。
互換性を壊すときは `!` と `BREAKING CHANGE:` に理由を書く。
force push・既定ブランチ削除を通常手順にしない。

フック・コミット検査・branch protection は未導入。書いてあることと機械強制を混同しない。
P0 で兄弟のフックと検査を検討し、実装してから [QUALITY_GATES](QUALITY_GATES.md) を更新する。
