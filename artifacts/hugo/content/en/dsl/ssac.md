---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "A single Go comment is one sequence. 10 fixed sequence types cover every binary branch in the service layer, and symbolic codegen produces gin handlers."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — a single Go comment is one sequence. Declare it and a gin handler is generated.

Service logic is a series of decisions: which model to query, what to guard against, when to reject, what to return. These decisions belong to the person who understands the business — but they get buried in boilerplate, scattered across layers, and lost in rewrites.

SSaC preserves these decisions as a declarative spec. Declare **what** happens and **in what order**, one line at a time, and the tool generates the implementation.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (comment DSL)        (validation)      (codegen)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub Repository</a>

## Core Idea

Every service function is a sequence of steps. Each step follows a binary contract: **succeed → next line, fail → return**. This is not an abstraction we invented — it is how service logic already works. SSaC makes it explicit.

10 fixed sequence types cover every service-layer operation that follows this contract. Anything that does not fit is delegated to `@call`. The set is closed by design.

No LLM, no inference — pure symbolic codegen from templates. The spec is the single source of truth.

## Syntax — One Line, One Sequence

Starting from v2, each sequence is a single comment line. Only `@response` uses a multi-line block.

**CRUD — Model Operations**

```go
// @get Type var = Model.Method(args...)        — read (result required)
// @post Type var = Model.Method(args...)       — create (result required)
// @put Model.Method(args...)                   — update (no result)
// @delete Model.Method(args...)                — delete (no result)
```

Argument format: `source.Field` or `"literal"`

- `request.CourseID` — from the HTTP request
- `course.InstructorID` — from a previous result variable
- `currentUser.ID` — from the auth context
- `"cancelled"` — string literal

**Guards**

```go
// @empty target "message"                      — fail if nil/zero (404)
// @exists target "message"                     — fail if not nil/zero (409)
```

Target: a variable (`course`) or variable.field (`course.InstructorID`)

**State Transitions**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**Authorization — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**External Calls**

```go
// @call Type var = package.Func(args...)       — with result
// @call package.Func(args...)                  — without result
```

**Response — Field Mapping Block**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## Example

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "unauthorized"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "reservation not found"
// @state reservation {status: reservation.Status} "cancel" "cannot cancel"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

10-line declaration. Each line is one sequence, executed top to bottom in order. Auth → read → guard → state transition → external call → update → re-read → response.

## Sequence Types (10)

| Type | Role |
|---|---|
| `@auth` | Authorization check (OPA policy) |
| `@get` | Resource read |
| `@empty` | Exit if nil/zero (404) |
| `@exists` | Exit if not nil/zero (409) |
| `@post` | Resource creation |
| `@put` | Resource update |
| `@delete` | Resource deletion |
| `@state` | State transition validation |
| `@call` | External package function call |
| `@response` | Return response (field mapping) |

## Validation

Internal validation (always):
- Missing required arguments per type
- `Model.Method` format
- Variable flow (reference before declaration)

External SSOT cross-validation (when project structure is detected):
- Model/method existence (sqlc queries, Go interfaces)
- Request/response field existence (OpenAPI)
- Package/function existence (Go interfaces)
- Stale data warning: response after put/delete without re-fetch (WARNING)
- State diagram existence and transition validity
- OPA policy file existence

## Codegen Features

When external SSOT (symbol tables) are available, `ssac gen` provides additional features. Generated code uses the gin framework.

- **Type conversion**: DDL column types → `strconv.ParseInt`, `time.Parse`, early 400 Bad Request return
- **Guard value types**: Type-aware zero checks (`int` → `== 0`/`> 0`, pointer → `== nil`/`!= nil`)
- **Model interface derivation**: Cross-reference 3 SSOT sources → `<outDir>/model/models_gen.go`
- **@state codegen**: Calls `CanTransition` from the state diagram package
- **@auth codegen**: Calls `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **@call codegen**: Guard-style (401) when no result, value-style (500) when result exists
- **Domain folder structure**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## OpenAPI x- Extensions

Infrastructure parameters (pagination, sorting, filtering, relation includes) are declared in OpenAPI `x-` extensions. Only business parameters are declared in SSaC specs. The code generator reads `x-` extensions and auto-constructs `QueryOpts`.

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

## License

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub Repository</a>
