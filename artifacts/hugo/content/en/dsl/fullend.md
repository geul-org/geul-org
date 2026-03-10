---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "A CLI that cross-validates 10 SSOTs and generates code. Fills the cracks of vibe coding with structure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — a CLI that cross-validates 10 SSOTs at once and generates code.

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
Decision: "On reservation cancellation: check permissions → look up → validate state transition → calculate refund → change status → respond"
```

This single decision gets scattered across React hooks, Go handlers, SQL queries, API schemas, and Terraform resources. Each gets wrapped in its framework's syntax, with error handling and type conversions piled on.

Out of 100,000 lines of code, decisions account for 12,500. The remaining 87,500 lines are wiring.

AI agents have a finite context window. When adding the tenth feature, they can't remember the first nine. They can't read 100,000 lines at once.

Separate the decisions and you get 12,500 lines. That's 55% of a 200K token context. Small enough for an AI to read in a single pass.

## 10 SSOTs

Fullend separates all software decisions into 10 declarative specs. Each spec becomes the single source of truth (SSOT) for its concern.

| Concern | SSOT | What It Declares |
|---|---|---|
| Project config | fullend.yaml | Tech stack, middleware, module paths |
| UI | [STML](/dsl/stml/) (HTML5 + data-*) | What to show and what to do |
| API contract | OpenAPI 3.x | What requests to accept and what responses to return |
| Service flow | [SSaC](/dsl/ssac/) (Go comment DSL) | In what order to process |
| Data structure | SQL DDL + sqlc | What to store |
| External functions | Func Spec (Go) | Interface and implementation of custom logic |
| State transitions | Mermaid stateDiagram | What states a resource goes through |
| Authorization policy | OPA Rego | Who can do what |
| Scenarios | Gherkin (.feature) | Business flow verification across endpoints |
| Infrastructure | Terraform HCL | Where to run it |

OpenAPI, SQL DDL, and Terraform are industry standards. There was no existing SSOT DSL for the remaining concerns. Service flows were scattered across Go handlers, UI decisions were buried in React hooks, state transitions were hidden in if-else branches, and authorization was hardcoded in middleware. That's why STML, SSaC, Func Spec, stateDiagram integration, OPA integration, and Gherkin integration were designed. These are DSLs and integrations created in this project.

```
specs/my-project/
├── fullend.yaml           → Project config
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
├── func/<pkg>/*.go        → Func Spec
├── states/*.md            → Mermaid stateDiagram
├── policy/*.rego          → OPA Rego
├── scenario/*.feature     → Gherkin
└── terraform/*.tf         → HCL
```

`specs/` is the truth. `artifacts/` can be regenerated at any time.

## Individual Validation Already Exists

Validation tools for multiple layers already exist.

- sqlc checks the consistency between DDL and queries.
- OpenAPI validators check schema validity.
- Terraform checks HCL syntax and dependencies.

Built-in validators were also created for STML and SSaC. SSaC checks the internal consistency of service flows; STML checks alignment between UI declarations and OpenAPI.

Each SSOT can be validated on its own. The problem occurs **between** them.

The frontend displays a field with `data-bind="memo"`, but the API response schema has no `memo`. SSaC calls `@delete Reservation.SoftDelete(request.ReservationID)`, but there's no `SoftDelete` method in the sqlc queries. The state diagram defines a `PublishCourse` transition, but there's no corresponding SSaC function. OPA policy looks up ownership of the `course` resource via `courses.instructor_id`, but the DDL has no such column.

Individual tools only see their own layer. They can't see the cracks between layers.

## Hiding the Structure

"But you still have to learn 10 DSLs, right?"

Yes. But the structure doesn't need to be shown to the user.

If you embed the tech stack and SSOT rules in the agent's system prompt, users only need to say "build a reservation feature." The agent adds the endpoint to OpenAPI, creates the table in DDL, declares the service flow in SSaC, draws the state diagram, writes the OPA policy, draws the screen in STML, and runs `fullend validate` to verify consistency.

Users see only results. Structure is consumed by the agent, not learned by the user.

The vibe coding experience stays the same. What changes is that things stop breaking behind the scenes.

## What Fullend Does

Fullend is a cross-validator. It doesn't reinvent individual tools. It calls each tool and inspects the boundaries between SSOTs.

```bash
fullend validate specs/my-project
```

```
✓ Config       fullend.yaml valid
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✓ SSaC         7 service functions
✓ STML         4 pages, 6 bindings
✓ States       2 diagrams
✓ Policy       3 rules
✓ Scenario     2 features
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

If anything fails:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

Once validation passes, it generates code.

```bash
fullend gen specs/my-project artifacts/my-project
```

sqlc generates DB models, oapi-codegen generates API types, SSaC generates gin handlers, STML generates React components, state machine packages and OPA Authorizer are generated, Hurl tests are generated from Gherkin, and Fullend generates the glue code that ties them together.

## Cross-Validation Rules

Fullend's unique value lies in cross-validation. After individual tools validate their own layers, Fullend catches mismatches between SSOTs.

**OpenAPI ↔ DDL**

| Target | Rule |
|---|---|
| x-sort.allowed | Does the column exist in the table? |
| x-sort ↔ DDL index | Does the column have an index? (WARNING) |
| x-filter.allowed | Does the column exist in the table? |
| x-include.allowed | Is it a table connected by FK? |

**SSaC ↔ DDL**

| Target | Rule |
|---|---|
| Model.Method | Does the method exist in sqlc queries? |
| @result Type | Does it match the type derived from the DDL table? |
| Argument fields | Can they be mapped to DDL columns? |

**SSaC ↔ OpenAPI**

| Target | Rule |
|---|---|
| Function name | Does it match an operationId? |
| request arguments | Does the field exist in the request schema? |
| @response fields | Does the field exist in the response schema? |

**States ↔ SSaC ↔ OpenAPI**

| Target | Rule |
|---|---|
| Transition event | Does it match an SSaC function name? |
| Transition event | Does it match an OpenAPI operationId? |
| SSaC @state | Does the referenced stateDiagram exist? |
| @state field | Does it exist as a DDL column? |

**Policy ↔ SSaC ↔ DDL**

| Target | Rule |
|---|---|
| allow (action, resource) | Does it match SSaC @auth? |
| @ownership table.column | Does it exist in DDL? |
| @ownership via join | Does the join table FK exist in DDL? |

**Func ↔ SSaC**

| Target | Rule |
|---|---|
| @call reference | Does a corresponding Func implementation exist? |
| Argument count/type | Do @call arguments match Request fields? |
| Function body | Is it not a TODO stub? (WARNING) |

**Scenario ↔ OpenAPI**

| Target | Rule |
|---|---|
| operationId | Does it exist in OpenAPI? |
| HTTP method | Does it match the OpenAPI method? |
| JSON fields | Do they exist in the request schema? |

**STML ↔ SSaC** — Both reference the same OpenAPI operationId. If both validations pass, the API called by the frontend and the API handled by the backend are guaranteed to match automatically.

## Designed for Agents

Fullend was designed for AI agents.

For an agent to write specs, it needs to know SSaC's 10 sequence types, STML's data-* attributes, OpenAPI x- extensions, stateDiagram rules, OPA policy patterns, Gherkin scenario syntax, Func Spec rules, and name matching rules. A roughly 830-line manual for AI is provided for this. It only needs to be added to the agent's system prompt once.

The validation loop after writing specs is straightforward.

```
Agent workflow:
1. Modify specs/
2. fullend validate specs/my-project
3. If errors → fix the relevant SSOT → go to 2
4. Zero errors → fullend gen specs/my-project artifacts/my-project
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

What 10 sequence types can't handle falls through to `@call`. What data-* attributes can't handle falls through to `custom.ts`. If these escape hatches exceed 20% of the total, structuring loses its point.

But exceptions become observable the moment they are isolated. As many projects adopt Fullend, recurring patterns will emerge in `@call` and `custom.ts`.

SSaC's 10 sequence types weren't designed from scratch. They converged to 10 after observing hundreds of service code examples. The same principle is expected to repeat for escape hatches. Frequently appearing `@call` patterns become new sequence types; frequently appearing `custom.ts` patterns become new data-* attributes.

Exceptions don't shrink — structure grows from them.

## Tech Stack Expansion

Currently, Fullend is fixed to Go(gin) + React + PostgreSQL + Terraform. This is intentional. At the PoC stage, fully penetrating one stack comes first.

However, many of the 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) are already language-independent. SSaC's 10 sequence types are language-agnostic patterns — they're merely expressed as Go comments. STML uses HTML5 data-* attributes and is framework-independent.

Expansion is a matter of adding code generation backends. The validation logic and cross-validation rules remain unchanged.

## Relationship to GEUL

The 10 SSOTs compose all decisions of software. An SSOT is structured data. Structured data is a graph. A graph can be encoded in GEUL.

STML's `data-fetch="ListReservations"` is a relationship between entities. SSaC's `@get → @empty → @state → @call → @put → @response` is an event sequence. stateDiagram transitions are state graphs. OPA policies are authorization relationships. OpenAPI's endpoint definitions are contracts. All of these are semantic structures expressible as GEUL's triple edges, event6 edges, and entity nodes.

The way Fullend performs cross-validation across 10 SSOTs — symbolic matching, type consistency checks, referential integrity verification — operates on the same principle as mechanical verification in GEUL streams.

## License

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub Repository</a>
