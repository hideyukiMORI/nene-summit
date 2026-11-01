# ゲートの証拠

兄弟の実測を転載しない。成否は、このリポジトリで実行したコマンドだけを書く。

## 文書

正例と反例は `eng/test_check_docs.py`。

| ID | ケース | 期待 |
| --- | --- | --- |
| DOC-001 | 必須ファイルと有効な相対リンク | 成功 |
| DOC-001 | AGENTS.md の削除 | DOC-001 で失敗 |
| DOC-001 | 存在しない相対リンク | DOC-001 で失敗 |
| DOC-001 | リポジトリ外への相対リンク | DOC-001 で失敗 |
| 文書検査 | Sources に Swift を追加 | 成功。拒否は製品ゲートが持つ |

## コミットメッセージ

正例と反例は `eng/test_validate_commit_message.py`。

| ID | ケース | 期待 |
| --- | --- | --- |
| GIT-003 | 正準の件名、scope なし、初期化コミットの `(#N)` 省略、`BREAKING CHANGE` の対 | 成功 |
| GIT-003 | Issue 番号なし、未知の type、大文字 scope、英語の説明、101 文字超、空行なし、`!` だけでフッタなし | 失敗 |
| GIT-003 | 同期した main の `origin/main..HEAD` | 対象 0 件で成功。初期化コミットは範囲の外 |
| GIT-003 | 親の無い初期化コミットを含む `HEAD` | `(#N)` 省略を許して成功 |

## 字句の規約

正例と反例は `eng/test_conformance.py`。

| ID | ケース | 期待 |
| --- | --- | --- |
| conformance | 最小の struct、整形設定、lint 設定、manifest | 0 件 |
| CNF-001 | 型名の禁止語尾 | 失敗 |
| CNF-002 | 最上位の型が 2 つ | 失敗 |
| CNF-003 | 製品コードの `throws`。テスト側の `throws` は成功 | 製品だけ失敗 |
| CNF-004 | `import Foundation` と `import XCTest`。コメント内の import は成功 | import だけ失敗 |
| CNF-005 | `async` | 失敗 |
| CNF-006 | `Any` | 失敗 |
| CNF-007 | waiver の無い `swiftlint:disable:next` | 失敗 |
| CNF-008 | `.swift-format` の `rules` | 失敗 |
| CNF-009 | `.swiftlint.yml` の `excluded` | 失敗 |
| CNF-010 | ExistentialAny の無い manifest | 失敗 |
| CNF-011 | `public var` | 失敗 |
| CNF-012 | Terminal 以外の `unsafeBitCast` | 失敗 |

## 整形、lint、警告のエラー化

正例と反例は `eng/test_tool_rules.py`。道具が無いときは失敗する。

| ケース | 期待 |
| --- | --- |
| 短い struct を、リポジトリの `.swiftlint.yml` で lint | 成功。Skipping enabled rule は出ない |
| `only_rules` の各規則に、その名前を含む違反を 1 つ植える | その規則名で失敗 |
| 130 文字を超える行を swift-format に渡す | 失敗 |
| 製品の Swift ソースを swift-format に渡す | 成功 |
| 未使用の `let` を、製品と同じ manifest 設定で `swift build` | 失敗。使用する関数だけにすると成功 |

## 一部屋を登る

正例と反例は `Tests/NeNeSummitCoreTests`、描画は `NeNeSummitRenderTests`、キーは `NeNeSummitTerminalTests`。
0004 の時点で「位置はそのまま」「上向き」と書いていた行は、いまの検査ではない。

| ケース | 期待 |
| --- | --- |
| 空でない部屋名 | 成功 |
| 空の部屋名 | `RoomId` が拒否 |
| 幅 0、高さが正でない、幅ちょうどの位置、負の位置、セル数の不一致、初期位置が固体 | `Room` が拒否 |
| 開始状態 | 初期位置、右向き、tick 0、ダッシュは満タン |
| `idle` の一歩 | tick が 1、位置はそのまま |
| 右へ 5 歩を二度 | 状態列が一致し、x が増える |
| 左と右 | 状態列が分かれる |
| 1 セルの壁へダッシュ | 体が固体に重ならない |
| 棘 | チェックポイントへ戻り、ダッシュは満タン |
| 空中でダッシュを使い、着地 | ダッシュが戻る |
| 左の壁を蹴る | 右かつ上へ離れる |
| 著者の部屋を右へ跳び続ける | 登頂。同じ入力列の `Replay` も登頂 |
| 画面 | 人、固体、棘、頂上。登頂後の案内に「頂上」 |
| 矢印と a d w s、space、k、q | 対応する Press。未知のキーは空 |

## 短いジャンプと一部屋の読み

正例は `Tests/NeNeSummitCoreTests` のジャンプの範囲と部屋の順番、
登頂は `Tests/NeNeSummitEngineTests`、画面は `Tests/NeNeSummitRenderTests`。

| ケース | 期待 |
| --- | --- |
| 全力ジャンプの高さ | 体の 2 倍以上、4 倍以下 |
| 著者の部屋 | チェックポイントが棘より手前の同じ高さ。頂上はそれより高い。床の隙間は 3 マス以上 |
| 画面 | 人、固体、棘、頂上、`DASH`、`q quit`。登頂後の帯に「頂上」 |

## 無入力のやり直し

正例と反例は `Tests/NeNeSummitEngineTests`。

| ケース | 期待 |
| --- | --- |
| キーが無い一部屋 | 登頂し、間のあと最初へ戻り、もう一度登頂する |
| 天井と床だけの袋小路 | 途中で位置が変わり、打ち切りで開始位置へ戻る |
| 袋小路を人が右へ進み続ける | 打ち切らず、開始位置より右にいる |

## 端末の起動

`eng/play_session.py` が debug の `nene-summit` を PTY で起動し、出力のあと `q` を送り、終了コード 0 を見る。
終了後の termios 復元とリサイズは見ていない。TERM-001 は planned のまま。

## 実行記録

2026-11-01、この作業木で `make check` は成功した。

- `eng/install-tools.sh` は、既にある `.tools/swiftlint` 0.65.1 をそのまま使った。
- `origin/main..HEAD` のコミットは 0 件、違反 0。
- `python3 -m unittest discover -s eng -p 'test_*.py' -v` は 35 件成功。
- `python3 eng/check_docs.py` は成功。`python3 eng/conformance.py` は 0 件。
- `swift-format lint --strict` は製品の Swift ソースに違反 0。
- SwiftLint は違反 0。`Skipping enabled rule` は出ていない。
- `swift build` と `swift build -c release` は成功。警告は残っていない。
- `swift test` と `swift test -c release` は、Swift Testing の 2 件がどちらも成功。
  その前に XCTest の空スイートが 0 件で表示される。製品もテストも `import XCTest` はしていない。空スイートを消す設定は入れていない。

同じ日に、`swift --version` と `swift-format --version` は 6.4.1、`.tools/swiftlint version` は 0.65.1。
`~/.cache/swift-toolchain/swift-6.4.1-RELEASE-ubuntu24.04.tar.gz` の SHA-256 は `eng/swift.lock` と一致した。
CI の `eng/install-swift.sh` はこの作業木では実行していない。GitHub Actions も実行していない。
ゲームの再生、PTY、物理の不変条件は未実行。

2026-11-01、一部屋の `advance` を足した作業木で `make check` は再び成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 14 件ずつ成功。モジュール名の 2 件と、部屋の拒否、初期状態、tick、同じ入力列、向きの分岐を含む。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
XCTest の空スイートは、前の記録と同じく 0 件で表示される。重力、衝突、復帰は未実行。

2026-11-01、人が一部屋を登る作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 24 件ずつ成功。モジュール名、部屋の拒否、初期状態、同じ入力列、
壁で止まるダッシュ、棘からの復帰、着地での回復、壁蹴り、著者の部屋の登頂、画面、キーを含む。
XCTest の空スイートは 0 件で表示される。製品もテストも `import XCTest` はしていない。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、無入力の案内を足した作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 27 件ずつ成功。これまでの 24 件に、無入力の登頂とやり直し、
袋小路の打ち切り、人の入力では打ち切らないことの 3 件を含む。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。製品もテストも `import XCTest` はしていない。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、短いジャンプと画面下の案内を入れた作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 28 件ずつ成功。ジャンプの高さが体の 2 倍から 4 倍のあいだであること、
部屋の順番、無入力の登頂、画面の `DASH` と `q quit` を含む。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。参照作品の地形を写した検査はしていない。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。
