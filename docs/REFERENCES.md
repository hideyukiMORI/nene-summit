# 参照と採否

初期整備時に参照した公開リポジトリのローカル checkout（2026-11-01）。

| 参照 | 読んだ snapshot | 採用する考え方 |
| --- | --- | --- |
| [NeNe Bolt](https://github.com/hideyukiMORI/nene-bolt/tree/072d08af76a0f2045612c2e25b248df9b9496188) | 072d08af76a0f2045612c2e25b248df9b9496188 | 純粋 Core、AI と人の同じ入力、固定小数点、端末境界、文書とゲート |
| [NeNe Swarm](https://github.com/hideyukiMORI/nene-swarm/tree/33034861b846cf74528e87902358fd4b2cc88d2b) | 33034861b846cf74528e87902358fd4b2cc88d2b | 自動プレイ循環、同期ループ、厳格な規約体系 |

参照文書: AGENTS、CLAUDE、REQUIREMENTS、ARCHITECTURE_CONSTITUTION、PROJECT_LAYOUT、CODING_RULES、
QUALITY_GATES、DEVELOPMENT_WORKFLOW、COMMIT_CONVENTIONS と ADR / waiver / PR の構成。
文書は Summit 向けに再構成。MIT LICENSE は同一著作権者の兄弟と揃えた。
製品コード・画像・ゲート実装は移植していない。

2026-11-01 に、同じ 2 つの snapshot から追加で読んだもの:
`docs/CODING_RULES.md`、`docs/COMMIT_CONVENTIONS.md`、`.swiftlint.yml`、`.swift-format`、
`eng/validate-commit-message.py`、`.githooks/commit-msg`。
採用したのは記述の部分集合（SWF-001〜018）、整形ファイルの鍵、lint の `only_rules` と閾値、GIT-001〜005 の形。
メッセージ検証器は Summit で書き、親の無い初期化コミットの `(#N)` 省略だけを例外にした。
兄弟の `active`、実測ケース、ruleset、ツールの版、conformance 検査の実装は写していない。

引き継がないもの: 射撃・ボス・残機・得点の確定仕様、キャストや台詞の本数、実測結果、active の強制状態、
Release 済みという記録、過去セッションの承認、自動マージの権限。
Swift の具体版と lint の lock も未固定。P0 でこの環境の debug / release 動作を検証してから決める。

Cursor の入口は [.mdc ルールの公式資料](https://cursor.com/docs/rules) を確認し、
常時適用の短いルールと Swift 対象のルールから正本文書へ誘導する。
ルールファイルはエージェント向けの指示であり、機械的な品質ゲートの代わりではない。
