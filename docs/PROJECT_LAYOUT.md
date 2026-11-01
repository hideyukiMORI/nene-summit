# プロジェクト構成

現在存在するのは文書、Cursor ルール、文書検査器、CI のみ。
以下の SwiftPM target は**実装予定の構成**であり、まだ `Package.swift` はない。

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

- `Sources/<target>/`: 製品コード。実装するときに作る。
- `Tests/<target>Tests/`: 対応するテスト。空 target は作らない。
- `eng/`: ローカル / CI 共通の検査とその検証。
- `.github/`: CI、Issue / PR テンプレート。
- `.cursor/rules/`: 短い入口。詳細規範を重複させない。
- `docs/adr/`: 設計判断。`docs/waivers/`: 期限付き例外。

P0 で機械可読の依存グラフを導入し、manifest と import を照合する。
依存グラフを変更する場合はこの文書と ADR と検査を同時に更新する。
