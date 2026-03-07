---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
summary: "GitHub repositories that make up the GEUL project. Language design, encoding pipeline, search engine, and website."
image: "/images/og-default.webp"
---

The GEUL project is composed of four repositories.

Design the language (geul), encode the world's entities into 64 bits (geul-sidx), search over that index (silk), and explain why all of this is necessary (geul-org).

---

## geul

A semantically-aligned artificial language and binary stream format for AI.

A 2-byte (65,536 symbols) language system designed for unambiguous communication between humans and AI. Every statement carries its source, timestamp, and confidence level. Every entity has a unique identifier. The stream format operates in 16-bit units, defining 10 packet types (Verb Edge, Entity Node, Triple Edge, etc.) under a 10-bit prefix scheme.

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| Language | Go, Python |
| License | MIT |

---

## geul-sidx

SIDX (Semantic-aligned Index) codebook builder & encoding pipeline.

Encodes 108.8M Wikidata entities into 64-bit structured identifiers. Defines 63 entity types, designs per-type 48-bit attribute schemas, builds codebooks, and validates encoding results (VALID). The producer of the indexes and codebooks that SILK consumes.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| Language | Python |
| License | MIT |

---

## silk

SILK (Symbolic Index for LLM Knowledge) — a neuro-symbolic search architecture.

Searches with 64-bit integers. No vector DB, no ANN graph, no embedding model required. A single NumPy bitwise AND searches 100 million records, and the core claim is that Python alone outperforms optimized C++/Rust vector search. Provides a hybrid query pipeline combining codebook lookup with LLM assistance.

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| Language | Python |
| License | MIT |

---

## geul-org

The source code for this website.

A Hugo static site generator supporting 12 languages. Deployed via S3 + CloudFront, with a CloudFront Function handling language detection and clean URLs.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| Language | Hugo (Go Templates), CSS |
| License | MIT |
