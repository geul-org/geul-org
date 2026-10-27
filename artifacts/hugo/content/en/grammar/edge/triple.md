---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE is a description Edge that holds one proposition (Predicate, Subject, Object) and its rank (Codec 0x0A). Object can be unknown (UNKNOWN-VALUE) or none (NO-VALUE) instead of a value."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE is a description Edge that holds one proposition (Predicate, Subject, Object) and its rank. Codec `0x0A`.

Conditions that qualify the proposition (start and end time, scope of application, and so on) are attached as a [QUALIFIER](/grammar/edge/qualifier/) that points to the Edge Id of the TRIPLE. The source (Wikidata references) is attached as the evidence Edge [SOURCE](/grammar/edge/source/) that points to the Edge Id of the TRIPLE.

## Layout

```
TAG WORD          0001 0LLL L000 1010
[Length extension TAG]
Edge Id           LOCAL Reference record
Predicate         Reference record (WIKIDATA-PID and so on)
Subject           Reference record
Object            Reference or Value record, or the slot marker 0x0001 UNKNOWN-VALUE or 0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| Code | Name | Meaning |
|---|---|---|
| `0` | normal | Default |
| `1` | preferred | The current value, the most authoritative value |
| `2` | deprecated | A value judged wrong or outdated but kept as a record |

- It is the same as the Wikidata statement rank. The representative value (Wikidata truthy) is the preferred one among the same Subject and Predicate if there is one, otherwise normal.
- A source that does not assign ranks uses `0` (normal).
- Any other code is invalid.

## Interpretation and Validity

- Predicate and Subject are each exactly one complete Reference record.
- Object is exactly one complete Reference or Value record, or a 1 WORD [slot marker](/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) or `0x0002` (NO-VALUE). ABSENT (`0x0000`) is not accepted. Object is not an optional field.
- After reading Object, exactly 1 WORD (Rank) must remain.
- A geul.org specification document places [CODEC](/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) and [ENUM](/grammar/edge/enum/) 0, 1, 2 on the Rank raw-value field. On the Object field it places CODEC `0780` (any Reference), `0F80` (any Value), `0001` (UNKNOWN-VALUE), and `0002` (NO-VALUE). Predicate and Subject do not accept slot markers.
- **The meaning of a TRIPLE is everything gathered from the QUALIFIERs in the same document that point to its Edge Id.** The reader gathers the QUALIFIERs before interpreting the TRIPLE. A TRIPLE read without its QUALIFIERs may be a proposition with its qualification missing (for example, "head of government" without the time qualification).

## Unknown and None

A slot marker in the Object position is an assertion about the proposition, not a value.

| Object | Meaning | Logic |
|---|---|---|
| a value v | One of the Subject's values for Predicate is v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | A value exists. It is unknown what it is (Wikidata `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | There is no value (Wikidata `novalue`) | `¬∃x. P(s, x)` |
| No TRIPLE | Asserts nothing (open world) | |

- **It is read within the qualifying conditions.** The scope of `∃` and `¬∃` is set by the QUALIFIERs that point to that TRIPLE. When QUALIFIERs are attached, it is closed only in that scope. "There was no central bank in 1811 to 1816" is written by attaching P580 and P582 QUALIFIERs to a NO-VALUE TRIPLE. It does not contradict a value TRIPLE of the same Predicate in another period.
- **rank applies in the same way.** When choosing the representative value (truthy), UNKNOWN-VALUE and NO-VALUE TRIPLEs are also candidates. If a preferred one exists, only the preferred remains.
- **Two UNKNOWN-VALUEs are not equal.** UNKNOWN-VALUE is neither equal nor unequal to any value (the comparison result is undetermined), and two UNKNOWN-VALUEs are not treated as the same value either. Each occurrence is an independent existential quantification. So two UNKNOWN-VALUE TRIPLEs with identical bytes are not duplicates and are not merged (there may be two children, or one).
- If a NO-VALUE and a value (or UNKNOWN-VALUE) TRIPLE of the same Subject, Predicate, and rank coexist and their qualifying conditions are not distinguished, that is a contradiction. The checker warns. It does not reject (this state exists in Wikidata too).
- A value that could not be carried over (the source has a value) is not written as UNKNOWN-VALUE.

## Examples (non-normative)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORDs, `LLLL=1001`. The TAG is `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (United States) P1304 (central bank) NO-VALUE, normal. There was no central bank in 1811 to 1816 (for the P580 and P582 QUALIFIERs, see the [QUALIFIER](/grammar/edge/qualifier/) example). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORDs, `LLLL=1000`. The TAG is `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "No children (P40)" is `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Open Questions

- scope (the context of a claim: world, viewpoint): decided when a use arises.
- An abbreviated form that folds a TRIPLE and QUALIFIERs into one record: after repeated-field declaration exists (the open question in [DECLARE](/grammar/edge/declare/)).

## Related Pages

- [Edge](/grammar/edge/), [QUALIFIER](/grammar/edge/qualifier/), [SOURCE](/grammar/edge/source/), [LABEL](/grammar/edge/label/), [ALIAS](/grammar/edge/alias/), [Slot marker](/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/grammar/reference/wikidata-qid/)
