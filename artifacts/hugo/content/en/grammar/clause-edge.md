---
title: "Clause Edge"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "A fixed 4-word Edge expressing logical and discourse relations between predications, events, and relationships. Encodes causation, temporal, contrast, and argumentation relations using 16 RST-based relation types."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge is an Edge type that expresses **logical and discourse relations** between predications ([Verb Edge](../verb-edge/)), events ([Event6 Edge](../event6-edge/)), relationships ([Triple Edge](../triple-edge/)), or other Clauses.

It is designed based on the discourse relations of RST (Rhetorical Structure Theory).

## Packet Structure (4 words, 64 bits)

```
1st WORD (16 bits):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │  RelType   │Reserved│
│       10 bits       │   4 bits   │ 2 bits │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16 bits)
3rd WORD: TID 1 (16 bits) - First clause
4th WORD: TID 2 (16 bits) - Second clause
```

| Field | Bits | Description |
|-------|------|-------------|
| Prefix | 10 | `1100 000 010` |
| RelType | 4 | 16 RST relations |
| Reserved | 2 | For future extension |
| Edge TID | 16 | Unique identifier for this Edge |
| TID 1 | 16 | First clause reference |
| TID 2 | 16 | Second clause reference |

## Relation Types (4 bits = 16)

### Causal Relations

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 0000 | CAUSE | Cause → Effect | "It rained, so I stayed home" |
| 0001 | RESULT | Effect ← Cause | "I stayed home, because it rained" |
| 0010 | CONDITION | Condition → Consequence | "If it rains, I won't go" |
| 0011 | PURPOSE | Purpose | "We eat to live" |

### Temporal/Sequential Relations

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 0100 | SEQUENCE | Chronological | "Had dinner, then slept" |
| 0101 | PARALLEL | Simultaneous/parallel | "Spoke while smiling" |

### Contrast/Concession Relations

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 0110 | CONTRAST | Contrast | "A is big and B is small" |
| 0111 | CONCESSION | Concession | "Although it was hard, I did it" |

### Elaboration/Background Relations

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 1000 | ELABORATION | Elaboration | "Specifically speaking" |
| 1001 | BACKGROUND | Background info | "For reference, the situation at that time was" |

### Argumentation Relations

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 1010 | EVIDENCE | Evidence presentation | "Because... that is why" |
| 1011 | EVALUATION | Evaluation | "This is good/bad" |

### Other Relations

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 1100 | SOLUTIONHOOD | Problem → Solution | "The problem is X, the solution is Y" |
| 1101 | ALTERNATIVE | Choice/alternative | "Go or not go" |
| 1110 | MEANS | Means | "Achieved it by doing this" |
| 1111 | RESERVED | Reserved | For future extension |

## TID Ordering Rules

Direction is determined by TID order.

| Relation | TID 1 | TID 2 |
|----------|-------|-------|
| CAUSE | Cause | Effect |
| RESULT | Effect | Cause |
| CONDITION | Condition | Consequence |
| PURPOSE | Action | Purpose |
| SEQUENCE | Preceding | Following |
| EVIDENCE | Evidence | Claim |
| ELABORATION | Core | Elaboration |

## Multinuclear vs Nucleus-Satellite

Follows the RST distinction.

### Nucleus-Satellite (Asymmetric)

| Relation | TID 1 | TID 2 |
|----------|-------|-------|
| CAUSE | Cause (Satellite) | Effect (Nucleus) |
| CONDITION | Condition (Satellite) | Consequence (Nucleus) |
| EVIDENCE | Evidence (Satellite) | Claim (Nucleus) |
| ELABORATION | Core (Nucleus) | Elaboration (Satellite) |

### Multinuclear (Symmetric)

| Relation | TID 1 | TID 2 |
|----------|-------|-------|
| SEQUENCE | Preceding | Following |
| PARALLEL | First | Second |
| CONTRAST | First | Second |
| ALTERNATIVE | First | Second |

In symmetric relations, TID order does not indicate semantic priority.

## Examples

### Simple causation: "It rained, so I stayed home"

```
Verb Edge E01: rain(rain) | TID=0x0001
Verb Edge E02: stay(I, home) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + Reserved
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (cause: E01)
  4th: [0x0002]                    - TID 2 (effect: E02)
```

### Nested Clause: "It rained so I stayed home, and therefore I studied"

```
Verb Edge E01: rain(rain) | TID=0x0001
Verb Edge E02: stay(I, home) | TID=0x0002
Verb Edge E03: study(I) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (Clause TID reference!)
  4th: [0x0003]                    - E03
```

## Design Rationale

### Why RST-based

- Over 30 years of accumulated research
- Validated across diverse corpora
- Existing discourse parsing tools
- Language-independent

### Why 4 bits (16 types)

- Covers 12+ core RST relations
- Preserves room for extension
- 3 bits (8 types) would be insufficient

### Why 4-word simplification

- Direction: Determined by TID order (no separate bits needed)
- Confidence: Handled as separate metadata
- 2 reserved bits: For future extension
