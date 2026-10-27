---
title: "Slot Marker"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Slot markers are a set of 1 WORD records placed in the reserved Reference Codec 0000. 0x0000 ABSENT (not written), 0x0001 UNKNOWN-VALUE (unknown), and 0x0002 NO-VALUE (none) fill the slot of a record field."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A slot marker is a 1 WORD record that fills the slot of a record field. It points to nothing. It is placed in the reserved Reference Codec `0000`.

There are three things that can stand in a value slot: the value was not written, a value exists but it is unknown what it is, and there is no value. The three are different. Slot markers keep them apart in three neighboring WORDs.

## Layout

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00 (Reference), LLLL 0000 (1 WORD), CCCC 0000, MMM = marker number
```

| WORD | Name | Meaning | Notation |
|---|---|---|---|
| `0x0000` | ABSENT | Not written | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | Unknown: a value exists. It is unknown what it is | `UNKNOWN` |
| `0x0002` | NO-VALUE | None: there is no value | `NONE` |
| `0x0003`-`0x0007` | Reserved | | |
| CCCC `0000`, LLLL ≥ `0001` | Reserved | Markers with a Payload will be decided later | |

- The lower 3 bits `MMM` are the **marker number, not a Quantifier**. They share only the position name with the `QQQ` of other Reference Codecs, and their meanings do not carry over (Quantifier exception in [Reference](/grammar/reference/)).
- There is no Payload. There is no target ID either.
- Even a decoder with no codebook knows from the TAG WORD alone that it is Kind Reference and 1 WORD, and skips it. "If the WORD value is `0` to `7`, it is a slot marker" is known by a single bit test (`w & 0xFFF8 == 0`).
- The notations `ABSENT`, `UNKNOWN`, and `NONE` are the text notations of `geul show` and `geul add`.

## Three Distinctions

| | Not written (ABSENT) | Unknown (UNKNOWN-VALUE) | None (NO-VALUE) |
|---|---|---|---|
| What it speaks about | **The document**: this slot was not filled | **The world**: a value exists. It is unknown what it is | **The world**: there is no value |
| Logic | Asserts nothing | `∃x. P(s, x)`, x is not identified | `¬∃x. P(s, x)` |
| World assumption | Open world (no information) | Existence closed, identity open | Closed world with respect to (s, P, qualifying conditions) |
| Wikidata | No such snak | `somevalue` | `novalue` |
| Where it is used | Optional fields with CODEC target `0000` (SOURCE Origin and so on) | Fields with CODEC target `0001` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | Fields with CODEC target `0002` (TRIPLE Object, QUALIFIER Value) |
| "How many children (P40)?" | Unknown | At least 1 | 0 |
| "Is there an end time (P582)?" | Unknown → unknown whether still valid | It ended. When is unknown | It has not ended (asserted) |

The same distinction holds at the level of a proposition. **A TRIPLE being absent from the document** is "not written". A GEUL document is an open world, so the absence of a statement does not mean the fact does not exist. "None" can be said only by **writing** NO-VALUE.

## Acceptance Rule

- A slot marker is valid **only when the same WORD is in the field's [CODEC](/grammar/edge/codec/) list as an exact target**. Target `0000` means "optional field", `0001` means "accepts unknown", and `0002` means "accepts none".
- A wildcard (`0780`, `0781`, `0F80`, and so on) does not accept markers. A Reference wildcard also does not overlap Codec `0000`.
- A record field with no CODEC ("any record") also does not accept markers.
- A marker in a HEAD or BODY record position or in an Edge Id position is invalid.
- A marker cannot be used in a raw-value field. A raw value has no TAG, so there is no room for a 1 WORD marker.
- A CODEC list containing only marker targets (always a marker) is invalid.
- What a marker means (what exists and what does not) is set by the specification of the Edge that accepts it. This is the same principle that quantification and negation are set by the Edge, not by the Reference.
- A slot marker has no Codec specification document. It is [Layer 0](/grammar/publishing/#layers) (built into the decoder). The Reference target of a DECLARE leaves the Quantifier position at 0, so no specification documents for `0x0001` and `0x0002` can be made; and since none of the three has a Payload, there is no cost to building them in.

## Obligations of the Reader

1. **UNKNOWN-VALUE is an existence assertion, not a value.** It is neither equal nor unequal to any other value (the comparison result is undetermined). Two UNKNOWN-VALUEs are not treated as the same value either. Each occurrence is an independent existential quantification (the same as a Wikidata blank node).
   - So two TRIPLEs with identical bytes (`P40 Q… UNKNOWN` ×2) are not duplicates. There may be two children, or one. A TRIPLE holding UNKNOWN-VALUE is not merged as a duplicate.
   - When the identity is revealed later, issue a new version with that TRIPLE corrected. UNKNOWN-VALUE cannot be pointed to. If coreference is needed, use a LOCAL Variable ([Reference](/grammar/reference/), Variable).
2. **NO-VALUE is closed within the qualifying conditions of that proposition.** When QUALIFIERs are attached, it is closed only in that scope. Q30 P1304 NO-VALUE (P580 1811, P582 1816) means there was no central bank only in 1811 to 1816, and it does not contradict a value TRIPLE of the same property (Federal Reserve System, preferred).
   - If NO-VALUE and a value TRIPLE of the same Subject and Predicate coexist with the same rank, and their qualifying conditions are not distinguished, that is a contradiction. The checker emits a warning. It does not reject. This state also exists in Wikidata, and the reader chooses by rank.
3. **rank applies in the same way.** When choosing the representative value (truthy), UNKNOWN-VALUE and NO-VALUE TRIPLEs are also candidates. If a preferred one exists, only the preferred remains.
4. **When used as a QUALIFIER value, it changes the meaning of that qualification.** `P582 = UNKNOWN` means it has ended and the time is unknown. It is not read as a proposition that is still valid. `P582 = NONE` asserts that it has not ended. If there is no P582 QUALIFIER at all, it is unknown whether it ended.
5. **ABSENT says nothing about the world.** It is not read as UNKNOWN-VALUE or NO-VALUE. Conversely, it is forbidden for a converter to write a value it could not carry over (a value that exists in the source) as UNKNOWN-VALUE, because the source knows the value. A slot the source does not speak to (for example, the [SOURCE](/grammar/edge/source/) Origin of a source that does not describe its origin) is also written as ABSENT by a converter. UNKNOWN-VALUE is an assertion that "it exists", so it is used only when the source says so.

## Difference from Other "None"s

- A Codec rule that uses [LOCAL](/grammar/reference/local/) `0` as "none" ([TOULMIN](/grammar/edge/toulmin/) REF and so on) is a convention inside that Codec. It differs from a slot marker.
- An Identified LOCAL is not used as a null or sentinel. To write unknown or absent, use a marker in a field that accepts markers.

## Example

The border between Q30 (United States) and Q34266 (Russian Empire), end time unknown. Edge Ids are for explanation.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Q30 central bank: there was none in 1811 to 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- The marker slot is 1 WORD. The TRIPLE becomes 9 WORDs (`140A`) and the QUALIFIER 8 WORDs (`138B`).
- In its simplest form, "no children (P40)" is `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Related Pages

- [Reference](/grammar/reference/), [CODEC](/grammar/edge/codec/), [Codec specification document](/grammar/codec-spec/)
- [TRIPLE](/grammar/edge/triple/), [QUALIFIER](/grammar/edge/qualifier/), [TOULMIN](/grammar/edge/toulmin/)
