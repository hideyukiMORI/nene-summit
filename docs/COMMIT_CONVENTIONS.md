# コミットとリポジトリの規約

変更の経路は一つ。Issue → 焦点を一つにしたブランチ → 同じ形のコミット → PR → `make check` → squash merge → 同期した `main`。

形の正本はこの文書。強制できているかは [QUALITY_GATES](QUALITY_GATES.md) の同じ ID を見る。
兄弟の ruleset や「すでに active」という記録は、このリポジトリの強制状態ではない。

検証器は [`eng/validate-commit-message.py`](../eng/validate-commit-message.py)。
フックは [`.githooks/commit-msg`](../.githooks/commit-msg)。両方が同じ検証器を呼ぶ。

## GIT-001 — 変更は 1 つの Issue から始まる

Issue には問題と根拠、意図する結果、影響する規則 ID とモジュール、受け入れ条件、検証の計画、やらないことを書く。
読み取りだけの調査は Issue 無しでよい。親の無い初期化コミットだけが、Issue から始めない例外。

## GIT-002 — ブランチ名は一つの形

```text
<type>/<issue番号>-<short-kebab-summary>
```

例: `feat/2-fixed-tick-core`。`type` は GIT-003 と同じ集合。
初期化のあと、`main` で直接開発しない。force push と既定ブランチの削除を通常手順にしない。

## GIT-003 — コミットメッセージは一つの形

```text
<type>(<scope>): <日本語の説明> (#<issue番号>)
```

- `type` は `feat` / `fix` / `docs` / `refactor` / `test` / `build` / `ci` / `chore`
- `scope` は小文字・数字・ハイフン。省略できる。`feat():` や `feat(Core):` は不可
- `type`、`scope`、`BREAKING CHANGE` は英語。説明と本文は日本語
- 件名は 100 文字以内。末尾の `(#N)` は必須。件名と本文の間は空行
- 互換性を壊す公開の契約は `:` の前に `!` を付け、本文に `BREAKING CHANGE:` を書く
- 件名には作業の一覧ではなく、判断を置く。例: `警告のエラー化は manifest に置き、コマンド行には書かない`
- 親の無い初期化コミットだけ、`(#N)` を省いてよい。いまの初期化コミットがそれにあたる。新しいコミットには適用しない

`make bootstrap` は、このリポジトリだけの `core.hooksPath` を `.githooks` にする。グローバルの Git 設定は変えない。
フックは `--no-verify` で迂回できる。だから `make check` が同じ検証器で `$(BASE)..HEAD`（既定は `origin/main..HEAD`）を見る。
左端の ref が無いときだけ、`HEAD` から辿れる全履歴を見る。フックはフルゲートの代わりではない。

## GIT-004 — main へ入る変更は PR の squash merge

PR には目的、変更の要約、使った正典経路、規則 ID、検証結果、waiver、残るリスク、`Closes #N` を書く。
実装中とレビュー中は Draft。最終の HEAD に対する `make check` と CI のあとで Ready にする。
squash の件名は PR タイトルから作られる。

このリポジトリに、PR 必須や squash だけを機械で守る ruleset はまだ無い。手順として守り、兄弟の保護設定を導入済みと書かない。

## GIT-005 — PR タイトルは GIT-003 の件名と同じ形

マージ時の件名が最後の穴になる。PR タイトルを GIT-003 の件名に揃える。`(#N)` を忘れない。

## 導入

```bash
make bootstrap
```

コミット前に検証器へメッセージを渡してもよい。

```bash
python3 eng/validate-commit-message.py --file .git/COMMIT_EDITMSG
```
