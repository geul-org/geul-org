---
title: "Stream Format"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "A GEUL stream is a packet sequence that begins and ends with a Meta Node. Defines TID scoping, forward-only references, and packet ordering rules."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

A GEUL stream is a **packet sequence that begins and ends with a Meta Node**, forming one complete GEUL document.

## Key Features

- **Explicit boundaries:** STREAM_START / STREAM_END (Meta Node)
- **TID scope:** Valid only within the stream
- **Forward-only references:** Only already-declared TIDs can be referenced
- **Big Endian:** Network Byte Order

## Stream Structure

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← Required (Meta Node)
│          (TID width declaration)    │     0xC000 (16-bit TID)
├─────────────────────────────────────┤
│          Metadata (optional)        │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Body packets               │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← Optional (recommended)
└─────────────────────────────────────┘
```

The minimum stream is `STREAM_START` (1 word) + `STREAM_END` (1 word) = 2 words (4 bytes); even an empty stream is valid.

## TID Allocation Principles

| Rule | Description |
|------|-------------|
| **Mandatory** | Every Edge/Node in the stream has a TID |
| **Unique** | TIDs are unique within a stream |
| **Scoped** | TIDs are valid only within their stream |
| **Forward-only** | Only already-declared TIDs can be referenced |

### TID Position

| Type | TID position | Reference position |
|------|-------------|-------------------|
| **Meta Node** | None | None |
| **Entity Node** | Last word | None |
| **Quantity Node** | Last word | None |
| **Tiny Verb Edge** | None | None (inline) |
| **Verb Edge** | Header area | After payload |
| **Triple Edge** | Header area | After payload |
| **Event6 Edge** | Header area | After payload |
| **Clause Edge** | Header area | After payload |
| **Context Edge** | Header area | After payload |
| **Group Edge** | 2nd word | 3rd+ words |

**Nodes** only define themselves, so TID comes last. **Edges** reference other TIDs, so TID precedes references.

### Reserved TIDs

| TID | Purpose |
|-----|---------|
| 0x0000 | **Terminator** ([Group Edge](../group-edge/), etc.) |
| 0xFFFF | Reserved (16-bit basis) |

## Packet Ordering Rules

### Declaration-Reference Order

```
Correct:
  [Entity: John, TID=0x0001]
  [Entity: Mary, TID=0x0002]
  [Verb Edge: meet, Subject=0x0001, Object=0x0002]

Wrong:
  [Verb Edge: meet, Subject=0x0001, Object=0x0002]  ← 0x0001 not declared
  [Entity: John, TID=0x0001]
  [Entity: Mary, TID=0x0002]
```

### Recommended Order

```
1. STREAM_START
2. Metadata (VERSION, CREATED_AT, CREATOR)
3. Entity Nodes (entity declarations)
4. Quantity Nodes (quantities/literals)
5. Group Edges (group definitions)
6. Tiny Verb Edges (inline predications)
7. Verb Edges (general predications)
8. Triple Edges (properties/relations)
9. Event6 Edges (events)
10. Clause Edges (discourse relations)
11. Context Edges (contexts)
12. Faber Edges (code/AST)
13. STREAM_END
```

This is a recommended order only; packets can be freely arranged as long as the declaration-reference rule is followed.

### No Circular References

Circular references of the form A → B → A are not allowed. When circular relationships are needed, they are expressed as separate Edges.

```
Allowed:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## Stream Examples

### "John met Mary"

```
1. STREAM_START (TID 16 bits)
   0xC0 0x00

2. Entity: John (TID=0x0001)
   [Entity packet...] 0x00 0x01

3. Entity: Mary (TID=0x0002)
   [Entity packet...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "John and Mary met at school"

```
1. STREAM_START
   0xC0 0x00

2. Entity: John (TID=0x0001)
3. Entity: Mary (TID=0x0002)
4. Entity: school (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Members: 0x0001, 0x0002, 0x0000 (terminator)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (group)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## Stream Validation

### Required Validation

| Item | Check |
|------|-------|
| Start | Does it begin with STREAM_START? |
| TID uniqueness | Are there no duplicate TIDs? |
| Reference validity | Are all referenced TIDs declared? |
| Forward-only | Is the TID already declared at the point of reference? |

### Validation Code

```python
def validate_stream(packets: list) -> dict:
    """Stream validity check"""
    errors = []
    declared_tids = set()

    # Start validation
    if not packets or packets[0].type != "STREAM_START":
        errors.append("Stream does not begin with STREAM_START")

    for packet in packets:
        # TID uniqueness check
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"Duplicate TID: {packet.tid}")
            declared_tids.add(packet.tid)

        # Reference validity check
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Undeclared TID reference: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## Multiple Streams

Each stream is independent, and TID scopes are separated per stream. TID=0x0001 in Stream A and TID=0x0001 in Stream B are different entities.

Cross-references between streams are currently unsupported. Future extensions may introduce stream IDs and an Import/Export mechanism.
