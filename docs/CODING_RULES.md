# Swift コーディング規約

規範。ここが沈黙している領域は Swift の公式標準に従う。
本書は Swift 6 言語モードと警告のエラー化の上で、許す書き方をさらに一つに狭める。

強制できているかは [QUALITY_GATES](QUALITY_GATES.md) だけが言う。
兄弟の実測番号や `active` は、このリポジトリの証拠として書かない。
閾値の数値は [`.swiftlint.yml`](../.swiftlint.yml) だけが持つ。
整形の鍵は [`.swift-format`](../.swift-format) だけが持つ。文書へ数値を複製しない。

判断の採用は [ADR 0002](adr/0002-swift-strict-subset.md)。
ツールの版は [ADR 0003](adr/0003-measured-toolchain.md)。

## 正本の置き場

| 意味 | 正本 |
| --- | --- |
| 記述してよい形 | この文書 |
| インデント・行長・swift-format の既定規則 | `.swift-format`。鍵は `version` / `indentation` / `lineLength` だけ。`rules` で規則を切らない |
| 名指しする lint と閾値 | `.swiftlint.yml` の `only_rules`。`strict: true`。baseline・除外・一括有効化は置かない |
| 抑制の台帳 | [waivers](waivers/README.md) |

`make check` がこの 2 つの設定ファイルを実行する。中身を緩めて通さない。

## 1. 型と状態

### SWF-001 — 単位と不変条件は専用の型

座標（整数固定小数点）・速度・tick・seed・部屋 ID・ダッシュ残数のように単位や不変条件を持つ値は専用の型にする。
生の `Int` や `String` を深いところまで運ばない。検証は生成時に行う。文字列キーの辞書で型を代用しない。

強制はレビュー。型を作ったあとの検証経路は SWF-007。

### SWF-002 — 閉じた選択肢は enum。全捕捉で網羅性を殺さない

部屋の種類、足場、失敗理由、登山の局面、ダッシュの向き、入力の意図、テーマのように閉じた選択肢は `enum` で表す。
boolean の組み合わせ、マジック整数、裸の文字列で表さない。

`switch` に全捕捉を書かない。全捕捉とは、必ず一致するパターンを含む `case` である。
`default:`、`@unknown default`、`case _:`、`case let x:`、`case var x:`、`case (let x):`、`case .a, _:`、
全位置が `_` か束縛だけのタプル（`case (_, _):`、`case let (x, y):`）を含む。
`fallthrough` も使わない。整数や文字列の判別は `if` か、検証済みの enum にしてから `switch` する。

閉じた enum を `==` と `else` で分岐すると網羅性が無くなる。分岐は `switch` で書く。この部分はレビュー。
タプルの一部の位置の `_`（`case (.up, _):`）と、`where` の付いた `case` は全捕捉ではない。

### SWF-003 — 公開状態は不変

公開する格納プロパティは `let` か `private(set) var`。`public var` の格納プロパティと `open` を使わない。
公開型は値の意味を持つ `struct` / `enum` に寄せる。クラスの公開は SWF-018。

### SWF-004 — nil の意味は一つ

`nil` が意味してよいのは「省略可能な値が無い」だけ。無効、未読込、失敗、未知を表さない。
強制アンラップ `!`、暗黙アンラップ `T!`、`as!`、Optional の `Bool`、Optional のコレクションを書かない。

### SWF-005 — 期待される失敗は結果の enum

検証エラー、読めない起動引数、読めない保存は閉じた結果型で返す。
製品コードに `throws` / `throw` / `try` / `catch` / `try!` を書かない。
プログラム上の欠陥は `precondition` / `fatalError` で止める。
Swift Testing の `#require` など、テスト側が要る `throws` は製品の禁止の外。

### SWF-006 — 汎用データバッグを使わない

`Any` / `AnyObject` / `AnyHashable` / `AnyClass` と、3 要素以上のタプルで型を代用しない。名前付きの型を作る。

### SWF-007 — 構築は唯一のファクトリ

不変条件を持つ型は `init` を `private` にし、結果型を返す `static func` を唯一の生成経路にする。
明示 `init` の無い struct は同一モジュールの他ファイルから memberwise init で作れるので、不変条件を持つ型には必ず `private init` を書く。
`init` は型の本体にだけ書く。`extension` に書かない。
`Codable` / `Decodable` / `Encodable` を使わない。合成された `init(from:)` がファクトリを迂回する。

`private init` の書き忘れ自体はレビュー。extension の init と `Codable` は、P0 の規約検査で拒否する対象にする。

## 2. 可視性とファイル

### SWF-008 — 可視性は最小

既定は `internal` 以下。他の target が実際に使うものだけ `public`。テストのためだけに `public` にしない。`@testable import` を使う。
`fileprivate` より `private`。ファイル直下の `fileprivate` は swift-format の `FileScopedDeclarationPrivacy` に任せる。SwiftLint 側へ同じ規則を重ねない。

### SWF-009 — 言語マジックは Terminal 境界だけ

`unsafeBitCast`、`Unsafe*Pointer`、`withUnsafe*`、`Unmanaged`、`@unchecked Sendable`、`nonisolated(unsafe)` は、
termios / ioctl のために依存グラフで `unsafe=allowed` と宣言した `NeNeSummitTerminal` だけで使える。
`Mirror`、下線付き属性 `@_…`、`@preconcurrency`、`@dynamicMemberLookup`、`@dynamicCallable`、マクロ、`dlopen`、`@objc`、SwiftPM のビルドプラグインは使わない。使うなら ADR。

### SWF-010 — 名前が役割を語る

型名の語尾に `Manager` / `Helper` / `Util` / `Utils` / `Common` を使わない。
ディレクトリと target に `utils` / `helpers` / `managers` / `misc` / `common` を使わない。

使ってよい役割の語尾は `Port` / `Adapter` / `Query` / `Command` / `Handler` / `Policy` / `Factory` / `Codec` / `Mapper` / `Renderer` / `Reducer` / `Outcome` / `Rejection`。
その型がその役割そのものであるときだけ使う。

### SWF-011 — 1 ファイル 1 主要型

ファイルの最上位の型（`class` / `struct` / `enum` / `protocol` / `actor`）は 1 つ。ファイル名は型名と一致させる。
拡張だけのファイルは `型名+役割.swift`。寄せ集めのファイルを作らない。

### SWF-012 — 複雑度の上限

循環的複雑度、関数の長さ、型と関数の入れ子、引数の数、ファイルの長さ、型の長さ。
数値、`case` を数えること、既定引数を数えること、コメントだけの行の扱いは `.swiftlint.yml` が正本。
`strict: true` なので warning も失敗である。指摘、skip、warning を成功扱いにしない。

閾値を満たすためだけに意味のある処理を割らない。超える必要があるときは測定できる理由を添えて ADR にする。

### SWF-017 — 制御のネストと bool の切替引数

`if` / `for` / `while` / `switch` / `guard` のネストは 4 段まで。
公開 API の関数に、振る舞いを切り替えるための `Bool` 引数を置かない。閉じた enum にする。

この 2 つはレビュー。字句で波括弧を数える検査はクロージャと区別できないので採用しない。

### SWF-018 — 公開 API でクラスを返さない

クラス参照の中身は `let` で持っても変更できる。公開 API が返す型、受け取る型は `struct` / `enum` にする。

## 3. 実行時

### SWF-013 — 並行性の形は一つ

合成ルートの 1 本の同期ループだけが入力と締め切りを待つ。
どの target でも `async` / `await` / `Task` / `actor` / スレッド / Dispatch を使わない。
Core、Engine、Render は同期的な純粋関数だけ。

### SWF-014 — 時計と文字の持ち主は一つ

Foundation も FoundationEssentials も import しない。ロケール依存の整形をしない。
時計、環境、外部乱数は合成ルートだけ。文字は `String` / `Character` で扱い、端末へ出す UTF-8 は Terminal だけ。
登山者、足場、棘、HUD のセルの寸法と幅の前提は Render の 1 か所で決め、見た目の数値は ADR に書く。この文書へ複製しない。

### SWF-015 — 抑制は例外

書ける抑制は、SwiftLint の行単位 `swiftlint:disable:next <規則>` か `swiftlint:disable:this <規則>` だけで、
直前行の `// Waiver: WVR-NNNN` と、そのファイルを範囲に含む期限付き waiver が両方あるときに限る。

次は waiver があっても書かない。
範囲の `swiftlint:disable`、`swiftlint:enable`、`all`、`swift-format-ignore`、`@diagnose`、`@warn`、
`@available(..., deprecated)`、`@preconcurrency`。

腐った抑制は残さない。期限切れの waiver は作業を止めて解消する。

### SWF-016 — テストは Swift Testing だけ

`import Testing`。XCTest を混在させない。時刻と外部乱数の禁止はテストにも適用し、明示 seed を使う。

## 4. コンパイラ

各 target で Swift 6 言語モード、警告のエラー化、ExistentialAny を manifest に固定する。
ツールの版は [ADR 0003](adr/0003-measured-toolchain.md)。兄弟の版を流用しない。
ゲートに `-typecheck` だけを使わない。未初期化の `let` は本コンパイルで扱う。

製品の外部パッケージはゼロ。新しい依存は ADR、許可リスト、この節の表を同じ変更で更新する。1 つでも欠けたら足していない。

| 依存 | 用途 | 根拠 |
| --- | --- | --- |
| — | — | 実行時は標準ライブラリと、Terminal の Glibc だけ |

ゲームエンジン、物理ライブラリ、描画ライブラリ、ncurses は入れない。

## 5. 採用しない検査

再提案するときは、ここに書いた理由への反論から ADR を始める。
理由は兄弟が公開文書に残した設計の採用である。P0 で動かしたのは、`only_rules` と swift-format の lint と本ビルドである。
この表の再実験はしていない。理由が崩れたと分かったら ADR で採否を更新する。
別の lint セットや、より緩い `.swift-format` を並べない。

| 検査 | 採用しない理由 |
| --- | --- |
| SwiftLint の既定規則や `opt_in_rules` の一括 | 矛盾する規則が同時に入る。`only_rules` で 1 つずつ名指しする |
| SwiftLint `private_over_fileprivate` | swift-format の `FileScopedDeclarationPrivacy` と同じ意味。規則を 2 か所に置かない |
| SwiftLint `identifier_name` / `type_name` | `x` `y` `dx` `dy` のような短い名前が意味を持つ。総称名は SWF-010 |
| SwiftLint `explicit_acl` | `internal` を毎回書かせるだけで、可視性を小さくしない |
| SwiftLint `unused_import` / `unused_declaration` | `analyze` は静的バイナリの単独実行と相性が悪い。未使用の局所は警告のエラー化で見る |
| SourceKit が要る SwiftLint 規則 | 静的バイナリでは黙って飛ばされ得る。P0 で飛ばされた規則は失敗にする |
| `--explicit-target-dependency-import-check error` | 兄弟の実測では標準モジュールと推移的依存を拒まないと記録されている。Summit では未実測。依存方向は [PROJECT_LAYOUT](PROJECT_LAYOUT.md) と P0 の依存グラフ検査を正本にする |
| `else` の字句拒否 | 正当な条件分岐まで拒む。閉じた enum の `==` / `else` は SWF-002 のレビュー |
| XCTest | Swift Testing と混在すると 1 回の `swift test` が両方を回し得る。枠組みは一つ |
| Foundation / FoundationEssentials | 決定性の穴になり、製品に要る機能が無い |

## 6. 規約を曲げたくなったとき

1. まず規約が間違っている可能性を検討する。
2. 規約が正しいなら設計を変える。抑制で通さない。
3. 抑制が必要なら、規則 ID、狭い範囲、期限付き waiver を先に記録する（SWF-015）。
4. 規則そのものを緩めるなら ADR を書く。どの部分が今も有効かを残す。閾値や除外を下げて目の前の変更を通さない。
