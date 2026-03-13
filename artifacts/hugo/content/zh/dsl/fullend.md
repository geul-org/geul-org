---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "交叉验证10个SSOT并生成代码的CLI。用结构填补氛围编程的裂缝。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — 一次性交叉验证10个SSOT并生成代码的CLI。

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub 仓库</a>

## 氛围编程的裂缝

随着氛围编程（vibe coding）的普及，一个模式开始浮现。

让 AI "做一个预约功能"，它做了。说"加个取消功能"，它也加了。到第五个功能时，第二个功能坏了。改了 API 模式却没改前端。加了数据库字段，服务层却不知道。

原因很简单：AI 无法记住整个代码库。

于是人们这样做：发现哪里坏了，就告诉 AI "这个也修一下"。修好了，别的地方又坏了。"那个也修一下。"这个循环不断重复。项目越大，循环越长，直到某个时刻变成"还不如从头再来"。

## 代码为什么会膨胀

代码里混合着两样东西。

**决策**：展示什么、调用哪个 API、按什么顺序处理、存储什么。
**布线**：在特定框架中实现这些决策的代码。

假设你要做一个预约系统。

```
决策："取消预约时检查权限 → 查询 → 验证状态转移 → 计算退款 → 变更状态 → 响应"
```

这一行决策分散到 React 钩子、Go 处理器、SQL 查询、API 模式和 Terraform 资源中。每一处都被各自框架的语法包裹，再加上错误处理和类型转换。

10 万行代码中，决策只有 12,500 行。剩下的 87,500 行是布线。

AI 代理的上下文窗口是有限的。添加第十个功能时，它记不住前面的九个。因为它无法一次读完 10 万行。

把决策分离出来就是 12,500 行，占 200K token 上下文的 55%。AI 一次就能读完的大小。

## 10个SSOT

Fullend 将软件的所有决策分离为10个声明式规范。每个规范成为其所属关注点的单一真实来源（SSOT）。

| 关注点 | SSOT | 声明内容 |
|---|---|---|
| 项目设置 | fullend.yaml | 技术栈、中间件、模块路径 |
| 界面 | [STML](/zh/dsl/stml/) (HTML5 + data-*) | 展示什么、做什么 |
| API 契约 | OpenAPI 3.x | 接收什么请求、返回什么响应 |
| 服务流程 | [SSaC](/zh/dsl/ssac/) (.ssac DSL) | 按什么顺序处理 |
| 数据结构 | SQL DDL + sqlc | 存储什么 |
| 外部函数 | Func Spec (Go) | 自定义逻辑的接口与实现 |
| 状态转移 | Mermaid stateDiagram | 资源经历哪些状态 |
| 权限策略 | OPA Rego | 谁可以做什么 |
| 场景 | Gherkin (.feature) | 端点间业务流程验证 |
| 基础设施 | Terraform HCL | 在哪里运行 |

OpenAPI、SQL DDL 和 Terraform 是行业标准。其余关注点此前没有对应的 SSOT DSL。服务流程分散在 Go 处理器中，界面决策埋在 React 钩子里，状态转移隐藏在 if-else 分支中，权限硬编码在中间件里。因此设计了 STML、SSaC、Func Spec、stateDiagram 集成、OPA 集成和 Gherkin 集成。这是本项目创建的 DSL 和集成。

```
specs/my-project/
├── fullend.yaml             → 项目设置
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc queries
├── service/**/*.ssac        → SSaC（.ssac 扩展名）
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` 是真实来源。`artifacts/` 随时可以重新生成。

## 单独验证已经存在

多个层级的验证工具已经存在。

- sqlc 检查 DDL 和查询的一致性。
- OpenAPI 验证器检查模式的有效性。
- Terraform 检查 HCL 的语法和依赖关系。

STML 和 SSaC 也各自创建了内置验证器。SSaC 检查服务流程的内部一致性，STML 检查 UI 声明与 OpenAPI 的对齐。

每个 SSOT 都能在自身范围内验证。问题发生在 SSOT **之间**。

前端用 `data-bind="memo"` 显示一个字段，但 API 响应模式里没有 `memo`。SSaC 调用 `@delete Reservation.SoftDelete(request.ReservationID)`，但 sqlc 查询里没有 `SoftDelete` 方法。状态图中定义了 `PublishCourse` 转移，但 SSaC 中没有对应的函数。OPA 策略通过 `courses.instructor_id` 查询 `course` 资源的所有权，但 DDL 中没有该字段。

单独的工具只看自己的层级。层级之间的裂缝看不到。

## 隐藏结构

"但还是得学10种 DSL 吧？"

没错。但结构不需要展示给用户。

在代理的系统提示中预先嵌入技术栈和 SSOT 规则，用户只需说"做一个预约功能"。代理会自动在 OpenAPI 中添加端点、在 DDL 中创建表、在 SSaC 中声明服务流程、绘制状态图、编写 OPA 策略、在 STML 中绘制界面，然后运行 `fullend validate` 验证一致性。

用户看到的只是结果。结构是代理消费的东西，不是用户需要学习的东西。

氛围编程的体验不变。变的是幕后不再崩坏。

## Fullend 的角色

Fullend 是交叉验证器。它不重新发明已有工具，而是调用各个工具并检查 SSOT 间的边界。

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

先对10个 SSOT 进行单独验证，再进行交叉验证。Func 仅在存在 `func/` 目录时才验证。可以用 `--skip` 排除特定 SSOT。

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

如果有任何失败：

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

验证通过后生成代码。`--skip` 选项与 validate 用法相同。

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc 生成数据库模型，oapi-codegen 生成 API 类型，SSaC 生成 gin 处理器，STML 生成 React 组件，状态机包和 OPA Authorizer 被生成，从 Gherkin 生成 Hurl 测试，Fullend 生成将它们串联在一起的胶水代码。

### gen-model

从外部 OpenAPI 文档生成 Go 模型文件（接口 + 类型 + HTTP 客户端）。支持本地文件或 URL 作为输入。

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

追踪与某个 API 操作关联的所有 SSOT 节点。输入一个 operationId，输出所有层级的 file:line 映射。

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

显示检测到的 SSOT 的概要状态。

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## 内置函数与模型

Fullend 内置了常用的函数实现和模型接口。可通过 SSaC 的 `@call` 调用。

### Default Functions (pkg/)

| 包 | 函数 | 说明 |
|---|---|---|
| `auth` | `hashPassword` | bcrypt 密码哈希 |
| `auth` | `verifyPassword` | bcrypt 密码验证 |
| `auth` | `issueToken` | JWT 访问令牌生成（24h） |
| `auth` | `verifyToken` | JWT 令牌验证 + 声明提取 |
| `auth` | `refreshToken` | 刷新令牌生成（7天） |
| `auth` | `generateResetToken` | 密码重置用随机 hex 令牌 |
| `crypto` | `encrypt` | AES-256-GCM 对称加密 |
| `crypto` | `decrypt` | AES-256-GCM 解密 |
| `crypto` | `generateOTP` | TOTP 密钥 + QR 配置 URL |
| `crypto` | `verifyOTP` | TOTP 代码验证 |
| `storage` | `uploadFile` | S3 兼容文件上传 |
| `storage` | `deleteFile` | S3 兼容文件删除 |
| `storage` | `presignURL` | S3 presigned 下载 URL |
| `mail` | `sendEmail` | SMTP 纯文本邮件 |
| `mail` | `sendTemplateEmail` | Go 模板 HTML 邮件（SMTP） |
| `text` | `generateSlug` | Unicode → URL-safe slug |
| `text` | `sanitizeHTML` | XSS 防护 HTML 清理 |
| `text` | `truncateText` | Unicode 安全文本截断 |
| `image` | `ogImage` | OG 图片生成（1200x630，PNG） |
| `image` | `thumbnail` | 缩略图生成（200x200，PNG） |

在项目中将同名实现放在 `specs/<project>/func/<pkg>/` 下即可覆盖。

### Built-in Models (pkg/)

用于不通过 DDL 定义的非关系型 I/O 的包前缀 @model 接口。在 `fullend.yaml` 中配置后端。

| 包 | 接口 | 后端 | SSaC 用法 |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware（生成）

Fullend 根据 `fullend.yaml` 的 claims 配置为每个项目生成 `internal/middleware/bearerauth.go`。

| 中间件 | 触发条件 | 说明 |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | 从 JWT 提取 `*model.CurrentUser` 并设置到 gin 上下文 |

OpenAPI `security` 字段决定路由分组。有 `security: [{bearerAuth: []}]` 的操作归入 auth 组，没有的归入 public 组。

## 交叉验证规则

Fullend 的核心价值在于交叉验证。各个工具验证自己的层级后，Fullend 捕获 SSOT 之间的不一致。

**fullend.yaml ↔ OpenAPI**

| 验证对象 | 规则 |
|---|---|
| 中间件名称 | 是否与 securitySchemes 键匹配 |

**OpenAPI ↔ DDL**

| 验证对象 | 规则 |
|---|---|
| x-sort.allowed | 该字段是否存在于表中 |
| x-sort ↔ DDL index | 该字段是否有索引 (WARNING) |
| x-filter.allowed | 该字段是否存在于表中 |
| x-include.allowed | 是否为通过 FK 关联的表 |

**SSaC ↔ DDL**

| 验证对象 | 规则 |
|---|---|
| Model.Method | sqlc 查询中是否存在该方法 |
| @result Type | 是否与从 DDL 表派生的类型匹配 |
| 参数字段 | 能否转换为 DDL 字段 |

**SSaC ↔ OpenAPI**

| 验证对象 | 规则 |
|---|---|
| 函数名 | 是否与 operationId 匹配 |
| request 参数 | 请求模式中是否存在该字段 |
| @response 字段 | 响应模式中是否存在该字段 |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**

| 验证对象 | 规则 |
|---|---|
| 转移事件 | 是否与 SSaC 函数名匹配 |
| 转移事件 | 是否与 OpenAPI operationId 匹配 |
| SSaC @state | 引用的 stateDiagram 是否存在 |
| @state 字段 | 是否作为 DDL 字段存在 |

**Policy ↔ SSaC ↔ DDL ↔ States**

| 验证对象 | 规则 |
|---|---|
| allow (action, resource) | 是否与 SSaC @auth 匹配 |
| @ownership table.column | 是否存在于 DDL 中 |
| @ownership via join | 连接表 FK 是否存在于 DDL 中 |
| 状态转移事件 | 带 @auth 的转移是否有匹配的 Rego 规则 |

**Func ↔ SSaC**

| 验证对象 | 规则 |
|---|---|
| @call 引用 | 是否有对应的 Func 实现 |
| 参数数量 | @call 参数与 Request 字段数量是否一致 |
| 参数类型 | 各位置的类型是否通过 DDL/OpenAPI 匹配 |
| 结果/响应 | result/response 是否一致 |
| 函数体 | 是否为 TODO 存根 (WARNING) |

**Scenario ↔ OpenAPI ↔ States**

| 验证对象 | 规则 |
|---|---|
| operationId | 是否存在于 OpenAPI 中 |
| HTTP method | 是否与 OpenAPI 方法一致 |
| JSON 字段 | 是否存在于请求模式中 |
| 步骤顺序 | 是否遵循状态转移规则 |

**Queue (Pub/Sub)**

| 验证对象 | 规则 |
|---|---|
| @publish topic | 是否有匹配的 @subscribe 函数 |
| payload/message 字段 | 是否一致 |
| queue 配置 | fullend.yaml 中是否有 queue config |

**STML ↔ SSaC** — 两者都引用相同的 OpenAPI operationId。如果双方验证都通过，前端调用的 API 和后端处理的 API 自动保证一致。

## 运行时测试

`fullend gen` 从 OpenAPI 规范和 Gherkin 场景生成 [Hurl](https://hurl.dev) 测试。

```bash
# 启动服务器后：
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

生成的测试：

- **smoke.hurl** — OpenAPI 端点冒烟测试（自动生成）
- **scenario-*.hurl** — 业务场景测试（从 .feature 文件生成）
- **invariant-*.hurl** — 端点间不变式测试（从 .feature 文件生成）

## 为代理而设计

Fullend 是为 AI 代理设计的。

代理要编写 spec，需要了解 SSaC 的10种序列类型、STML 的 data-* 属性、OpenAPI x- 扩展、stateDiagram 规则、OPA 策略模式、Gherkin 场景语法、Func Spec 规则以及命名匹配规则。为此提供了约830行的 AI 手册，只需在代理的系统提示中添加一次即可。

编写 spec 后的验证循环很简单。

```
代理工作流：
1. 修改 specs/
2. fullend validate specs/my-project
3. 有错误 → 修改对应 SSOT → 回到第2步
4. 零错误 → fullend gen specs/my-project artifacts/my-project
```

不需要理解整个系统。只需修复 validate 指出的问题，一致性就会恢复。聪明的模型一次就对，小模型三次就对。结果一样。

## 各规模的 SSOT 大小

| 规模 | 示例 | SSOT | 实现代码 | 上下文占用率 |
|---|---|---|---|---|
| 小型 | 美发店预约 | ~1,500 行 | ~1 万行 | ~8% |
| 中型 | Jira、Notion 级 | ~12,500 行 | ~10 万行 | ~55% |
| 大型 | Shopify 级 | ~30,000 行 | ~30 万行 | ~90% |

基于 200K token 上下文。中型 SaaS 以下，代理可以一次读完整个设计。

## 将例外模式化

10种序列类型处理不了的用 `@call` 兜底。data-* 属性处理不了的用 `custom.ts` 兜底。如果这些逃逸出口超过整体的 20%，结构化就失去了意义。

但例外一旦被隔离，就变得可观察。当许多项目用 Fullend 进行结构化后，`@call` 和 `custom.ts` 中反复出现的模式就会浮现。

SSaC 的10种序列类型也不是一开始就设计好的。它们是在观察了数百个服务代码后收敛到10种的。同样的原理预计会在逃逸出口中重复。频繁出现的 `@call` 模式会成为新的序列类型，频繁出现的 `custom.ts` 模式会成为新的 data-* 属性。

不是例外在减少，而是结构从例外中生长。

## 技术栈扩展

目前 Fullend 固定为 Go(gin) + React + PostgreSQL + Terraform。这是有意为之。在 PoC 阶段，先彻底贯穿一个技术栈。

但10个 SSOT 中相当一部分（OpenAPI、SQL DDL、Terraform、Mermaid、OPA Rego、Gherkin）已经是语言无关的。SSaC 的10种序列类型是不依赖语言的模式 — 只是用 Go 注释来表达而已。STML 使用 HTML5 data-* 属性，与框架无关。

扩展只是添加代码生成后端的问题。验证逻辑和交叉验证规则保持不变。

## 与 GEUL 的关系

10个 SSOT 构成软件的全部决策。SSOT 是结构化数据。结构化数据是图。图可以用 GEUL 编码。

STML 的 `data-fetch="ListReservations"` 是实体间的关系。SSaC 的 `@get → @empty → @state → @call → @put → @response` 是事件序列。stateDiagram 的转移是状态图。OPA 策略是权限关系。OpenAPI 的端点定义是契约。这些都是可以用 GEUL 的三元组边、事件6边和实体节点表达的语义结构。

Fullend 在10个 SSOT 之间执行交叉验证的方式 — 符号匹配、类型一致性检查、引用完整性验证 — 与 GEUL 流中的机械验证基于同一原理。

## 许可证

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
