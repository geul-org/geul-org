---
title: "SILK — An Index and Search Engine for GEUL"
weight: 1
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SILK", "search", "index", "GEUL", "Go"]
summary: "An engine that indexes and searches GEUL pack archives record by record. Because the data is structured at write time, search reduces to integer comparisons and range scans. Queries take 0.1–4ms on Wikidata Q1–Q10000."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
aliases:
  - /silk/
---

SILK is an **index and search engine built for GEUL**. Without decoding entire GEUL documents, it answers queries such as "which documents state that the occupation (P106) is physicist (Q169470)?" using record indexes alone.

| | |
|---|---|
| Status | Early development. The search algorithms are being validated, and formats may change before the first release |
| Language | Go |
| Input | GEUL pack archives (uncompressed) |
| License | CC0 |
| Repository | <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a> |

## Core Thesis

Search was never the hard part. **Unstructured data was the problem.**

```
Conventional: write first → infer structure later (tokenizing, embedding, analysis)
GEUL:         structure at write time → search is just integer comparison and range scans
```

A GEUL record already carries fields such as subject, predicate, object, and language as integer IDs at fixed positions. SILK simply extracts those fields and keeps them sorted.

## Why It Fits GEUL

| Property of GEUL | What SILK gains |
|---|---|
| A single 16-bit TAG WORD carries the kind (Kind, Codec) and the length | Records can be filtered and skipped without a codebook |
| Edge fields are records at fixed positions | Keys are extracted by position. No separate parsing rules are needed |
| Controlled vocabulary is integer IDs (Q, P, language) | Equality is an integer comparison, with no string normalization |
| A pack consists of immutable objects and generations | The index is also built from immutable segments and generations, so snapshots are safe |
| Conversion is deterministic | The same input yields the same index. Incremental results can be compared byte for byte against an index built from scratch |

GEUL documents are never re-sorted. The index is only a sorted **view**; the published bytes, content hashes, and signatures stay unchanged.

## Architecture

### Input

SILK reads GEUL pack archives through [gogeul](https://github.com/geul-org/gogeul). Because the index points to byte offsets inside data packs, the set must store records uncompressed (`GEULCOMPRESS=none`). zstd compression is for distribution and archiving; the search layer uses uncompressed packs.

### Partition Spec

For each TAG kind, a **partition key** and a **sort key** are declared as fixed-position fields of the record. Nothing like predicates or languages is hard-coded; the table below shows the defaults for Wikidata documents.

| TAG | Partition key | Sort key |
|---|---|---|
| TRIPLE | Predicate | Object |
| QUALIFIER | Property | Value |
| LABEL·ALIAS·DESCRIPTION | Language | Subject |
| SOURCE | none | Origin |
| REFERENCE-NODE | none | Object |

- A key is the first few bytes (a slot) of a field record. If the record fits in the slot, equality is exact; if it is longer, the key only selects candidates.
- Spec validation rejects partition keys on fields whose position requires a codebook, or on fields of unbounded length.
- A spec is identified by its content hash. When the spec changes, only that TAG is rebuilt.

### Runs, Increments, and Merging

| Component | Role |
|---|---|
| Sorted run | An immutable segment sorted by (sort key, document, offset) per partition. Searched by binary search |
| Appended segment | Holds only the newly arrived revisions from an incremental update (`silk index update`). Scanned |
| Live-revision bitmap | Marks the old revisions of changed documents as dead instead of deleting them |
| Size-tiered merging | Merges runs of the same size tier with an O(n) merge, and folds into the base run when dead rows pile up |
| Generation | The manifest generation is swapped atomically. Readers pin a generation, so snapshots hold even during a merge |

Merging can be restricted to idle time (`-idle`, leaving 30% of CPU and memory free). It stops at partition boundaries and resumes from a checkpoint.

### Queries

1. **Equality condition**: find the partition and binary-search the sorted runs.
2. **Multiple conditions**: merge-join on the document (subject). All conditions must hold within a single document.
3. **Verification**: decode candidate records with gogeul, compare them field by field, and read the Edge Id.

```sh
silk query -triple P106=Q169470 ARCHIVE
silk query -count -triple P31=Q5 -triple P106=Q169470 ARCHIVE
silk query -label ko -match LABEL:1=Q42 ARCHIVE
```

## Measurements

Measured on Wikidata Q1–Q10000 plus 16,696 property documents (271MB, 7.07 million index records). 8 threads, best of 7 runs, excluding process startup time.

### Queries

| Query | Result documents | Previous approach (full scan) | SILK index |
|---|---:|---:|---:|
| P106=Q169470 (occupation = physicist) | 55 | ~20ms | 0.12ms |
| P31=Q5 (human) | 1,579 | ~19ms | ~1ms |
| human + physicist | 54 | ~38ms | ~1ms |
| LABEL ko | 9,746 | (not possible) | ~4ms |

- The previous approach scanned the entire TRIPLE record map.
- For LABEL ko, most of the time goes into reading 9,746 records from the pack for verification.

### Size, Build, and Incremental Updates

| Item | Value |
|---|---|
| Index size | 113MB (15.7B per record on average) |
| Build | ~3 seconds (document parsing is single-threaded) |
| Incremental update (4,217 revisions changed) | 1.8 seconds |
| Incremental result | After 2 updates, 2 merges, and an interrupted-then-resumed run, query results are byte-identical to an index built from scratch |
| Write amplification | 1.31 cumulative (1.71 if rebuilt every time) |

- Extrapolated to all of Wikidata (about 7.5 billion records), the index would be about 110GB (**estimate**).
- The cost is size. It is about 4x larger than a simple map at 4B per record. Narrower slots and entity signatures are next to be examined.

### Signature Scan (preliminary measurement for entity signatures)

Time to scan 100 million 128-bit signatures with a mask and pattern (i7-14700K, AVX2).

| Implementation | Time |
|---|---:|
| NumPy, 1 thread | ~1s |
| Go, 1 thread | ~134ms |
| Go, 8 threads | ~27ms |
| Go, 16–20 threads | ~23ms (memory bandwidth bound) |

What makes the difference is not the language but **fused loops without intermediate arrays, plus multithreading**.

## Relationship to Vector Search

It is a division of labor, not a replacement.

| | SILK | Vector search |
|---|---|---|
| Queries handled | Structured queries (predicate, object, language, entity conditions) | Semantic similarity that is hard to express as structure |
| Result | The set satisfying the conditions (exact) | A similarity ranking (approximate) |
| Prerequisite | The data must be structured in GEUL | Raw text or embeddings are enough |

For queries that look for facts expressed in GEUL, SILK is exact and cheap. For unstructured raw text or queries for "something similar," vector search is the better fit.

## Position and Next Steps

SILK is **the search technology used by WMS (the GEUL storage and retrieval coordinator)**. Judging whether a retrieved statement is correct is the job of a separate adjudication engine.

| Next step | Details |
|---|---|
| Entity signatures | A fixed-width 16–128-bit bit string per entity. Users declare the fields (enum, one-hot, Bloom, prefix, range). It is an approximate first-pass filter followed by verification. Currently at the planning stage (partly in the library, not yet in the index) |
| Spec as a GEUL document | Declare the JSON spec as a GEUL document and read layouts from codec specification documents (DECLARE, FIELD) |
| Statement assembly index | A Target index that directly finds the TRIPLE a QUALIFIER or SOURCE points to |
| Preparing for scale | Memory caps for build and merge, parallel parsing during build |

The initial concept (2026-03) was a Python/NumPy design that scanned 64-bit entity identifiers with bitwise AND. It has since become a Go engine that indexes GEUL records directly.

## Repository and License

- Repository: <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a>
- Install: `go install github.com/geul-org/silk/cmd/silk@latest`
- License: our own work is CC0 1.0. Third-party components follow their own licenses (see NOTICE in the repository).
