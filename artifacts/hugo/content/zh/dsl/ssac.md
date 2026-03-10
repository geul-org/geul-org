---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "一行 Go 注释就是一个序列。10 个固定序列类型覆盖服务层所有二进制分支，符号代码生成产出 gin 处理器。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — 一行 Go 注释就是一个序列。声明即可生成 gin 处理器。

服务逻辑是一系列决策：查询哪个模型、防御什么、何时拒绝、返回什么。这些决策属于理解业务的人，但它们被埋在样板代码中，散落在各层，在重写中丢失。

SSaC 将这些决策保存为声明式规范。逐行声明**什么**发生以及**什么顺序**，工具生成实现。

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (注释 DSL)           (验证)            (代码生成)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub 仓库</a>

## 核心理念

每个服务函数都是步骤的序列。每个步骤遵循二进制契约：**成功 → 下一行，失败 → 返回**。这不是我们发明的抽象——这是服务逻辑已有的工作方式。SSaC 使其显式化。

10 个固定序列类型覆盖遵循此契约的所有服务层操作。不适合的委托给 `@call`。集合在设计上是封闭的。

没有 LLM，没有推理——基于模板的纯符号代码生成。规范是唯一事实来源。

## 语法 — 一行一个序列

从 v2 开始，每个序列是一行注释。仅 `@response` 是多行块。

**CRUD — 模型操作**

```go
// @get Type var = Model.Method(args...)        — 查询（结果必需）
// @post Type var = Model.Method(args...)       — 创建（结果必需）
// @put Model.Method(args...)                   — 修改（无结果）
// @delete Model.Method(args...)                — 删除（无结果）
```

参数格式：`source.Field` 或 `"字面量"`

- `request.CourseID` — 来自 HTTP 请求
- `course.InstructorID` — 来自之前的结果变量
- `currentUser.ID` — 来自认证上下文
- `"cancelled"` — 字符串字面量

**守卫**

```go
// @empty target "message"                      — nil/zero 则失败（404）
// @exists target "message"                     — 非 nil/zero 则失败（409）
```

目标：变量（`course`）或变量.字段（`course.InstructorID`）

**状态转换**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**权限检查 — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**外部调用**

```go
// @call Type var = package.Func(args...)       — 有结果
// @call package.Func(args...)                  — 无结果
```

**响应 — 字段映射块**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## 示例

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "无权限"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "找不到预约"
// @state reservation {status: reservation.Status} "cancel" "无法取消"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

10 行声明。每行一个序列，从上到下顺序执行。权限 → 查询 → 守卫 → 状态转换 → 外部调用 → 修改 → 重新查询 → 响应。

## 序列类型（10）

| 类型 | 角色 |
|---|---|
| `@auth` | 权限检查（OPA 策略） |
| `@get` | 资源查询 |
| `@empty` | nil/zero 则终止（404） |
| `@exists` | 非 nil/zero 则终止（409） |
| `@post` | 资源创建 |
| `@put` | 资源修改 |
| `@delete` | 资源删除 |
| `@state` | 状态转换验证 |
| `@call` | 外部包函数调用 |
| `@response` | 返回响应（字段映射） |

## 验证

内部验证（始终执行）：
- 按类型必需参数缺失
- `Model.Method` 格式
- 变量流（引用前声明）

外部 SSOT 交叉验证（检测到项目结构时）：
- 模型/方法存在（sqlc 查询、Go 接口）
- 请求/响应字段存在（OpenAPI）
- 包/函数存在（Go 接口）
- 过期数据警告：put/delete 后未重新查询即响应（WARNING）
- 状态图存在及转换有效性验证
- OPA 策略文件存在验证

## 代码生成功能

有外部 SSOT（符号表）时，`ssac gen` 提供额外功能。生成代码使用 gin 框架。

- **类型转换**：DDL 列类型 → `strconv.ParseInt`、`time.Parse`，400 Bad Request 提前返回
- **守卫值类型**：类型感知零值检查（`int` → `== 0`/`> 0`，指针 → `== nil`/`!= nil`）
- **模型接口推导**：3 个 SSOT 源交叉 → `<outDir>/model/models_gen.go`
- **@state 代码生成**：调用状态图包的 `CanTransition`
- **@auth 代码生成**：调用 `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **@call 代码生成**：无结果则守卫风格（401），有结果则值风格（500）
- **域文件夹结构**：`service/auth/login.go` → `outDir/auth/login.go`，`package auth`

## OpenAPI x- 扩展

基础设施参数（分页、排序、过滤、关系包含）在 OpenAPI `x-` 扩展中声明。SSaC 规范中只声明业务参数。代码生成器读取 `x-` 并自动配置 `QueryOpts`。

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

## 许可证

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
