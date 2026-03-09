---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "在Go注释中声明服务逻辑并生成实现代码。10个固定序列类型覆盖服务层所有二进制契约操作。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — 从Go注释DSL生成服务代码。

服务逻辑是一系列决策：查询哪个模型、防御什么、何时拒绝、返回什么。这些决策属于理解业务的人——但它们被埋在样板代码中，散落在各层，在重写中丢失。

SSaC将这些决策保存为声明式规范。你声明**什么**发生以及**什么顺序**。工具生成实现。

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## 核心理念

每个服务函数都是步骤的序列。每个步骤遵循二进制契约：**成功 → 下一行，失败 → 返回**。这不是我们发明的抽象——这是服务逻辑已有的工作方式。SSaC使其显式化。

10个固定序列类型覆盖遵循此契约的所有服务层操作。不适合的委托给`call`。集合在设计上是封闭的。

没有LLM，没有推理——基于模板的纯符号代码生成。规范是唯一事实来源。

## 示例

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

这个10行声明生成以下代码：

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

## 序列类型（10）

| 类型 | 角色 |
|---|---|
| `authorize` | 权限检查（OPA等） |
| `get` | 资源查询 |
| `guard nil` | 为空则退出 |
| `guard exists` | 存在则退出 |
| `post` | 资源创建 |
| `put` | 资源更新 |
| `delete` | 资源删除 |
| `password` | 密码比较 |
| `call` | 外部调用（@component / @func） |
| `response` | 返回响应（json） |

## 代码生成功能

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

## 许可证

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
