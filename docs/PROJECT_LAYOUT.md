# プロジェクト構成

`Package.swift` の製品 target は NeNeSummitCore、NeNeSummitRender、NeNeSummitTerminal と、実行ファイル `nene-summit`。
テストはそれぞれの `Tests`。Engine はまだ無い。

| Target | 責務 | 直接依存 |
| --- | --- | --- |
| NeNeSummitCore | 地形、物理、Input、状態遷移、出来事、復帰、登頂 | なし |
| NeNeSummitEngine | 自動登山、ルート判断、性格・台詞（後期） | NeNeSummitCore |
| NeNeSummitRender | セルの枠、配色、案内 | NeNeSummitCore |
| NeNeSummitTerminal | raw mode、入力解析、ANSI、待ち | NeNeSummitRender, Glibc |
| nene-summit | キーを Input に写す、時計の方針、ループ | NeNeSummitCore, NeNeSummitRender, NeNeSummitTerminal |

物理の数は Core の `MotionPolicy`。判断は [ADR 0005](adr/0005-playable-climb.md)。
製品の Foundation / FoundationEssentials / Dispatch の import は禁止。
unsafe API は termios / read / write の端末境界として Terminal にのみ隔離する。
実行ファイルは Glibc を import しない。
テストは `<target>Tests` に置き、Swift Testing を使う。

- `Sources/NeNeSummitCore/`: 部屋、物理、`SummitState.advance`。
- `Sources/NeNeSummitRender/`: 枠を返す。当たり判定は持たない。
- `Sources/NeNeSummitTerminal/`: 端末の開始、読み、描画、待ち、終了。
- `Sources/nene-summit/`: 人が遊ぶループ。
- `Tests/`: 対応する Swift Testing。空 target は作らない。
- `eng/`: ローカル / CI 共通の検査。`play_session.py` は PTY で起動と `q` だけを見る。
- `.github/`: CI、Issue / PR テンプレート。CI は lock の Swift を入れてから `make check` する。
- `.cursor/rules/`: 短い入口。詳細規範を重複させない。
- `.swift-version`: Swift と swift-format の版。判断は [ADR 0003](adr/0003-measured-toolchain.md)。
- `.swift-format` / `.swiftlint.yml`: 整形と lint の正本。`make check` が実行する。
- `.githooks/`: GIT-003 の commit-msg。`make bootstrap` がこのリポジトリだけの `core.hooksPath` を向ける。
- `docs/adr/`: 設計判断。`docs/waivers/`: 期限付き例外。

依存の機械検査は、外部パッケージを manifest に置かないこと（CNF-010）と、禁止 import（CNF-004）まで。
target 同士の辺を上の表と照合する検査は未実装。依存を変えるときは、この文書と ADR を同じ変更で更新する。
