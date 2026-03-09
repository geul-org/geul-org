---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Goコメントでサービスロジックを宣言し実装コードを生成する。10の固定シーケンスタイプがサービス層のすべてのバイナリ契約操作をカバーする。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — GoコメントDSLからサービスコードを生成する。

サービスロジックは一連の決定だ：どのモデルをクエリするか、何を防御するか、いつ拒否するか、何を返すか。これらの決定はビジネスを理解する人のものだ——しかしボイラープレートに埋もれ、レイヤーに散らばり、リライトで失われる。

SSaCはこれらの決定を宣言的な仕様として保存する。**何が**起こり**どの順序か**を宣言すれば、ツールが実装を生成する。

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## 核心アイデア

すべてのサービス関数はステップのシーケンスだ。各ステップはバイナリ契約に従う：**成功 → 次の行、失敗 → return**。これは我々が発明した抽象ではない——サービスロジックがすでに動いている方法だ。SSaCはこれを明示的にする。

10の固定シーケンスタイプがこの契約に従うすべてのサービス層操作をカバーする。合わないものは`call`に委譲する。集合は設計上閉じている。

LLMなし、推論なし——テンプレートからの純粋なシンボリックコード生成。仕様が単一の真実の情報源だ。

## 例

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

この10行の宣言が以下のコードを生成する：

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## シーケンスタイプ（10）

| タイプ | 役割 |
|---|---|
| `authorize` | 権限検査（OPA等） |
| `get` | リソース検索 |
| `guard nil` | nullなら終了 |
| `guard exists` | 存在すれば終了 |
| `post` | リソース作成 |
| `put` | リソース更新 |
| `delete` | リソース削除 |
| `password` | パスワード比較 |
| `call` | 外部呼び出し（@component / @func） |
| `response` | レスポンス返却（json） |

## コード生成機能

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
      allowed: [room, user]
```

## ライセンス

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
