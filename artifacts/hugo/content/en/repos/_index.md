---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
summary: "GitHub repositories that make up the GEUL project. Language spec, grammar codebooks, search, DSL, and website."
image: "/images/og-default.webp"
---

All repositories live under the [geul-org](https://github.com/geul-org) GitHub organization.

---

## Language

### geul

A semantically-aligned artificial language and binary stream format for AI.

A 2-byte (65,536 symbols) language system designed for unambiguous communication between humans and AI. Every statement carries its source, timestamp, and confidence level. Every entity has a unique identifier. The stream format operates in 16-bit units, defining 10 packet types (Verb Edge, Entity Node, Triple Edge, etc.) under a 10-bit prefix scheme.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| Language | Go, Python |
| License | MIT |

---

## Grammar

### geul-verb

Verb SIDX 16-bit codebook (WordNet-based).

Maps WordNet verb synsets to 16-bit codes for use in GEUL Verb Edge packets. Provides the verb vocabulary that the stream format consumes.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| Language | Python |
| License | MIT |

### geul-entity

Entity SIDX 48-bit codebook (Wikidata-based).

Encodes Wikidata entities into 48-bit structured identifiers. Defines entity types, designs per-type attribute schemas, and builds the codebooks that SILK consumes.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| Language | Python |
| License | MIT |

### geul-quantities

Quantity Node codebook.

Defines the encoding scheme for quantity values — numbers with units, ranges, and precision — used in GEUL Quantity Node packets.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| Language | Python |
| License | MIT |

### geul-ast

AST Edge codebook.

Defines the encoding scheme for abstract syntax tree edges, enabling structured code representation within the GEUL stream format.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| Language | Python |
| License | MIT |

---

## Search

### silk

SILK (Symbolic Index for LLM Knowledge) — a neuro-symbolic search architecture.

Searches with 64-bit integers. No vector DB, no ANN graph, no embedding model required. A single NumPy bitwise AND searches 100 million records, and the core claim is that Python alone outperforms optimized C++/Rust vector search. Provides a hybrid query pipeline combining codebook lookup with LLM assistance.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Language | Python |
| License | MIT |

---

## DSL

### fullend

Full-stack SSOT Orchestrator — validates consistency across 5 SSOT sources (STML, OpenAPI, SSaC, SQL DDL, Terraform) and generates code from them.

Calls each layer's individual validation tools, then cross-validates boundaries between layers. After validation passes, orchestrates code generation from sqlc, oapi-codegen, SSaC, and STML, and produces glue code.

| | |
|---|---|
| GitHub | [geul-org/fullend](https://github.com/geul-org/fullend) |
| Language | Go |
| License | MIT |

### ssac

Service Sequences as Code — parses declarative service logic from Go comments and generates Go implementation code via CLI.

Defines service flows as structured comments in Go source files. The CLI reads these declarations and generates the corresponding implementation code, eliminating boilerplate while keeping the logic readable and version-controlled.

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| Language | Go |
| License | MIT |

### stml

SSOT Template Markup Language — declarative UI-to-API binding with HTML5 data-* attributes, symbolic validation against OpenAPI, and React codegen.

Binds UI templates to API schemas using HTML5 data attributes. Validates bindings symbolically against OpenAPI specs at build time, then generates type-safe React components. One source of truth from schema to screen.

| | |
|---|---|
| GitHub | [geul-org/stml](https://github.com/geul-org/stml) |
| Language | TypeScript |
| License | MIT |

---

## Website

### geul-org

The source code for this website.

A Hugo static site generator supporting 12 languages. Deployed via S3 + CloudFront, with a CloudFront Function handling language detection and clean URLs.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Language | Hugo (Go Templates), CSS |
| License | MIT |
