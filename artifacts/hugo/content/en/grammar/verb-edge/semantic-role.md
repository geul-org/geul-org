---
title: "Semantic Role"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "Defines 16 Participants representing semantic roles within events. Encodes core roles like Agent, Theme, and Recipient through to adjunct roles like Cause and Purpose using 4-bit encoding."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

A **Participant** is an Edge that specifies the **semantic role** of an entity involved in an event within a predication.

```
Event Node (verb)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## Design Principles

### Separation Principle

| Category | Belongs to | Examples |
|----------|-----------|----------|
| **Participants** | Event level | Agent, Theme, Recipient |
| **Pragmatic info** | Context/Claim level | Speaker, Listener, Evidentiality |

Speaker, Listener, and Source (information origin) are not participants but are handled in **[Qualifier](../qualifier/)** or Context/Claim.

### Encoding

- **4 bits** (0x0~0xF), up to 16 semantic roles
- Pattern matching via SIMD bit operations

## Semantic Role List (16)

### Core Participants

| ID | Code | Role | Definition | Example |
|----|------|------|------------|---------|
| 0x0 | **AGT** | Agent | The entity that intentionally performs an action | "**John** kicked the ball" |
| 0x1 | **EXP** | Experiencer | The entity that experiences emotion/cognition/perception | "**Mary** was sad" |
| 0x2 | **THM** | Theme | The entity that moves or whose state is described | "John kicked **the ball**" |
| 0x3 | **PAT** | Patient | The entity whose state changes due to an action | "**The window** broke" |
| 0x4 | **RCP** | Recipient | The entity that receives something | "He gave the book to **Mary**" |
| 0x5 | **BNF** | Beneficiary | The entity that benefits from an action | "Made it **for the child**" |

### Instruments & Means

| ID | Code | Role | Definition | Example |
|----|------|------|------------|---------|
| 0x6 | **INS** | Instrument | The tool used to perform an action | "Drove the nail **with a hammer**" |
| 0x7 | **MNR** | Manner | The way an action is performed | "Ran **quickly**" |

### Spatial

| ID | Code | Role | Definition | Example |
|----|------|------|------------|---------|
| 0x8 | **LOC** | Location | The place where an event occurs | "Lived **in Seoul**" |
| 0x9 | **SRC** | Source | The starting point of movement | "Departed **from home**" |
| 0xA | **DST** | Destination | The ending point of movement | "Went **to school**" |
| 0xB | **PTH** | Path | The waypoint of movement | "Went **through the park**" |

### Causal

| ID | Code | Role | Definition | Example |
|----|------|------|------------|---------|
| 0xC | **CAU** | Cause | The cause of an event | "Cancelled **because of rain**" |
| 0xD | **PRP** | Purpose | The purpose of an action | "Went **to exercise**" |

### Others

| ID | Code | Role | Definition | Example |
|----|------|------|------------|---------|
| 0xE | **COM** | Comitative | The accompanying entity | "Went **with a friend**" |
| 0xF | **ATR** | Attribute | State/attribute predication | "The sky is **blue**" |

## Participant Edge Structure

```
PARTICIPANT Edge {
    source:     Event SIDX       // verb node
    target:     Entity SIDX      // entity node
    role:       4-bit            // semantic role (0x0~0xF)
    gram_role:  2-bit (optional) // grammatical role (subject/object/complement)
    focus:      4-bit (optional) // emphasis level (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // quantifier reference
}
```

| Field | Bits | Description |
|-------|------|-------------|
| role | 4 | Semantic role (required) |
| gram_role | 2 | 0=unspecified, 1=subject, 2=object, 3=complement |
| focus | 4 | Informational importance (0=background, 15=core emphasis) |
| quant_ref | 16 | Quantifier TID for "every", "most", etc. |

## Theme vs Patient

| Role | State change | Example |
|------|-------------|---------|
| Theme | None (movement/description) | "**threw** the ball" (ball unchanged) |
| Patient | Yes (affected) | "**broke** the glass" (glass state changed) |

In practice, they can be merged as Theme and distinguished by verb semantics when needed.

## Examples

### Simple sentence: "John gave Mary a book"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → John
├─ PARTICIPANT (THM) → book
└─ PARTICIPANT (RCP) → Mary
```

### Complex sentence: "Because of rain, I ran quickly from home to school with a friend"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [speaker]
├─ PARTICIPANT (CAU) → rain
├─ PARTICIPANT (COM) → friend
├─ PARTICIPANT (SRC) → home
├─ PARTICIPANT (DST) → school
└─ PARTICIPANT (MNR) → quickly
```

### State predication: "The sky is very blue"

```
Event: be.v.01
├─ PARTICIPANT (THM) → sky
└─ PARTICIPANT (ATR) → blue (focus=15)
```

## Active/Passive Normalization

| Surface form | Agent | Theme |
|-------------|-------|-------|
| "Apple acquired Tesla" | Apple | Tesla |
| "Tesla was acquired by Apple" | Apple | Tesla |

Normalized to the same pattern during the parsing stage.
