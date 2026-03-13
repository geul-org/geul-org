---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "A CLI that cross-validates 10 SSOTs for consistency and generates code. Filling the cracks of vibe coding with structure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — A CLI that cross-validates 10 SSOTs for consistency and generates code in one pass.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub Repository</a>

## The Cracks in Vibe Coding

As vibe coding has gone mainstream, a pattern has emerged.

Tell an AI "build a reservation feature" and it builds one. Say "add a cancellation feature" and it adds one. By the fifth feature, the second one breaks. You changed the API schema but the frontend wasn't updated. You added a DB column but the service layer doesn't know about it.

The cause is simple. The AI cannot remember the entire codebase.

So here's what people do: when they find something broken, they tell the AI "fix this too." It fixes it, and something else breaks. "Fix that too." This loop repeats. As the project grows, the loop gets longer, until at some point it becomes "it'd be faster to start over from scratch."

## Why Code Gets Large

Code contains two things mixed together.

**Decisions**: what to display, which API to call, in what order to process, what to store.
**Wiring**: the code that implements those decisions in a specific framework.

Say you're building a reservation system.

```
Decision: "On reservation cancellation: auth check → lookup → state transition validation → refund calculation → status change → response"
```

This single line of decision gets scattered across React hooks, Go handlers, SQL queries, API schemas, and Terraform resources. Each gets wrapped in framework-specific syntax, with error handling and type conversions piled on.

Out of 100,000 lines of code, decisions account for 12,500 lines. The remaining 87,500 lines are wiring.

AI agents have a finite context window. When adding the tenth feature, they can't remember the previous nine. Because they can't read 100,000 lines all at once.

Separate just the decisions and you get 12,500 lines. That's 55% of a 200K token context. Small enough for an AI to read in one pass.

## 10 SSOTs

Fullend separates all software decisions into 10 declarative specifications. Each specification becomes the Single Source of Truth (SSOT) for its concern.

| Concern | SSOT | Declares |
|---|---|---|
| Project config | fullend.yaml | Tech stack, middleware, module paths |
| UI | [STML](/dsl/stml/) (HTML5 + data-*) | What to show and what to do |
| API contract | OpenAPI 3.x | What requests to accept and what responses to return |
| Service flow | [SSaC](/dsl/ssac/) (.ssac DSL) | In what order to process |
| Data structure | SQL DDL + sqlc | What to store |
| External functions | Func Spec (Go) | Interface and implementation for custom logic |
| State transitions | Mermaid stateDiagram | What states a resource goes through |
| Auth policy | OPA Rego | Who can do what |
| Scenarios | Gherkin (.feature) | Cross-endpoint business flow verification |
| Infrastructure | Terraform HCL | Where to run it |

OpenAPI, SQL DDL, and Terraform are industry standards. The remaining concerns had no corresponding SSOT DSL. Service flows were scattered across Go handlers, UI decisions were buried in React hooks, state transitions were hidden in if-else branches, and permissions were hardcoded in middleware. So we designed STML, SSaC, Func Spec, stateDiagram integration, OPA integration, and Gherkin integration. These are DSLs and integrations created in this project.

```
specs/my-project/
├── fullend.yaml             → Project config
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc queries
├── service/**/*.ssac        → SSaC (.ssac extension)
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` is the truth. `artifacts/` can be regenerated at any time.

## Per-Layer Validation Already Exists

Validation tools for individual layers already exist.

- sqlc checks consistency between DDL and queries.
- OpenAPI validators check schema validity.
- Terraform checks HCL syntax and dependencies.

We also built built-in validators for STML and SSaC. SSaC checks the internal consistency of service flows, and STML checks alignment between UI declarations and OpenAPI.

Each SSOT can be validated within itself. The problems occur **between** them.

The frontend displays a field with `data-bind="memo"`, but the API response schema has no `memo`. SSaC calls `@delete Reservation.SoftDelete(request.ReservationID)`, but there's no `SoftDelete` method in sqlc queries. The state diagram defines a `PublishCourse` transition, but there's no corresponding SSaC function. An OPA policy looks up ownership of the `course` resource via `courses.instructor_id`, but the DDL has no such column.

Individual tools only see their own layer. The cracks between layers remain invisible.

## Hiding the Structure

"But don't I still need to learn 10 DSLs?"

Yes. But the structure doesn't need to be exposed to the user.

If you preload the tech stack and SSOT rules into the agent's system prompt, the user just says "build a reservation feature." The agent automatically adds endpoints to OpenAPI, creates tables in DDL, declares service flows in SSaC, draws state diagrams, writes OPA policies, builds UI in STML, and runs `fullend validate` to check consistency.

All the user sees is the result. The structure is consumed by the agent, not something the user needs to learn.

The vibe coding experience stays the same. What changes is that things don't break behind the scenes.

## What Fullend Does

Fullend is a cross-validator. It doesn't reinvent individual tools. It invokes each tool and inspects the boundaries between SSOTs.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

It validates each of the 10 SSOTs individually, then cross-validates them. Func is validated only when the `func/` directory exists. Use `--skip` to exclude specific SSOTs.

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

If any check fails:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

Once validation passes, it generates code. The `--skip` option works the same as with validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc generates DB models, oapi-codegen generates API types, SSaC generates gin handlers, STML generates React components, state machine packages and OPA Authorizer are generated, Hurl tests are generated from Gherkin, and Fullend generates the glue code that connects them all.

### gen-model

Generates Go model files (interface + types + HTTP client) from an external OpenAPI document. Accepts a local file or URL as input.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

Traces all SSOT nodes connected to a single API operation. Given one operationId, it outputs a file:line map across all layers.

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

Shows a summary of detected SSOTs.

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

## Built-in Functions and Models

Fullend ships with commonly used function implementations and model interfaces. They can be invoked via `@call` in SSaC.

### Default Functions (pkg/)

| Package | Function | Description |
|---|---|---|
| `auth` | `hashPassword` | bcrypt password hashing |
| `auth` | `verifyPassword` | bcrypt password verification |
| `auth` | `issueToken` | JWT access token generation (24h) |
| `auth` | `verifyToken` | JWT token verification + claims extraction |
| `auth` | `refreshToken` | Refresh token generation (7 days) |
| `auth` | `generateResetToken` | Random hex token for password reset |
| `crypto` | `encrypt` | AES-256-GCM symmetric encryption |
| `crypto` | `decrypt` | AES-256-GCM decryption |
| `crypto` | `generateOTP` | TOTP secret + QR provisioning URL |
| `crypto` | `verifyOTP` | TOTP code verification |
| `storage` | `uploadFile` | S3-compatible file upload |
| `storage` | `deleteFile` | S3-compatible file deletion |
| `storage` | `presignURL` | S3 presigned download URL |
| `mail` | `sendEmail` | SMTP plain-text email |
| `mail` | `sendTemplateEmail` | Go template HTML email (SMTP) |
| `text` | `generateSlug` | Unicode → URL-safe slug |
| `text` | `sanitizeHTML` | XSS-safe HTML sanitization |
| `text` | `truncateText` | Unicode-safe text truncation |
| `image` | `ogImage` | OG image generation (1200x630, PNG) |
| `image` | `thumbnail` | Thumbnail generation (200x200, PNG) |

Place an implementation with the same name in `specs/<project>/func/<pkg>/` to override.

### Built-in Models (pkg/)

Package-prefixed @model interfaces for non-relational I/O not defined via DDL. Configure the backend in `fullend.yaml`.

| Package | Interface | Backend | SSaC Usage |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (Generated)

Fullend generates a project-specific `internal/middleware/bearerauth.go` from the claims configuration in `fullend.yaml`.

| Middleware | Trigger | Description |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | Extracts `*model.CurrentUser` from JWT and sets it in the gin context |

Route groups are determined by the OpenAPI `security` field. Operations with `security: [{bearerAuth: []}]` go to the auth group; operations without it go to the public group.

## Cross-Validation Rules

Fullend's unique value lies in cross-validation. After individual tools validate their own layers, Fullend catches inconsistencies between SSOTs.

**fullend.yaml ↔ OpenAPI**

| Target | Rule |
|---|---|
| Middleware name | Does it match a securitySchemes key? |

**OpenAPI ↔ DDL**

| Target | Rule |
|---|---|
| x-sort.allowed | Does the column exist in the table? |
| x-sort ↔ DDL index | Does the column have an index? (WARNING) |
| x-filter.allowed | Does the column exist in the table? |
| x-include.allowed | Is it a table connected via FK? |

**SSaC ↔ DDL**

| Target | Rule |
|---|---|
| Model.Method | Does the method exist in sqlc queries? |
| @result Type | Does it match a type derived from DDL tables? |
| Argument fields | Can they be mapped to DDL columns? |

**SSaC ↔ OpenAPI**

| Target | Rule |
|---|---|
| Function name | Does it match an operationId? |
| request arguments | Do the fields exist in the request schema? |
| @response fields | Do the fields exist in the response schema? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**

| Target | Rule |
|---|---|
| Transition event | Does it match an SSaC function name? |
| Transition event | Does it match an OpenAPI operationId? |
| SSaC @state | Does the referenced stateDiagram exist? |
| @state field | Does it exist as a DDL column? |

**Policy ↔ SSaC ↔ DDL ↔ States**

| Target | Rule |
|---|---|
| allow (action, resource) | Does it match SSaC @auth? |
| @ownership table.column | Does it exist in DDL? |
| @ownership via join | Does the join table FK exist in DDL? |
| State transition event | Is there a matching Rego rule for transitions with @auth? |

**Func ↔ SSaC**

| Target | Rule |
|---|---|
| @call reference | Does a corresponding Func implementation exist? |
| Argument count | Does the number of @call arguments match the Request field count? |
| Argument types | Do positional types match via DDL/OpenAPI? |
| Result/response | Is result/response consistent? |
| Function body | Is it not a TODO stub? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**

| Target | Rule |
|---|---|
| operationId | Does it exist in OpenAPI? |
| HTTP method | Does it match the OpenAPI method? |
| JSON fields | Do they exist in the request schema? |
| Step order | Does it follow state transition rules? |

**Queue (Pub/Sub)**

| Target | Rule |
|---|---|
| @publish topic | Is there a matching @subscribe function? |
| payload/message fields | Are they consistent? |
| queue config | Does fullend.yaml have a queue config? |

**STML ↔ SSaC** — Both reference the same OpenAPI operationId. If both validations pass, consistency between the API the frontend calls and the API the backend handles is automatically guaranteed.

## Runtime Testing

`fullend gen` generates [Hurl](https://hurl.dev) tests from OpenAPI specs and Gherkin scenarios.

```bash
# After starting the server:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

Generated tests:

- **smoke.hurl** — OpenAPI endpoint smoke tests (auto-generated)
- **scenario-*.hurl** — Business scenario tests (generated from .feature files)
- **invariant-*.hurl** — Cross-endpoint invariant tests (generated from .feature files)

## Designed for Agents

Fullend is designed for AI agents.

For an agent to write specs, it needs to know SSaC's 10 sequence types, STML's data-* attributes, OpenAPI x- extensions, stateDiagram rules, OPA policy patterns, Gherkin scenario syntax, Func Spec rules, and name matching rules. To support this, we provide an approximately 830-line manual for AI. It goes into the agent's system prompt once.

The validation loop after writing specs is straightforward.

```
Agent Workflow:
1. Modify specs/
2. fullend validate specs/my-project
3. If errors → fix the relevant SSOT → go to 2
4. Zero errors → fullend gen specs/my-project artifacts/my-project
```

No need to understand the entire system. Just fix what validate points to and consistency is restored. A smart model gets it right in one try; a smaller model gets it in three. The result is the same.

## SSOT Size by Scale

| Scale | Example | SSOT | Implementation Code | Context Usage |
|---|---|---|---|---|
| Small | Salon booking | ~1,500 lines | ~10K lines | ~8% |
| Medium | Jira/Notion-class | ~12,500 lines | ~100K lines | ~55% |
| Large | Shopify-class | ~30,000 lines | ~300K lines | ~90% |

Based on a 200K token context. Up to a medium-sized SaaS, an agent can read the entire design in one pass.

## Patternizing Exceptions

What can't be handled by the 10 sequence types falls through to `@call`. What can't be handled by data-* attributes falls through to `custom.ts`. If these escape hatches exceed 20% of the total, the value of structuring diminishes.

But exceptions become observable the moment they are isolated. As more projects are structured with Fullend, recurring patterns in `@call` and `custom.ts` will emerge.

SSaC's 10 sequence types were not designed from the start. They converged to 10 after observing hundreds of service code implementations. We expect the same principle to repeat with escape hatches. Frequently appearing `@call` patterns become new sequence types, and frequently appearing `custom.ts` patterns become new data-* attributes.

Exceptions don't shrink — structure grows from exceptions.

## Tech Stack Expansion

Currently, Fullend is fixed to Go(gin) + React + PostgreSQL + Terraform. This is intentional. At the PoC stage, it's more important to cut through one stack end to end first.

However, many of the 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) are already language-independent. SSaC's 10 sequence types are language-agnostic patterns — they just happen to be expressed as Go comments. STML uses HTML5 data-* attributes, making it framework-agnostic.

Expansion is a matter of adding code generation backends. The validation logic and cross-validation rules remain unchanged.

## Relationship with GEUL

The 10 SSOTs comprise all decisions of a software system. SSOTs are structured data. Structured data is a graph. Graphs can be encoded in GEUL.

STML's `data-fetch="ListReservations"` is a relationship between entities. SSaC's `@get → @empty → @state → @call → @put → @response` is an event sequence. stateDiagram transitions are state graphs. OPA policies are permission relationships. OpenAPI endpoint definitions are contracts. All of these are semantic structures that can be represented using GEUL's triple edges, event6 edges, and entity nodes.

The way Fullend performs cross-validation across 10 SSOTs — symbolic matching, type consistency checks, referential integrity verification — operates on the same principle as mechanical verification in GEUL streams.

## License

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
