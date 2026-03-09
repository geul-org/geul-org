---
title: "Event6 Edge"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "A variable-length event Edge expressing the 5W1H principle (Who, What, Whom, When, Where, Why) in one packet. Uses a Presence bitmask to achieve a 3-8 word variable structure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge is an event Edge type that expresses the **5W1H principle** (Who, What, Whom, When, Where, Why) in a single packet.

## 5W1H Elements

| Element | English | Bit | Meaning | TID reference target |
|---------|---------|-----|---------|----------------------|
| Who | Agent | 0 | Actor | [Entity Node](../entity-node/) |
| What | Action | 1 | Action/verb | [Verb Edge](../verb-edge/) |
| Whom | Patient | 2 | Target/patient | [Entity Node](../entity-node/) |
| When | Time | 3 | Time | Quantity/Entity |
| Where | Location | 4 | Place | [Entity Node](../entity-node/) |
| Why | Reason | 5 | Reason/purpose | [Clause Edge](../clause-edge/)/Entity |

## Packet Structure

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: Element TIDs (in Presence order)
```

### Presence Bitmask (6 bits)

| Bit | Element | If set |
|-----|---------|--------|
| 0 | Who | Include that TID |
| 1 | What | Include that TID |
| 2 | Whom | Include that TID |
| 3 | When | Include that TID |
| 4 | Where | Include that TID |
| 5 | Why | Include that TID |

Total words = 2 (header + Edge TID) + popcount(Presence). Range is 3~8 words (48~128 bits).

## Mode-specific Structures

### Minimal Mode (3 words)

```
Example: "It rained" (What only)

1st: [Prefix] + [000010]      - Only What present
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### Core Mode (5 words)

Who + What + Whom. The most frequent composition.

```
Example: "John hit Mary"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - John
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - Mary
```

### Standard Mode (6 words)

```
Example: "John met Mary yesterday"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - John
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - Mary
6th: [When TID]               - yesterday
```

### Full Mode (8 words)

```
Example: "John gave Mary a gift at school yesterday because of love"

1st: [Prefix] + [111111]      - All present
2nd: [Edge TID]
3rd: [Who TID]                - John
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - Mary
6th: [When TID]               - yesterday
7th: [Where TID]              - school
8th: [Why TID]                - love (reason)
```

## Element Details

### What (Action)

What references a [Verb Edge](../verb-edge/) TID. The referenced Verb Edge contains tense, aspect, and other qualifier information.

### Why (Reason)

Simple reasons are expressed as Entity TIDs ("love"), while complex reasons are expressed as [Clause Edge](../clause-edge/) TIDs ("because it rained").

## Event6 vs Verb Edge Comparison

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **Focus** | Predication/action | Complete event |
| **Participants** | Participant structure | 5W1H TIDs |
| **Spatiotemporal** | Expressed separately | When/Where built-in |
| **Reason** | Separate Clause | Why built-in |
| **Words** | 2~5 | 3~8 |
| **Use case** | Predication expression | Event storage |

**Selection guide:** Use Verb Edge for predication/sentence analysis, Event6 Edge for event/record storage, and [Triple Edge](../triple-edge/) for simple facts.

## Examples

### "Apple acquired Tesla"

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

Total: 5 words
```

### "Yi Sun-sin died in battle at Noryang in 1598"

```
Who:   Yi Sun-sin       → Entity TID 0x0010
What:  die (in battle)  → Verb Edge TID 0x0101
When:  1598             → Entity TID 0x0011
Where: Noryang          → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - Yi Sun-sin
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - Noryang

Total: 6 words
```

## Parsing

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
