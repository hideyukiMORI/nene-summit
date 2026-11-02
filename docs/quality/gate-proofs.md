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

2026-11-01、押しっぱなしと同時押しを入れた作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 43 件ずつ成功。内訳は端末 10、描画 2、案内 3、Core 28。
これまでの 28 件に、1 回の読みの二つのキー、win32 の押す・離す、kitty の押す・くり返し・離す、
文字のくり返し窓、短い打鍵、左右の打ち消し、ジャンプの押しっぱなしと離した短縮、ダッシュの一度だけを含む。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の Windows Terminal で両方の列が同時に届くかは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、オートとマニュアルの切替を入れた作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 47 件ずつ成功。内訳は端末 11、描画 3、案内 5、Core 28。
これまでの 43 件に、マニュアルの無入力がその場に留まること、マニュアルの頂上が無入力のままであること、
画面の `PLAY`、`m` が移動にならないことを含む。オートの登頂とやり直しは残っている。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機で `m` を押した感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、ジャンプ中の左右を走る速さへ乗せた作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 50 件ずつ成功。内訳は端末 11、描画 3、案内 5、Core 31。
これまでの 47 件に、方向を押したジャンプが走る速さになること、短く離しても 1 マス以上進むこと、
方向を離すと跳ぶ前の横速度が残ること、空中の左右が 1 tick で走る速さへ届くことを含む。
オートの登頂は残っている。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機でスペースと `a` / `d` を押した感触は未計測。入力ログは取っていない。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、実機の入力をローカルファイルへ残す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 54 件ずつ成功。内訳は端末 15、描画 3、案内 5、Core 31。
これまでの 50 件に、記録の宛先、`0` で書かないこと、バイトと打鍵の文字化、速度の公開読み取りを含む。
オートの登頂は残っている。ジャンプの速度はこの変更で動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は記録を切った debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の記録ファイルは、この実行の時点ではない。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、方向を押したジャンプを斜め上へ進める作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 55 件ずつ成功。内訳は端末 15、描画 3、案内 5、Core 32。
これまでの 54 件に、方向を押した横速度が上への速さと揃うこと、空中の 1 tick、地面の走る速さ、
右を押した全力ジャンプを二回続けると下の浮島に着くことを含む。オートの登頂は残っている。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は記録を切った debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機で右上へ跳んだ感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、入力記録をデバッグ定数で切った作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 53 件ずつ成功。内訳は端末 13、描画 3、案内 5、Core 32。
これまでの 55 件から、環境変数の宛先 3 件を外し、定数が偽で記録を開かない 1 件を足した。
オートの登頂は残っている。ジャンプの速度はこの変更で動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。環境変数は触っていない。
復元とリサイズは未実行。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、頂上のあと次の部屋へ進む作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 56 件ずつ成功。内訳は端末 13、描画 3、案内 6、Core 34。
これまでの 53 件に、道の順、道の外は留まること、次の部屋では隙間のあとにチェックポイントがあること、
二部屋目の登頂から最初の部屋へ戻ることを含む。案内の跳び方とジャンプの速度はこの変更で動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機で次の部屋を登った感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、帯にボヤキを足して枠の外を消す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 61 件ずつ成功。内訳は端末 14、描画 4、案内 9、Core 34。
これまでの 56 件に、狭い枠が行末と枠の下を消すこと、部屋を開いた一言、ジャンプの間、棘と登頂の割り込み、帯にその文が出ることを含む。
無入力の登頂は残っている。物理の速度はこの変更で動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機でゴミが消えたことと、ボヤキの感じは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、固定の色面と英語の四人を足す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 64 件ずつ成功。内訳は端末 14、描画 6、案内 10、Core 34。
これまでの 61 件に、二部屋が同じ枠であること、遠い棘が窓の外であること、四人が順に話すことを含む。
山のマスに `#` と `^` が無いこと、登頂で題が替わること、マニュアルでは AUTO が無いことも見ている。
無入力の登頂は残っている。物理の速度はこの変更で動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色面と四人のセリフは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、一フレームを末尾まで書く作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 65 件ずつ成功。内訳は端末 15、描画 6、案内 10、Core 34。
これまでの 64 件に、24 行の枠が改行を含まないこと、同じ空の色が行ごとに一度であることを含む。
無入力の登頂は残っている。物理の速度はこの変更で動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機で床と人が見えることは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、案内が advance の複製で先を見る作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 67 件ずつ成功。内訳は端末 15、描画 6、案内 12、Core 34。
これまでの 65 件に、先読みのあと本番の状態が同じであること、棘へ歩く候補より落ちない候補を選ぶことを含む。
無入力の二部屋の登頂は残っている。物理の速度はこの変更で動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。seed の到達率は未記録。実機で案内の登り方を見た感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、ばねと動く床を道に足す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 73 件ずつ成功。内訳は端末 15、描画 7、案内 14、Core 37。
これまでの 67 件に、ばねで上へ弾くこと、横の床と上の床が体を運ぶこと、
無入力でばねと横の床と上の床を登頂し、上の床のあと最初の部屋へ戻ることを含む。
無入力の二部屋の登頂は残っている。案内の跳び方はこの変更で部屋ごとに足していない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機でばねと床の感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、絵は足さずロジックだけ取り込む方針を書いた作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 73 件ずつ成功。内訳は端末 15、描画 7、案内 14、Core 37。
製品コードは増えていない。これまでの 73 件のまま。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、壁に沿って上る井戸を道に足す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 75 件ずつ成功。内訳は端末 15、描画 7、案内 16、Core 37。
これまでの 73 件に、無入力で井戸を登頂し途中で壁に沿うこと、井戸のあと最初の部屋へ戻ることを含む。
案内の跳び方はこの変更で部屋ごとに足していない。新しい字形は足していない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機で井戸の感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、画面の刻みを枠の残りだけにする作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 79 件ずつ成功。内訳は端末 19、描画 7、案内 16、Core 37。
これまでの 75 件に、使い始めた枠は全部待つこと、途中なら残りだけ待つこと、
枠を超えても遅れをまとめないこと、時計が戻っても枠を超えて待たないことを含む。
物理の速度はこの変更で動かしていない。描画の間引きは足していない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機で飛びが減った感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、低い隙間をダッシュで越す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 81 件ずつ成功。内訳は端末 19、描画 7、案内 18、Core 37。
これまでの 79 件に、無入力で隙間を登頂し途中でダッシュを使うこと、隙間のあと最初の部屋へ戻ることを含む。
案内の跳び方はこの変更で部屋ごとに足していない。新しい字形は足していない。物理の速度は動かしていない。
画面の枠は少し短くした。数は `FramePace`。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機で、短くした枠と隙間の感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、色面と右の欄を整える作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 81 件ずつ成功。内訳は端末 19、描画 7、案内 18、Core 37。
これまでの 81 件のまま。枠の試験は、HOLD、GROUND、ALT、READY、通信の顔を見るようにした。
空の色番号を変えた行が、24 行それぞれに一度あることも見ている。
箱線、得点、残機は足していない。物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色の感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、画面の枠と奥行きと拾う光を足す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 86 件ずつ成功。内訳は端末 19、描画 10、案内 19、Core 38。
これまでの 81 件に、帯の地が空と違うこと、幅 1 の枠、奥の山がカメラより遅いこと、
光を一度だけ拾い落ちても残ること、描画が状態を変えないこと、次の部屋が数だけを持つことを含む。
仕組みの字形は足していない。物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、枠が幅 1 で出るかは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、地を黒にし、きらめきを小さな光にする作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 86 件ずつ成功。内訳は端末 19、描画 10、案内 19、Core 38。
これまでの 86 件のまま。空の地が黒であること、きらめきが隣のコマで欠けないことを、起動した画面の連続コマで見た。
物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の黒と、きらめきの感触は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、山を罫と字形で描く作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 87 件ずつ成功。内訳は端末 19、描画 10、案内 19、Core 39。
これまでの 86 件に、果実の隣の硬貨を一度だけ拾うことを足した。
起動した画面の 1 コマで、床が罫、棘と果実と硬貨が字形であることを見た。
物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、罫が幅 1 で出るかは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、雪山の雲と稜線を描く作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 87 件ずつ成功。内訳は端末 19、描画 10、案内 19、Core 39。
これまでの 87 件のまま。雲が稜線より遅いこと、稜線がカメラ 2 マスでは動かず 3 マスでずれることを見ている。
起動した画面の 1 コマで、雲、稜線、雪の線、雪の床、人、棘、果実、硬貨の輪郭を見た。
物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、罫が幅 1 で出るかは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、頂を旗一本にし、雲を輪郭にする作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 88 件ずつ成功。内訳は端末 19、描画 11、案内 19、Core 39。
これまでの 87 件に、頂上の列の中央だけが旗で残りが唇であることを足した。
起動した画面の 1 コマで、雲の輪郭、左右の続く稜線、頂の雪、穴のある雪の線を見た。
物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、罫が幅 1 で出るかは未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-01、落ちる塊と崩れる床と結晶を足す作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 93 件ずつ成功。内訳は端末 19、描画 11、案内 21、Core 42。
これまでの 88 件に、塊の下で倒れること、崩れる床が消えて戻ること、結晶がダッシュを戻すこと、
無入力の案内が新しい二部屋を登頂することを足した。
物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、この画面は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-02、登頂が塊の列と崩れる床を通る作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 95 件ずつ成功。内訳は端末 19、描画 11、案内 23、Core 42。
これまでの 93 件に、案内が塊の列を越えるあいだに塊が落ちること、崩れる床の上を踏んで登頂することを足した。
物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、この画面は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-02、雲を平たい欠けにし、落ちる塊を大きくして部屋を窓より広くする作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 96 件ずつ成功。内訳は端末 19、描画 12、案内 23、Core 42。
これまでの 95 件に、落ちる部屋が窓より広くカメラが横へ動くことを足した。
雲のずれは、欠けた腹でも同じ点を見ている。案内は塊の列を越えるあいだに塊が落ち、登頂する。
物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、この画面は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-02、窓に収まる部屋はカメラを止め、広い部屋は先を見せる作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 98 件ずつ成功。内訳は端末 19、描画 13、案内 24、Core 42。
これまでの 96 件に、広い部屋で先の足場が見えること、案内が空中の結晶を通って登頂することを足した。
窓に収まる一枚ではカメラが動かない。物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、この画面は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-02、部屋を高さの違う柱と枠の一枚にする作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 100 件ずつ成功。内訳は端末 19、描画 13、案内 24、Core 44。
これまでの 98 件に、柱の高さが違うこと、腹の欠け、枠の左右の壁を足した。
案内は各部屋を登頂する。歩きの列と穴と頂と結晶の弧と落ちる塊の穴は動かしていない。物理の速度は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、この画面は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。

2026-11-02、崩れる床を二つの岸のあいだの橋にする作業木で `make check` は成功した。
unittest 35 件、conformance 0 件、整形と lint は違反 0、debug / release の build は成功。
Swift Testing は debug と release で 101 件ずつ成功。内訳は端末 19、描画 13、案内 24、Core 45。
これまでの 100 件に、崩れる床の直下が空きであることを足した。
案内は渡りに乗って登頂する。速度と周期は動かしていない。
XCTest の空スイートは 0 件で、テスト target の数だけ表示される。
`eng/play_session.py` は debug の `nene-summit` を PTY で起動し、出力のあと `q` で終了コード 0 だった。
復元とリサイズは未実行。実機の色と、この画面は未計測。
この実行のとき変更はまだコミット前で、`origin/main..HEAD` は 0 件だった。
CI はこの作業木では実行していない。
