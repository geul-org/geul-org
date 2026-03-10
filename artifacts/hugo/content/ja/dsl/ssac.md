---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Goコメント1行が1つのシーケンスだ。10の固定シーケンスタイプがサービス層のすべてのバイナリ分岐をカバーし、シンボリックコード生成でginハンドラーを生成する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — Goコメント1行が1つのシーケンスだ。宣言すればginハンドラーが生成される。

サービスロジックは一連の決定だ：どのモデルをクエリするか、何を防御するか、いつ拒否するか、何を返すか。これらの決定はビジネスを理解する人のものだが、ボイラープレートに埋もれ、レイヤーに散らばり、リライトで失われる。

SSaCはこれらの決定を宣言的な仕様として保存する。**何が**起こり**どの順序か**を1行ずつ宣言すれば、ツールが実装を生成する。

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (コメントDSL)        (検証)           (コード生成)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHubリポジトリ</a>

## 核心アイデア

すべてのサービス関数はステップのシーケンスだ。各ステップはバイナリ契約に従う：**成功 → 次の行、失敗 → return**。これは我々が発明した抽象ではない——サービスロジックがすでに動いている方法だ。SSaCはこれを明示的にする。

10の固定シーケンスタイプがこの契約に従うすべてのサービス層操作をカバーする。合わないものは`@call`に委譲する。集合は設計上閉じている。

LLMなし、推論なし——テンプレートベースの純粋なシンボリックコード生成。仕様が単一の真実の情報源だ。

## 文法 — 1行が1つのシーケンス

v2から各シーケンスは1行のコメントだ。`@response`のみ複数行ブロックとなる。

**CRUD — モデル操作**

```go
// @get Type var = Model.Method(args...)        — 取得（結果必須）
// @post Type var = Model.Method(args...)       — 作成（結果必須）
// @put Model.Method(args...)                   — 更新（結果なし）
// @delete Model.Method(args...)                — 削除（結果なし）
```

引数形式：`source.Field` または `"リテラル"`

- `request.CourseID` — HTTPリクエストから
- `course.InstructorID` — 前の結果変数から
- `currentUser.ID` — 認証コンテキストから
- `"cancelled"` — 文字列リテラル

**ガード**

```go
// @empty target "message"                      — nil/zeroなら失敗（404）
// @exists target "message"                     — nil/zeroでなければ失敗（409）
```

対象：変数（`course`）または変数.フィールド（`course.InstructorID`）

**状態遷移**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**権限検査 — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**外部呼び出し**

```go
// @call Type var = package.Func(args...)       — 結果あり
// @call package.Func(args...)                  — 結果なし
```

**レスポンス — フィールドマッピングブロック**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## 例

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "権限がありません"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "予約が見つかりません"
// @state reservation {status: reservation.Status} "cancel" "キャンセルできません"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

10行の宣言。各行が1つのシーケンスであり、上から下へ順番に実行される。権限 → 取得 → ガード → 状態遷移 → 外部呼び出し → 更新 → 再取得 → レスポンス。

## シーケンスタイプ（10）

| タイプ | 役割 |
|---|---|
| `@auth` | 権限検査（OPA ポリシー） |
| `@get` | リソース取得 |
| `@empty` | nil/zeroなら終了（404） |
| `@exists` | nil/zeroでなければ終了（409） |
| `@post` | リソース作成 |
| `@put` | リソース更新 |
| `@delete` | リソース削除 |
| `@state` | 状態遷移検証 |
| `@call` | 外部パッケージ関数呼び出し |
| `@response` | レスポンス返却（フィールドマッピング） |

## 検証

内部検証（常時）：
- タイプ別必須引数の欠落
- `Model.Method` 形式
- 変数フロー（宣言前の参照）

外部SSOT交差検証（プロジェクト構造検出時）：
- モデル/メソッドの存在（sqlcクエリ、Goインターフェース）
- リクエスト/レスポンスフィールドの存在（OpenAPI）
- パッケージ/関数の存在（Goインターフェース）
- 古いデータ警告：put/delete後にre-fetchなしでresponse（WARNING）
- 状態ダイアグラムの存在および遷移の妥当性検証
- OPAポリシーファイルの存在検証

## コード生成機能

外部SSOT（シンボルテーブル）があれば`ssac gen`が追加機能を提供する。生成コードはginフレームワークを使用する。

- **型変換**：DDLカラム型 → `strconv.ParseInt`、`time.Parse`、400 Bad Request早期リターン
- **ガード値型**：型認識ゼロチェック（`int` → `== 0`/`> 0`、ポインタ → `== nil`/`!= nil`）
- **モデルインターフェース導出**：3つのSSOTソース交差 → `<outDir>/model/models_gen.go`
- **@state コード生成**：状態ダイアグラムパッケージの`CanTransition`呼び出し
- **@auth コード生成**：`authz.Check(currentUser, "action", "resource", authz.Input{...})`呼び出し
- **@call コード生成**：結果なしならガードスタイル（401）、結果ありなら値スタイル（500）
- **ドメインフォルダ構造**：`service/auth/login.go` → `outDir/auth/login.go`、`package auth`

## OpenAPI x- 拡張

インフラパラメータ（ページネーション、ソート、フィルタリング、リレーション含む）はOpenAPI `x-` 拡張に宣言する。SSaC仕様にはビジネスパラメータのみ宣言する。コード生成器が`x-`を読み取り`QueryOpts`を自動構成する。

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## ライセンス

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHubリポジトリ</a>
