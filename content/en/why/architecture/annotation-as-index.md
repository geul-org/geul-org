---
title: "Why Annotations Should Be Indexes"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["index", "annotation", "code", "AST", "design-pattern"]
summary: "Annotations are written for humans. But when you have 10,000 functions, machines need to read them too. Turn annotations from narrative into indexes, and full scans become instant lookups."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Annotations are written for humans.

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

This annotation helps when a human reads it. But when a machine reads it, it learns nothing. It does not know whether "retrieves" means Read or Search. It does not know what entity "user" refers to. It does not know whether this function follows the Service pattern or the Repository pattern.

Because the annotation is narrative.

---

## When You Have 10,000 Functions

When you have 10 functions, it does not matter. A person can read them all.

When you have 10,000 functions, it is different. When someone asks "show me all payment-related functions," neither humans nor machines can find them. They only find the ones with "payment" in the name. If it is not in the name, it gets missed.

The same applies when an AI agent modifies code. If you tell Claude Code to "fix the PaymentFailed error handling," the agent re-reads the entire codebase. Every time. It re-analyzes all 10,000 functions from scratch. It reads the same code today that it read yesterday. Annotations do not help. Because annotations are narrative written for humans. For a machine to extract meaning from narrative, it needs inference. That is expensive.

---

## When Annotations Are Indexes

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

This annotation is readable by both humans and machines.

"All functions with the Service pattern" — search the Pattern field. Instant.
"All functions related to the Order entity" — search the Entity field. Instant.
"Functions that raise PaymentFailed" — search the errs field. Instant.

Full scans become index lookups. O(n) becomes O(1).

---

## No Human Effort Required

Humans do not need to write these indexes.

When code is modified, it is automatically detected. File watching.
The modified function is isolated via AST. Mechanical.
The function body is passed to a small LLM. "Determine this function's pattern, entity, and action."
The result is inserted in a defined format. Mechanical.

Humans do nothing. They just write code. Indexes are attached automatically.

In the entire pipeline, the LLM intervenes at exactly one point — determining the function's semantics. Everything else is deterministic code.

---

## From Inference to Rules

It goes one step further.

When a small LLM repeatedly assigns the same index to the same pattern, the repetition is detected. If "Service suffix with receiver method maps to Pattern:Service" has been repeated 100 times, it solidifies into a rule. The LLM is no longer called. The rule handles it.

LLM calls decrease over time. Rules increase over time. Cost converges to zero.

Annotations shift from narrative to index.
Indexes shift from manual to automatic.
Automatic shifts from inference to rules.

---

## Why This Works: Design Patterns as a Codebook

There is a reason this is possible.

Programming already has a standardized semantic vocabulary. Design patterns.

Singleton, Factory, Observer, MVC, Service. Since the Gang of Four codified 23 patterns in 1994, the software industry has spent 30 years expanding and standardizing this vocabulary.

GoF 23 patterns. Enterprise Application Patterns. Cloud Design Patterns. Go Concurrency Patterns. All already documented.

This vocabulary is unambiguous. Singleton is Singleton. Developers do not interpret it differently. Definitions are agreed upon, implementation conditions are clear, and violations are caught in code review.

This vocabulary system becomes the codebook for indexes. There is no need to create one from scratch. It already exists.

Natural language lacks this. "Great" has a dictionary definition, but everyone uses it differently. In code, Service is not used differently by different people.

---

## Why Code Is the Easiest Domain

Applying GEUL's context pipeline — [clarification](/why/clarification/), [indexing](/why/semantically-aligned-index/), [verification](/why/mechanical-verification/), [filtering](/why/filter/), [consistency](/why/consistency-check/), [exploration](/why/exploration/) — to natural language is hard. Applying it to code is easy.

Clarification: Natural language is ambiguous. If code passes the compiler, its meaning is determined.
Indexing: Entities in natural language require context to identify. Entities in code are already parsed by the AST.
Verification: Validity in natural language cannot be defined. Validity in code is determined by the compiler.
Filtering: Relevance in natural language requires LLM judgment. Relevance in code can be determined mechanically via call graphs.
Consistency: Contradictions in natural language must be found through inference. Contradictions in code are caught by the type system and tests.
Exploration: Natural language knowledge is flat. Code already has a hierarchy of package, file, type, and method.

The same pipeline operates at far lower cost in the code domain. Prove it first where it is easiest, then extend to where it is hard. That is engineering.

---

## Summary

Annotations were originally meant for humans.
Now they must serve machines as well.
Annotations that humans can read, but machines can search.
Annotations that are narrative, yet also indexes.

Code already has meaning, already has structure, already has vocabulary.
The only thing missing is indexes.
Annotations just need to become those indexes.
