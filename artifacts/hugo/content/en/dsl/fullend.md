---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-09T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "A CLI that cross-validates five SSOTs (STML, OpenAPI, SSaC, SQL DDL, Terraform) and generates code. It fills the cracks of vibe coding with structure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — a CLI that cross-validates five SSOTs at once and generates code.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub Repository</a>

## The Cracks in Vibe Coding

As vibe coding went mainstream, a pattern emerged.

Ask an AI to "build a reservation feature" and it does. Say "add a cancellation feature" and it does. By the fifth feature, the second one breaks. You change the API schema but forget the frontend. You add a DB column but the service layer doesn't know.

The cause is simple: the AI cannot remember the entire codebase.

So here's what people do: when something breaks, they tell the AI "fix this too." It fixes it, and something else breaks. "Fix that too." The loop repeats. As the project grows, the loop gets longer, until eventually "it'd be faster to start from scratch."

## Why Does Code Get So Large?

Code contains two things mixed together.

**Decisions**: what to display, which API to call, in what order to process, what to store.
**Wiring**: the code that implements those decisions in a specific framework.

Say you're building a reservation system.

```
Decision: "When creating a reservation, look up the room. If not found, return 404. If found, create it."
```

This single decision gets scattered across React hooks, Go handlers, SQL queries, API schemas, and Terraform resources. Each gets wrapped in its framework's syntax, with error handling and type conversions piled on.

Out of 100,000 lines of code, decisions account for 12,500. The remaining 87,500 lines are wiring.

AI agents have a finite context window. When adding the tenth feature, they can't remember the first nine. They can't read 100,000 lines at once.

Separate the decisions and you get 12,500 lines. That's 55% of a 200K token context. Small enough for an AI to read in a single pass.

## Five SSOTs

Fullend maps one DSL to each of the five layers that make up software. Each DSL becomes the single source of truth (SSOT) for its layer.

| Layer | DSL | What It Declares |
|---|---|---|
| UI | STML (HTML5 + data-*) | What to show and what to do |
| API Contract | OpenAPI 3.x | What requests to accept and what responses to return |
| Service Flow | SSaC (Go comment DSL) | In what order to process |
| Data Structure | SQL DDL + sqlc | What to store |
| Infrastructure | Terraform HCL | Where to run it |

OpenAPI, SQL DDL, and Terraform are industry standards. There was no existing SSOT DSL for the UI or service flow. Frontend decisions were buried in React hooks; service flows were scattered across Go handlers. That's why [STML](/dsl/stml/) and [SSaC](/dsl/ssac/) were designed. They are DSLs created in this project.

```
specs/
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
└── terraform/*.tf         → HCL
```

`specs/` is the truth. `artifacts/` can be regenerated at any time.

## Individual Validation Already Exists

Validation tools for three layers already exist.

- sqlc checks the consistency between DDL and queries.
- OpenAPI validators check schema validity.
- Terraform checks HCL syntax and dependencies.

Built-in validators were also created for STML and SSaC. SSaC checks the internal consistency of service flows; STML checks alignment between UI declarations and OpenAPI.

Each of the five layers can be validated on its own. The problem occurs **between** them.

The frontend displays a field with `data-bind="memo"`, but the API response schema has no `memo`. SSaC calls `@model Reservation.SoftDelete`, but there's no `SoftDelete` method in the sqlc queries. OpenAPI declares `x-sort: [created_at]`, but the DDL table has no index on that column.

Individual tools only see their own layer. They can't see the cracks between layers.

## Hiding the Structure

"But you still have to learn five DSLs, right?"

Yes. But the structure doesn't need to be shown to the user.

If you embed the tech stack and SSOT rules in the agent's system prompt, users only need to say "build a reservation feature." The agent adds the endpoint to OpenAPI, creates the table in DDL, declares the service flow in SSaC, draws the screen in STML, and runs `fullend validate` to verify consistency.

Users see only results. Structure is consumed by the agent, not learned by the user.

The vibe coding experience stays the same. What changes is that things stop breaking behind the scenes.

## What Fullend Does

Fullend is a cross-validator. It doesn't reinvent individual tools. It calls each tool and inspects the boundaries between layers.

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

If anything fails:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @model Reservation.SoftDelete — method not found in sqlc queries
✗ Cross        1 mismatch

FAILED: Fix errors before codegen.
```

Once validation passes, it generates code.

```bash
fullend gen specs/ artifacts/
```

sqlc generates DB models, oapi-codegen generates API types, SSaC generates service functions, STML generates React components, and Fullend generates the glue code that ties them together.

## Cross-Validation Rules

Fullend's unique value lies in cross-validation.

**OpenAPI <-> DDL**

| Target | Rule |
|---|---|
| x-sort.allowed | Does the column exist in the table? |
| x-filter.allowed | Does the column exist in the table? |
| x-include.allowed | Is it a table connected by FK? |

**SSaC <-> DDL**

| Target | Rule |
|---|---|
| @model Model.Method | Does the method exist in sqlc queries? |
| @result Type | Does it match the type derived from the DDL table? |
| @param name | Can it be mapped to a DDL column? |

**SSaC <-> OpenAPI**

| Target | Rule |
|---|---|
| Function name | Does it match an operationId? |
| @param request | Does the field exist in the request schema? |
| @result + response | Does the field exist in the response schema? |

**STML <-> SSaC** — Both reference the same OpenAPI operationId. If both validations pass, the API called by the frontend and the API handled by the backend are guaranteed to match automatically.

## Designed for Agents

Fullend was designed for AI agents.

For an agent to write specs, it needs to know SSaC's 10 sequence types, STML's 12 data-* attributes, OpenAPI x- extensions, and name matching rules. A roughly 350-line manual for AI is provided for this. It only needs to be added to the agent's system prompt once.

The validation loop after writing specs is straightforward.

```
Agent workflow:
1. Modify specs/
2. fullend validate specs/
3. If errors → fix the relevant SSOT → go to 2
4. Zero errors → fullend gen specs/ artifacts/
```

No need to understand the entire system. Just fix what validate points to and consistency is restored. A smart model gets it right the first time; a smaller model takes three tries. The result is the same.

## SSOT Size by Scale

| Scale | Example | SSOT | Implementation Code | Context Usage |
|---|---|---|---|---|
| Small | Hair salon bookings | ~1,500 lines | ~10K lines | ~8% |
| Medium | Jira/Notion-class | ~12,500 lines | ~100K lines | ~55% |
| Large | Shopify-class | ~30,000 lines | ~300K lines | ~90% |

Based on a 200K token context. Up to a medium-sized SaaS, an agent can read the entire design in one pass.

## Turning Exceptions into Patterns

What 10 sequence types can't handle falls through to `call`. What data-* attributes can't handle falls through to `custom.ts`. If these escape hatches exceed 20% of the total, structuring loses its point.

But exceptions become observable the moment they are isolated. As many projects adopt Fullend, recurring patterns will emerge in `call` and `custom.ts`.

SSaC's 10 sequence types weren't designed from scratch. They converged to 10 after observing hundreds of service code examples. The same principle is expected to repeat for escape hatches. Frequently appearing `call` patterns become new sequence types; frequently appearing `custom.ts` patterns become new data-* attributes.

Exceptions don't shrink — structure grows from them.

## Tech Stack Expansion

Currently, Fullend is fixed to Go + React + PostgreSQL + Terraform. This is intentional. At the PoC stage, fully penetrating one stack comes first.

However, three of the five SSOTs (OpenAPI, SQL DDL, Terraform) are already language-independent. SSaC's 10 sequence types are language-agnostic patterns — they're merely expressed as Go comments. STML uses HTML5 data-* attributes and is framework-independent.

Expansion is a matter of adding code generation backends. The validation logic and cross-validation rules remain unchanged.

## Relationship to GEUL

Five DSLs compose the SSOT of software. An SSOT is structured data. Structured data is a graph. A graph can be encoded in GEUL.

STML's `data-fetch="ListReservations"` is a relationship between entities. SSaC's `@sequence get → @model → @guard → @response` is an event sequence. OpenAPI's endpoint definitions are contracts. All of these are semantic structures expressible as GEUL's triple edges, event6 edges, and entity nodes.

The way Fullend performs cross-validation across five DSLs — symbolic matching, type consistency checks, referential integrity verification — operates on the same principle as mechanical verification in GEUL streams.

## License

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
