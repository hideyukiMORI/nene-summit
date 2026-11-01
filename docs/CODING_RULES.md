# Swift コーディング規約

兄弟から採用した規範の要約。強制状態は [QUALITY_GATES](QUALITY_GATES.md) が正本。
兄弟でのコンパイラ実測を本リポジトリの実測として扱わない。

| ID | 規範 |
| --- | --- |
| SWF-001 | 座標・速度・tick・seed・部屋 ID は単位と不変条件を持つ専用の値型にする |
| SWF-002 | 閉じた選択肢は enum と網羅的 switch。default、@unknown default、全捕捉パターン、fallthrough を使わない。整数・文字列の判別は if か検証済み enum |
| SWF-003 | 公開格納状態は let / private(set)。open、公開可変参照、汎用 Any データバッグを使わない |
| SWF-004 | nil は省略可能な値の不在だけ。強制アンラップ・暗黙アンラップ・as!・try! を使わない |
| SWF-005 | 不変条件を持つ型の init は private、検証を唯一のファクトリへ。extension の init と Codable による迂回を作らない |
| SWF-006 | 製品で throw / throws / try / catch を使わず、期待される失敗を結果 enum で返す。Testing の #require などテスト側の throws は可 |
| SWF-007 | 可視性は最小。1 ファイル 1 主要型、ファイル名を型名に合わせる。Manager / Helper / Utils の寄せ集めを作らない |
| SWF-008 | async / await / Task / actor / スレッド / Dispatch / @preconcurrency を使わない。unsafe は Terminal 境界だけ |
| SWF-009 | 各 target で警告エラー化と ExistentialAny を固定。Swift 6 言語モード。正確な manifest API と版は P0 で実測する |
| SWF-010 | Swift Testing のみ。XCTest を混在させない。時刻・外部乱数禁止はテストにも適用し、明示 seed を使う |
| SWF-011 | swift-format の設定は一つ。SwiftLint は only_rules で選ぶ。指摘・skip・warning を成功扱いしない |
| SWF-012 | baseline・無期限の除外を作らない。抑制が必要なら規則 ID・狭い範囲・期限付き waiver を先に記録する |

初期上限: 循環的複雑度 10、関数 60 行、ファイル 400 行（コメントのみの行を除く）、型 300 行、引数 4。
P0 で各ツールの実際の計測方法を確認する。単に通すための分割や閾値変更はしない。
閉じた enum の if/else 化、値型の意味、適切な可視性はレビュー対象でもある。

整数の除算・負座標の丸め・斜めダッシュ速度・積算時の overflow 方針を一つに固定し、境界値を検証する。
座標倍率やダッシュの具体値をこの文書に複製せず、物理 ADR を正本とする。
