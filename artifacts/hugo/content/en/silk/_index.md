---
title: "SILK — Symbolic Index for LLM Knowledge"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "A neuro-symbolic search architecture that searches with 64-bit integers. Sub-second search across 100 million Wikidata entities without vector DB, ANN graphs, or embedding models."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — a neuro-symbolic search architecture.

Searches with 64-bit integers. No vector DB, no ANN graphs, no embedding models.

<a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHub Repository</a>

## Core Thesis

Search was never a hard problem — it was a **symptom of unstructured data**.
Assign 64-bit structure at write time, and the symptom disappears.

```python
results = index[(index & mask) == pattern]
```

Sub-second search across 100 million Wikidata entities in 1.3 GB of memory.
Python (NumPy) alone beats optimized C++/Rust vector DBs — an architectural win.

## Why Not Vector Embeddings

Vector embeddings crush structure.

```
"Admiral Yi Sun-sin was a military leader of the Joseon Dynasty"
 → A human instantly grasps: Korean, military, 16th century

Embedding model:
 [0.234, -0.891, 0.445, ..., 0.112] (384-dim float)
 → Structure destroyed. Can't tell if it's a person or a location.

To recover crushed structure:
 ANN graphs (HNSW, IVF-PQ), cross-encoders, rerankers, metadata filters...
```

SILK preserves structure.

```
SIDX: [Human / military / east_asia / early_modern]
 → Structure lives in the bits. Readable.
 → No recovery needed. It was never crushed.
```

The key is inverting the order.

```
Traditional: Write first → structure later (indexing)
SILK:        Structure at write time → search is free
```

## SIDX Bit Layout

SIDX follows the [GEUL Grammar](/grammar/) Entity Node specification.

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| Field | Bits | Width | Description |
|-------|------|-------|-------------|
| prefix | 63-57 | 7 | GEUL protocol header (`0001001` fixed, ignored during search) |
| mode | 56-54 | 3 | Quantification/number mode (registered entity=0, definite, universal, existential, etc. — 8 modes) |
| entity_type | 53-48 | 6 | 64 top-level types (Human=0 ~ Election=62, unclassified=63) |
| attrs | 47-0 | 48 | Per-type attribute encoding (defined by codebooks) |

Search target: entity_type 6 bits + attrs 48 bits = **54 bits**.
QIDs are not included in SIDX; they are stored in a separate array.

### attrs 48 bits — Per-Type Schema

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

Currently 5 types have defined attribute bit layouts. The rest encode only entity_type.

## Architecture

SILK has two pipelines: **Encoding** (at write time) and **Search** (at query time).
Both follow the same principle: symbolic structure handles form, LLM handles meaning.

```
Encoding Pipeline (write time)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  LLM Tagging │──►│  VALID Check │──►│Codebook Encode│
│  Doc → JSON  │   │ Codebook     │   │ JSON → SIDX  │
│  (Semantic   │   │ valid values │   │ (Bit assembly)│
│   classify)  │   │ Halluc → drop│   │              │
└──────────────┘   └──────────────┘   └──────────────┘
   LLM tags         Code validates    Codebook-based encoding
```

```
Search Pipeline (query time)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Query Parse  │──►│ Bit AND Filter│──►│  LLM Judge   │
│ Codebook     │   │  NumPy SIMD  │   │ Few candidates│
│ lookup + LLM │   │100M → dozens │   │ Dozens → answer│
└──────────────┘   └──────────────┘   └──────────────┘
   Meaning extract   Broad filter      Narrow judgment
```

Core strategy: **SIDX bit AND filters broadly without missing anything**, then **LLM judges only the few remaining candidates**.

```
Each component does what it's best at:
 Human: Structure design (codebooks)
 LLM:   Semantic classification (tagging) + semantic judgment (search)
 Code:  Rule validation (VALID) + bit assembly
 CPU:   Bulk comparison (NumPy SIMD)
```

### Encoding: LLM Tagging → VALID Validation

The LLM reads a document and tags it as JSON. VALID performs mechanical checks against codebooks.
Values not in the codebook, cross-type consistency violations, and constraint violations **physically cannot enter the index**.

```
LLM tagging: {"type": "Human", "occupation": "military", "country": "korea"}
VALID:       occupation="military" ∈ codebook? ✓  country="korea" ∈ codebook? ✓
             Human with constellation field? ✗ Dropped
Encoding:    Codebook lookup "military"→6 bits, "korea"→8 bits → bit assembly → SIDX uint64
```

LLMs can hallucinate. But VALID acts as the gatekeeper, so the probability of index contamination is zero.
Only JSON that passes VALID is encoded into SIDX 64-bit integers via codebooks.

### Search: Filter Broadly, LLM Narrows

```
1. Query meaning extraction   Codebook lookup 80% / LLM assist 20%
2. Bitmask assembly           Deterministic — algorithm
3. NumPy bit AND              Deterministic — full scan of 100M in 20ms
4. LLM final judgment         Few candidates only — semantic precision
```

### 80% of Searches Are Structural Queries

```
"Yi Sun-sin"     → Q484523 exact match. Bit AND. Done.
"Samsung news"   → org/company + doc_meta/news. Bit AND. Done.
"Biden-Xi summit" → Q6279 ∩ Q15031 ∩ meeting. Intersection. Done.
```

```
Structural queries (80%): Completed by SILK bit AND. No LLM needed.
Semantic queries  (15%): SILK narrows candidates → LLM judges 5-10.
Generative queries (5%): SILK identifies documents → LLM generates.
```

## Multi-SIDX

A single document or event can carry multiple SIDXs.

```
News article "Samsung, NVIDIA, Hyundai CEOs Meet":

SIDX[0]: [Human / business / east_asia ]  Jay Y. Lee
SIDX[1]: [Org   / company / east_asia ]  Samsung Electronics
SIDX[2]: [Human / business / n_america]  Jensen Huang
SIDX[3]: [Org   / company / n_america]  NVIDIA
SIDX[4]: [Human / business / east_asia ]  Euisun Chung
SIDX[5]: [Org   / company / east_asia ]  Hyundai Motor
SIDX[6]: [Event / meeting / east_asia ]  Meeting
```

All the same 64-bit SIDX. Same index. Same bit AND search.
The entity_type field distinguishes entities (Human, Org) from events (Event).

## Index Structure

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# Total ~1.3GB memory
```

```
Index construction:
 Elasticsearch: Tokenize → analyze → inverted index → segment merge
 Pinecone:      Embed → HNSW graph → clustering
 SILK:          sort
```

No data structures. Just one sorted array.

## Vector DB Comparison

|  | SILK | Vector DB |
|------|------|-----------|
| Index size (1T entries) | 12 TB | 1.5 PB (125x) |
| Index construction | sort | HNSW — days |
| Cold start | Open file, ready | Graph construction — hours |
| Partitioned scan | Possible (same results) | Impossible (graph breaks) |
| Compound conditions | Intersection (exact) | Compressed into 1 vector (approximate) |
| Results | Exact (set operations) | Approximate (similarity ranking) |
| Auditability | JSON (white box) | Impossible (black box) |

```
Bit AND is order-independent, stateless, and mergeable.
Vector DB: The entire graph must be in memory. Partition = destruction.
SILK:      Cut anywhere, it still works. Partition = slower, same results.
```

## Audit Pipeline

Vector embeddings are black boxes — unauditable. SIDX is JSON — fully auditable.

```
Stage 1 — Small LLM tagging    Llama 8B / GPT-4o-mini. Accuracy 85-90%.
Stage 2 — VALID mechanical check  Valid values, consistency, constraints. Cost $0.
Stage 3 — Large LLM audit      confidence=low only. Accuracy 99%+.

VALID is the gatekeeper: hallucinations outside codebook values physically cannot enter the index.
```

## License

MIT — <a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHub</a>
