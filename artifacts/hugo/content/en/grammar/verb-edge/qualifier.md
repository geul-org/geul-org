---
title: "Qualifier"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "qualifier", "tense", "aspect"]
summary: "Semantic qualifiers for Verb Edge. Encodes grammatical and pragmatic information of predications across 14 categories including evidentiality, mood, modality, tense, aspect, politeness, polarity, and confidence."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge encodes various semantic qualifiers in addition to the verb body. Together with [Semantic Role](../semantic-role/), they form the complete meaning of a predication.

## Qualifier List

| Category | English name | Data type | Value mapping |
|----------|-------------|-----------|---------------|
| Core verb | Core Verb | Identifier | Semantic-aligned absolute identifier |
| [Participant](../semantic-role/) list | Participant List | Composite type list | {entity, grammatical role, semantic role} |
| Speaker | Speaker | Reference | Predication subject (required) |
| Listener | Listener | Reference | Predication target (nullable) |
| Evidentiality | Evidentiality | Float [-1.0~1.0] | -1=inference, 0=direct experience, 1=hearsay |
| Mood | Mood | Float [-1.0~1.0] | -1=hypothetical, 0=declarative, 1=imperative |
| Modality | Modality | Float [0.0~1.0] | Degree of volition |
| Tense | Tense | Float [-1.0~1.0] | -1=past, 0=present, 1=future |
| Aspect | Aspect | Bitmask | 1:progressive, 2:perfective, 4:resultative |
| Politeness | Politeness | Float [-1.0~1.0] | -1=informal, 0=neutral, 1=honorific |
| Polarity | Polarity | Float [-1.0~1.0] | -1=negative, 0=indeterminate, 1=affirmative |
| Volitionality | Volitionality | Float [-1.0~1.0] | -1=unintentional, 0=indeterminate, 1=intentional |
| Confidence | Confidence | Float [-1.0~1.0] | -1=speculative, 0=indeterminate, 1=certain |
| Iterativity | Iterativity | Integer | 0=indeterminate, 1=once, MAX=infinite |

## Evidentiality

Expresses the source of information.

| Value | Meaning | Example |
|-------|---------|---------|
| -1.0 | Inference | "It seems like ~" |
| 0.0 | Direct experience | "I saw that ~" |
| 1.0 | Hearsay | "They say that ~" |

## Mood

Expresses the function of the utterance.

| Value | Meaning | Example |
|-------|---------|---------|
| -1.0 | Hypothetical/counterfactual | "If only ~ had happened" |
| 0.0 | Declarative/factual | "~ is" |
| 1.0 | Imperative/request | "Do ~" |

## Tense

Expresses the temporal location of the event.

| Value | Meaning | Example |
|-------|---------|---------|
| -1.0 | Past | "~ did" |
| 0.0 | Present | "~ does" |
| 1.0 | Future | "~ will do" |

## Aspect

Expresses the internal temporal structure of an event as a bitmask.

| Bits | Meaning | Example |
|------|---------|---------|
| 001 | Progressive | "is doing ~" |
| 010 | Perfective | "has done ~" |
| 100 | Resultative | "has ~ ready" |
| 011 | Progressive + Perfective | "has been doing ~" |

## Politeness

Expresses the social relationship between speaker and listener.

| Value | Meaning | Example |
|-------|---------|---------|
| -1.0 | Informal/casual | "Do it" |
| 0.0 | Neutral | "Please do it" |
| 1.0 | Honorific/humble | "Would you kindly ~" |

## Design Principles

- **Continuous values:** Expressed as Float rather than discrete classifications to allow gradient representation
- **Bipolar:** Most use a [-1.0, 1.0] range to represent extremes
- **Indeterminate:** 0.0 can also mean "indeterminate" rather than "neutral" (for Polarity, Volitionality, Confidence)
- **Combination:** Hybrid of bitmask (Aspect) + Float for representing compound meanings
