# プロジェクト構成

いま `Package.swift` にある製品 target は NeNeSummitCore だけである。テストは NeNeSummitCoreTests。
以下の残りは実装予定で、target はまだ無い。

| Target | 責務 | 直接依存 |
| --- | --- | --- |
| NeNeSummitCore | 地形、物理、Input、状態遷移、出来事、復帰、登頂 | なし |
| NeNeSummitEngine | 自動登山、ルート判断、性格・台詞（後期） | NeNeSummitCore |
| NeNeSummitRender | セル格子、カメラ、配色、HUD、演出 | NeNeSummitCore, NeNeSummitEngine |
| NeNeSummitTerminal | raw mode、入力解析、ANSI 差分、リサイズ、復元 | NeNeSummitRender, Glibc |
| nene-summit | 引数・時計・seed・入力主体・ループ・将来の保存 | 上記 4 target, Glibc |

製品の Foundation / FoundationEssentials / Dispatch の import は禁止。
unsafe API は termios / ioctl 等の端末境界として Terminal にのみ隔離する。
テストは `<target>Tests` に置き、Swift Testing を使う。

- `Sources/NeNeSummitCore/`: いまある製品コード。ほかの target は実装するときにディレクトリを作る。
- `Tests/NeNeSummitCoreTests/`: 対応する Swift Testing。空 target は作らない。
- `eng/`: ローカル / CI 共通の検査とその検証。コミットメッセージ、conformance、ツール導入を含む。
- `.github/`: CI、Issue / PR テンプレート。CI は lock の Swift を入れてから `make check` する。
- `.cursor/rules/`: 短い入口。詳細規範を重複させない。
- `.swift-version`: Swift と swift-format の版。判断は [ADR 0003](adr/0003-measured-toolchain.md)。
- `.swift-format` / `.swiftlint.yml`: 整形と lint の正本。`make check` が実行する。
- `.githooks/`: GIT-003 の commit-msg。`make bootstrap` がこのリポジトリだけの `core.hooksPath` を向ける。
- `docs/adr/`: 設計判断。`docs/waivers/`: 期限付き例外。

依存の機械検査は、外部パッケージを manifest に置かないこと（CNF-010）と、禁止 import（CNF-004）まで。
target 同士の辺を上の表と照合する検査は、2 つ目の製品 target を足す変更で入れる。
依存を変えるときは、この文書と ADR と検査を同じ変更で更新する。
