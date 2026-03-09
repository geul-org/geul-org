---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Declare service logic in Go comments and generate implementation code. 10 fixed sequence types cover all binary-contract operations in the service layer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — generate service code from Go comment DSL.

Service logic is a series of decisions: which model to query, what to guard against, when to reject, what to return. These decisions belong to the person who understands the business — but they get buried in boilerplate, scattered across layers, and lost in rewrites.

SSaC preserves these decisions as a declarative spec. You declare **what** happens and **in what order**. The tool generates the implementation.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## Core Idea

Every service function is a sequence of steps. Each step follows a binary contract: **succeed → next line, fail → return**. This is not an abstraction we invented — it's how service logic already works. SSaC makes it explicit.

10 fixed sequence types cover all service-layer operations that follow this contract. If something doesn't fit, delegate it to `call`. The set is closed by design.

No LLM, no inference — pure symbolic codegen from templates. The spec is the source of truth.

## Example

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

This 10-line declaration generates the following code:

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

## Sequence Types (10)

| Type | Role |
|---|---|
| `authorize` | Permission check (OPA, etc.) |
| `get` | Resource lookup |
| `guard nil` | Exit if null |
| `guard exists` | Exit if exists |
| `post` | Resource creation |
| `put` | Resource update |
| `delete` | Resource deletion |
| `password` | Password comparison |
| `call` | External call (@component / @func) |
| `response` | Return response (json) |

## Codegen Features

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

## License

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
