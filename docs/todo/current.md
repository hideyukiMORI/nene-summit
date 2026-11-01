# 現在地

更新: 2026-11-01。

## 完了

- リポジトリ初期化用の規範・要件・設計案・アプローチ・ポリシーを整備。
- Cursor ルール、AGENTS の読み順、貼り付け用指示を用意。
- 文書検査と検査器の正例・反例、同じ make check を呼ぶ CI を用意。

## 未着手

P0〜P5 の製品実装全体。SwiftPM / Swift の版固定 / ビルド / ゲームテスト / 端末動作 / インストーラ / Release。

## 次の作業

[APPROACH](../APPROACH.md) の P0 を最初の実装 Issue にする。
受け入れ条件: Swift 版の実測、最小 target、debug / release build、Swift Testing、
format / lint / conformance と反例、ローカルと CI の共通 make check。
P0 までは現在の成功をゲームの品質証明と呼ばない。

現在、実装 Issue / PR は未作成。初期化コミットは GIT-001 の例外。
