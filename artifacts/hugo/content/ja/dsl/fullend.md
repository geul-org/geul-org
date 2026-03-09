---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-09T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "5つのSSoT（STML、OpenAPI、SSaC、SQL DDL、Terraform）の交差整合性を検証し、コードを生成するCLI。バイブコーディングの亀裂を構造で埋める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — 5つのSSOTの整合性を一度に検証し、コードを生成するCLI。

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHubリポジトリ</a>

## バイブコーディングの亀裂

バイブコーディングが普及するにつれ、あるパターンが見え始めた。

AIに「予約機能を作って」と言えば作る。「キャンセル機能を追加して」と言えば追加する。5つ目の機能を追加したとき、2つ目の機能が壊れる。APIスキーマを変えたのにフロントエンドを直していない。DBカラムを追加したのにサービスレイヤーが知らない。

原因は単純だ。AIがコード全体を記憶できないからだ。

そこで人々がやること：壊れた箇所を見つけたらAIに「これも直して」と言う。直すと別の場所が壊れる。「それも直して」。このループが繰り返される。プロジェクトが大きくなるほどループは長くなり、ある時点で「最初から作り直した方が早い」となる。

## コードはなぜ膨らむのか

コードには2つのものが混在している。

**決定**: 何を表示するか、どのAPIを呼ぶか、どの順序で処理するか、何を保存するか。
**配線**: その決定を特定のフレームワークで実装するコード。

予約システムを作るとしよう。

```
決定: 「予約作成時に部屋を検索し、なければ404、あれば作成」
```

この1行の決定がReactフック、Goハンドラ、SQLクエリ、APIスキーマ、Terraformリソースに散らばる。それぞれのフレームワーク構文で包まれ、エラー処理と型変換が付け加わる。

10万行のコードのうち、決定は12,500行だ。残りの87,500行は配線だ。

AIエージェントのコンテキストウィンドウには限りがある。10番目の機能を追加するとき、前の9回を覚えていない。10万行を丸ごと読めないからだ。

決定だけを分離すれば12,500行。200Kトークンコンテキストの55%。AIが一度に読める大きさだ。

## 5つのSSoT

Fullendはソフトウェアを構成する5つのレイヤーに、それぞれ1つのDSLを対応させる。各DSLが該当レイヤーの単一真実源（SSOT）となる。

| レイヤー | DSL | 宣言内容 |
|---|---|---|
| 画面 | STML (HTML5 + data-*) | 何を表示し何をするか |
| API契約 | OpenAPI 3.x | どんなリクエストを受け、どんなレスポンスを返すか |
| サービスフロー | SSaC (Go comment DSL) | どの順序で処理するか |
| データ構造 | SQL DDL + sqlc | 何を保存するか |
| インフラ | Terraform HCL | どこで動かすか |

OpenAPI、SQL DDL、Terraformは業界標準だ。画面とサービスフローには対応するSSoT DSLが存在しなかった。フロントエンドの決定はReactフックに埋没し、サービスフローはGoハンドラに散在していた。そこで[STML](/ja/dsl/stml/)と[SSaC](/ja/dsl/ssac/)を設計した。このプロジェクトで作ったDSLだ。

```
specs/
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
└── terraform/*.tf         → HCL
```

`specs/`が真実だ。`artifacts/`はいつでも再生成できる。

## 個別検証はすでにある

3つのレイヤーの検証ツールはすでに存在する。

- sqlcがDDLとクエリの整合性を検査する。
- OpenAPIバリデータがスキーマの妥当性を検査する。
- TerraformがHCLの構文と依存関係を検査する。

STMLとSSaCにもそれぞれ内蔵バリデータを作った。SSaCはサービスフローの内部一貫性を、STMLはUI宣言とOpenAPIの一致を検査する。

5つのレイヤーはそれぞれ自身の内部で検証できる。問題は**間**で発生する。

フロントエンドが`data-bind="memo"`でフィールドを表示しているのに、APIレスポンススキーマに`memo`がない。SSaCが`@model Reservation.SoftDelete`を呼び出しているのに、sqlcクエリに`SoftDelete`メソッドがない。OpenAPIで`x-sort: [created_at]`を宣言しているのに、DDLテーブルに該当カラムのインデックスがない。

個別ツールは自分のレイヤーしか見ない。レイヤー間の亀裂は見えない。

## 構造を隠す

「でも5つのDSLを覚えなきゃいけないでしょ？」

その通りだ。しかし構造はユーザーに見せる必要がない。

エージェントのシステムプロンプトに技術スタックとSSOTルールをあらかじめ入れておけば、ユーザーは「予約機能を作って」と言うだけでいい。エージェントが自動でOpenAPIにエンドポイントを追加し、DDLにテーブルを作り、SSaCにサービスフローを宣言し、STMLに画面を描き、`fullend validate`を実行して整合性を確認する。

ユーザーが見るのは結果だけだ。構造はエージェントが消費するものであり、ユーザーが学習するものではない。

バイブコーディングの体験はそのままだ。変わるのは、裏側で壊れなくなるということ。

## Fullendの役割

Fullendは交差バリデータだ。個別ツールを再発明しない。各ツールを呼び出し、レイヤー間の境界を検査する。

```bash
fullend validate specs/
```

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✓ SSaC         7 service functions
✓ STML         4 pages, 6 bindings
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

1つでも失敗すれば：

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @model Reservation.SoftDelete — method not found in sqlc queries
✗ Cross        1 mismatch

FAILED: Fix errors before codegen.
```

検証が通ればコードを生成する。

```bash
fullend gen specs/ artifacts/
```

sqlcがDBモデルを生成し、oapi-codgenがAPI型を生成し、SSaCがサービス関数を生成し、STMLがReactコンポーネントを生成し、Fullendがそれらを繋ぐグルーコードを生成する。

## 交差検証ルール

Fullendの固有の価値は交差検証にある。

**OpenAPI ↔ DDL**

| 検証対象 | ルール |
|---|---|
| x-sort.allowed | 該当カラムがテーブルに存在するか |
| x-filter.allowed | 該当カラムがテーブルに存在するか |
| x-include.allowed | FK関係で接続されたテーブルか |

**SSaC ↔ DDL**

| 検証対象 | ルール |
|---|---|
| @model Model.Method | sqlcクエリに該当メソッドが存在するか |
| @result Type | DDLテーブルから派生した型と一致するか |
| @param 名前 | DDLカラムに変換可能か |

**SSaC ↔ OpenAPI**

| 検証対象 | ルール |
|---|---|
| 関数名 | operationIdと一致するか |
| @param request | リクエストスキーマにフィールドがあるか |
| @result + response | レスポンススキーマにフィールドがあるか |

**STML ↔ SSaC** — どちらも同じOpenAPIのoperationIdを参照する。両方の検証が通れば、フロントエンドが呼び出すAPIとバックエンドが処理するAPIの一致が自動的に保証される。

## エージェントのための設計

FullendはAIエージェントのために設計された。

エージェントがspecを書くには、SSaCの10個のシーケンスタイプ、STMLの12個のdata-*属性、OpenAPI x-拡張、名前マッチングルールを知る必要がある。そのために約350行のAI向けマニュアルを提供する。エージェントのシステムプロンプトに一度入れるだけでいい。

spec作成後の検証ループは単純だ。

```
エージェントワークフロー:
1. specs/を修正
2. fullend validate specs/
3. エラーがあれば → 該当SSOTを修正 → 2へ
4. エラー0 → fullend gen specs/ artifacts/
```

システム全体を理解する必要はない。validateが指し示す箇所だけ直せば整合性が回復する。賢いモデルは一発で当て、小さなモデルは3回で当てる。結果は同じだ。

## 規模別SSOTサイズ

| 規模 | 例 | SSOT | 実装コード | コンテキスト占有率 |
|---|---|---|---|---|
| 小規模 | 美容室予約 | ~1,500行 | ~1万行 | ~8% |
| 中規模 | Jira、Notion級 | ~12,500行 | ~10万行 | ~55% |
| 大規模 | Shopify級 | ~30,000行 | ~30万行 | ~90% |

200Kトークンコンテキスト基準。中規模SaaSまでエージェントが設計全体を一度に読める。

## 例外のパターン化

10個のシーケンスタイプで対応できないものは`call`に逃がす。data-*属性で対応できないものは`custom.ts`に逃がす。このエスケープハッチが全体の20%を超えると、構造化の意味が薄れる。

しかし例外は隔離された瞬間に観察可能になる。多くのプロジェクトがFullendで構造化されれば、`call`と`custom.ts`に繰り返されるパターンが現れるだろう。

SSaCの10個のシーケンスタイプも最初から設計されたものではない。サービスコードを数百個観察した結果、10個に収束した。同じ原理がエスケープハッチでも繰り返されると期待している。頻出する`call`パターンは新しいシーケンスタイプになり、頻出する`custom.ts`パターンは新しいdata-*属性になる。

例外が減るのではない。例外から構造が育つのだ。

## 技術スタックの拡張

現在Fullendは Go + React + PostgreSQL + Terraformに固定されている。意図的だ。PoC段階では1つのスタックを最後まで貫通させることが先だ。

しかし5つのSSOTのうち3つ（OpenAPI、SQL DDL、Terraform）はすでに言語非依存だ。SSaCの10個のシーケンスタイプは言語に依存しないパターンだ — Goコメントで表現しているだけだ。STMLはHTML5 data-*属性なのでフレームワークに依存しない。

拡張はコード生成バックエンドを追加する問題だ。検証ロジックと交差検証ルールはそのまま維持される。

## GEULとの関係

5つのDSLがソフトウェアのSSOTを構成する。SSOTは構造化データだ。構造化データはグラフだ。グラフはGEULでエンコードできる。

STMLの`data-fetch="ListReservations"`はエンティティ間の関係だ。SSaCの`@sequence get → @model → @guard → @response`はイベントシーケンスだ。OpenAPIのエンドポイント定義は契約だ。すべてGEULのトリプルエッジ、イベント6エッジ、エンティティノードで表現できる意味構造だ。

Fullendが5つのDSL間の交差検証を行う方式 — シンボリックマッチング、型整合性検査、参照整合性確認 — はGEULストリームでの機械的検証と同じ原理だ。

## ライセンス

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
