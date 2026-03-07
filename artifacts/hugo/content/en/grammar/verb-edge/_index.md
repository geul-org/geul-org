---
title: "Verb Edge"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "Classifies 13,767 WordNet verbs into 10 Primitives and 68 Sub-primitives, then generates a 16-bit codebook via Huffman coding. Achieves an average 2.16-word compression across Tiny (2-word), Short (3-word), and Full (5-word) packets."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge is the Edge type in a GEUL stream that represents predication and actions. It classifies 13,767 WordNet verbs into 10 Primitives and 68 Sub-primitives, then generates a 16-bit codebook via **Sub-primitive-level Huffman coding**.

## Sub-documents

| Document | Description |
|----------|-------------|
| [Semantic Role](./semantic-role/) | 16 Semantic Roles (4-bit encoding) |
| [Qualifier](./qualifier/) | 14 qualifiers including evidentiality, mood, tense, aspect |

## Verb Hierarchy

```
10 Primitive (top-level semantic categories)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (intermediate classification)
    → 559 Root Verb (root verbs)
      → 13,767 Leaf Verb (all WordNet verbs)
```

- Primitives (major categories) serve only as **conceptual groupings** with no bit allocation
- 68 Sub-primitives receive **frequency-based variable-length codes**
- Higher-frequency verb groups get shorter codes (4 to 8 bits)

## Verb Edge Packet Types

All three packet types -- Tiny, Short, and Full -- share the same **16-bit verb body** in their last word.

| | Tiny | Short | Full |
|--|------|-------|------|
| Words | 2 (32bit) | 3 (48bit) | 5 (80bit) |
| Participants | 16 patterns | 512 patterns | 19-bit flags |
| Qualifiers | 7 patterns | 3,640 patterns | 27 bits |
| Verb body | 16bit | 16bit | 16bit |
| Expected ratio | 90% | 7% | 3% |

**Average packet size:** 0.9x2 + 0.07x3 + 0.03x5 = **2.16 words**

### Tiny Verb Edge (2 words)

```
1st WORD:  [Prefix 5bit] [Target×Pattern 11bit]
2nd WORD:  [Verb body 16bit]
```

- Target x Pattern: 18 Target x 113 patterns = 2,034 combinations
- 16 participant patterns x 7 qualifier patterns = 112 + 1 reserved = 113
- Coverage ~90%

### Short Verb Edge (3 words)

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [ParticipantPattern 9bit]
2nd WORD:  [Target×QualifierPattern 16bit]
3rd WORD:  [Verb body 16bit]
```

### Full Verb Edge (5 words)

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [TargetParticipant 5bit] [ParticipantFlags 4bit]
2nd+3rd:   [ParticipantFlags 15bit] [Qualifier 17bit]
4th WORD:  [Qualifier 10bit] [Reserved 6bit]
5th WORD:  [Verb body 16bit]
```

## 16-bit Verb Body

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     DFS index within tree  │
│   (4-8 bits, Huffman)   │     (8-12 bits)            │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code:** 4-8 bits variable (Huffman code)
- **DFS index:** Identifies individual verbs within the Sub-primitive

### Code Length Distribution

| Code length | Count | Total verbs | Ratio |
|-------------|-------|-------------|-------|
| 4 bits | 4 | 6,388 | 46.4% |
| 5 bits | 4 | 2,479 | 18.0% |
| 6 bits | 8 | 2,321 | 16.9% |
| 7 bits | 16 | 1,786 | 13.0% |
| 8 bits | 36 | 813 | 5.9% |

### DFS Index Bit Calculation

| Sub-primitive verb count | Bits needed |
|--------------------------|-------------|
| 1~256 | 8 bits |
| 257~512 | 9 bits |
| 513~1024 | 10 bits |
| 1025~2048 | 11 bits |
| 2049~4096 | 12 bits |

Example: CHANGE-TRANSFORM = `0000` (4 bits) + 3,063 verbs (12 bits) = 16 bits.

### Average Code Length

```
Average = Sum(code_length x verb_count) / total_verbs ≈ 5.14 bits
```

| Method | Average bits |
|--------|--------------|
| Fixed 7-bit (68 entries) | 7.00 |
| Huffman coding | 5.14 |
| **Savings** | **1.86 bits (27%)** |

## Primitive Major Categories (10)

| Primitive | Meaning | Sub-primitive count | Verb count |
|-----------|---------|---------------------|------------|
| BE | State/existence | 8 | 899 |
| PERCEIVE | Perception/cognition | 4 | 218 |
| FEEL | Emotion | 6 | 204 |
| THINK | Thought | 6 | 769 |
| CHANGE | Change | 8 | 3,358 |
| CAUSE | Causation/action | 14 | 3,739 |
| MOVE | Movement | 6 | 2,182 |
| COMMUNICATE | Communication | 6 | 586 |
| TRANSFER | Transfer | 4 | 530 |
| SOCIAL | Social action | 6 | 387 |

## Highest-frequency Sub-primitives (4-bit codes)

| Sub-primitive | Code | Verb count | Ratio | Examples |
|---------------|------|------------|-------|----------|
| CHANGE-TRANSFORM | `0000` | 3,063 | 22.2% | "change", "become" |
| CAUSE-USE | `0001` | 1,358 | 9.9% | "use", "employ" |
| MOVE-DISPLACE | `0010` | 1,025 | 7.4% | "move", "shift" |
| MOVE-GO | `0011` | 942 | 6.8% | "go", "travel" |

The top 4 Sub-primitives account for 46.4% of all verbs.

## Design Philosophy

### Why Huffman Coding

- CHANGE-TRANSFORM (22.2%) is overwhelmingly high-frequency
- **27% reduction in average bit count** compared to fixed-bit allocation
- Top 4 Sub-primitives account for 46.4% of the total

### Why Remove Primitive Bits

- Before: Primitive 3 bits + Sub_primitive 4 bits = 7 bits fixed
- After: Sub_primitive direct coding = 4-8 bits variable
- **Up to 4-bit savings** for high-frequency verbs

### Maintaining Semantic Grouping

Primitive classification is retained for human readability and as a semantic clustering hint during LLM training.
