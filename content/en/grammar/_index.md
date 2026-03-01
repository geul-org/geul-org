---
title: "GEUL Grammar"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "SIDX", "specification"]
summary: "Binary stream format specification based on the SIDX 64-bit global semantic identifier. Defines design principles, prefix scheme, 10 packet types, and encoding rules."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

GEUL Grammar is a binary stream format based on the SIDX (Semantic-aligned Index) 64-bit global semantic identifier.

## Design Principles

1. **Long-term extensibility:** Reserved bits must not be repurposed for temporary uses. Preserve space for future generations.
2. **Semantic permanence:** The meaning of a bit pattern, once defined, must never change. When a new meaning is needed, a new pattern is allocated.
3. **Backward compatibility:** Any version of GEUL must be able to fully interpret all previous versions.
4. **Linear complexity:** GEUL symbolic processing maintains O(n) with respect to length.

## SIDX Overview

SIDX is a 64-bit global semantic identifier. It branches sequentially from the most significant bit to determine the region.

| Prefix | Region | Ratio | Purpose |
|--------|--------|-------|---------|
| `1` | Far Future | 50% | Reserved for the far future |
| `01` | Future | 25% | Reserved for the near future |
| `001` | Standard | 12.5% | Official standard region |
| `000` | Free | 12.5% | Completely free |

`0001` is the conventional space used by this proposal within the Free region (000).

## Prefix Scheme

```
bit1
├─ 1: Far Future
│
└─ 0
    └─ bit2
        ├─ 1 (01): Future
        │
        └─ 0
            └─ bit3
                ├─ 1 (001): Standard
                │     └─ bit4~
                │         ├─ 1           (001 1)        → Tiny Verb Edge
                │         ├─ 01          (001 01)       → Verb Edge
                │         ├─ 001         (001 001)      → Entity Node
                │         └─ 000         (001 000)      → 9-bit unified region
                │
                └─ 0 (000): Free
                      └─ 0001: Proposal (Standard mirror)
```

## Packet Types

A GEUL stream consists of 10 packet types. Listed in order of prefix bit allocation (= importance).

| Type | Prefix | Words | Description |
|------|--------|-------|-------------|
| Tiny Verb Edge | `0001 1` | 2 | High-frequency simple predication |
| [Verb Edge](../verb-edge/) | `0001 01` | 3~5 | 559 roots → 13,767 WordNet verbs |
| [Entity Node](../entity-node/) | `0001 001` | 4 | 64 EntityType, 48-bit attributes |
| [Triple Edge](../triple-edge/) | `0001 000 110` | 4~5 | Properties/relations, Top63 + extension |
| [Clause Edge](../clause-edge/) | `0001 000 101` | 4 | RST-based discourse/logic, 16 relations |
| [Event6 Edge](../event6-edge/) | `0001 000 100` | 3~8 | 5W1H event |
| [Context Edge](../context-edge/) | `0001 000 011` | 3 | Worldview/context, 64 types |
| [Quantity Node](../quantity-node/) | `0001 000 010` | 4~7 | 64 unit codes, SI/currency/timestamp |
| [AST Edge](../ast-edge/) | `0001 000 001` | 3+ | 64 programming languages, 256 AST node types |
| [Group Edge](../group-edge/) | `0001 000 000 111` | 4+ | Set/group, 7 types |

### Common Specifications

| Document | Description |
|----------|-------------|
| [Stream Format](../stream-format/) | Stream format rules, TID scoping, packet ordering |

## Encoding Rules

| Item | Rule |
|------|------|
| Byte order | Big Endian |
| Bit order | MSB First (bit1 = MSB) |
| Word size | 16-bit (2 bytes) |

All fields are aligned to 16-bit word boundaries, and packet sizes are always in word units (multiples of 2 bytes). Padding uses 0x00 when needed.
