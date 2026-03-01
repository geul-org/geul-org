---
title: "Group Edge"
weight: 90
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "group", "set", "logic"]
summary: "A variable-length Edge that bundles multiple Nodes into 7 types: AND, OR, LIST, SET, and more. Uses a 13-bit Prefix and terminator marker (0x0000) to support unlimited members."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Group Edge is an Edge type that **bundles multiple Nodes into a single group**.

## Packet Structure

```
1st WORD (16 bits)
┌───────────────────────┬───────────┐
│        Prefix         │ GroupType │
│        13 bits        │   3 bits  │
└───────────────────────┴───────────┘
  [1100 000 111 000]       [TTT]

2nd WORD: Edge TID (16 bits)
3rd+ WORD: Member TIDs (variable)
Last WORD: Terminator (0x0000)
```

| Field | Bits | Description |
|-------|------|-------------|
| Prefix | 13 | `1100 000 111 000` |
| GroupType | 3 | Group kind (8 types) |
| Edge TID | 16 | Unique identifier for this Edge |
| Member TIDs | 16xN | Group member references |
| Terminator | 16 | `0x0000` |

Minimum 4 words (1 member), typical 5~6 words (2~3 members), maximum unlimited.

## GroupType (3 bits = 8)

| Code | Type | Meaning | Member count |
|------|------|---------|--------------|
| 000 | **AND** | Conjunction | 2+ |
| 001 | **OR** | Disjunction | 2+ |
| 010 | **XOR** | Exclusive choice | 2+ |
| 011 | **LIST** | Ordered list | 1+ |
| 100 | **SET** | Unordered set | 1+ |
| 101 | **RANGE** | Range (start~end) | Exactly 2 |
| 110 | **PAIR** | Ordered pair | Exactly 2 |
| 111 | Extension | Future extension | - |

## GroupType Details

### AND

All members participate simultaneously. Example: "John **and** Mary **and** Bob held a meeting"

### OR

One or more members apply (inclusive or). Example: "Order coffee **or** tea"

### XOR

Exactly one member applies (exclusive or). Example: "Pass or fail (one or the other)"

### LIST

An ordered list where sequence matters. Used for rankings and sequences. Example: "1st John, 2nd Mary, 3rd Bob"

### SET

An unordered set where only membership matters. Example: "Attendees: John, Mary, Bob"

### RANGE

A continuous range including values in between. Exactly 2 members (start, end). Example: "From 1 to 10"

### PAIR

A simple ordered pair. Exactly 2 members. Used for coordinates, key-value, etc. Example: "Coordinates (3, 5)"

### RANGE vs PAIR

| Type | Meaning | In-between values |
|------|---------|-------------------|
| RANGE | Continuous range | Included |
| PAIR | Simple pair | None |

`RANGE [1, 5]` → 1, 2, 3, 4, 5 (in-between values exist). `PAIR [1, 5]` → (1, 5) (only two values).

## Examples

### "John and Mary met"

```
1. Entity Node: John (TID=0x0001)
2. Entity Node: Mary (TID=0x0002)
3. Group Edge: AND (TID=0x0100)
   1st: [1100 000 111 000] [000] = Prefix + AND
   2nd: [0x0100]                 = Edge TID
   3rd: [0x0001]                 = John
   4th: [0x0002]                 = Mary
   5th: [0x0000]                 = Terminator

4. Verb Edge: meet
   Subject: 0x0100 (group reference)

Total: 5 words
```

### "Coordinates (3, 5)"

```
1. Quantity Node: 3 (TID=0x0001)
2. Quantity Node: 5 (TID=0x0002)
3. Group Edge: PAIR (TID=0x0100)
   1st: [1100 000 111 000] [110] = Prefix + PAIR
   2nd: [0x0100]
   3rd: [0x0001]                 = First (x)
   4th: [0x0002]                 = Second (y)
   5th: [0x0000]

Total: 5 words
```

## Constraints

| GroupType | Min | Max |
|-----------|-----|-----|
| AND / OR / XOR | 2 | Unlimited |
| LIST / SET | 1 | Unlimited |
| RANGE / PAIR | 2 | 2 |

- Member TIDs must reference already-declared Nodes/Edges
- Self-reference (cycles) is not allowed
- TID=0x0000 is reserved as the terminator
