---
title: "Records and the TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Every record begins with a 16-bit TAG WORD. A 3-bit Prefix, 2-bit Kind, 4-bit Length, and 7-bit Codec determine the kind and length of the record."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL data is a sequence of records. Every record begins with one TAG WORD.

## Record Layout

```
TAG WORD (16 bits)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[Length extension TAG]
[Codec extension TAG]
[Codec-specific TAG]
Payload
```

- The TAG WORD is `000K KLLL LCCC CCCC`.
- Extension TAGs appear only in the order above. The Length extension TAG always comes right after the TAG WORD.
- The layout of the Codec-specific TAG and the Payload is set by each Codec specification. The length of the Codec-specific TAG is not written in the TAG WORD, because interpreting the Payload requires the codebook anyway.
- A Codec with subtypes specifies the subtype in one WORD of Codec-specific TAG (Edge WORLD and others).

## Byte Order

- Canonical serialization is big-endian.
- Bit fields are laid out from the most significant bit.
- Within a WORD the upper byte comes first, and for a value of several WORDs the upper WORD is written first.
- The in-memory representation is up to the implementation.

## Kind (2 bits)

| Value | Kind | TAG WORD | Definition |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | Points to a target. The Codec and the target ID identify the target |
| `01` | Value | `0000 1LLL LCCC CCCC` | Holds a value itself. The Codec determines how the Payload is interpreted |
| `10` | Edge | `0001 0LLL LCCC CCCC` | Binds other records together as components. The Codec determines the role and order of the components |
| `11` | Meta | `0001 1LLL LCCC CCCC` | Speaks about the document and its records |

- Kind is an immutable property of a Codec. A Codec, once assigned, never moves to another Kind.
- Value and Edge share the same "Codec + Payload" form. Only an Edge has other records as components.
- Reference splits the 7 Codec bits into a 4-bit Codec and a 3-bit Quantifier ([Reference](/grammar/reference/)).

## Length (4 bits)

Length is the **total number of WORDs** the record occupies. It includes the TAG WORD, extension TAGs, the Payload, and the padding in the last WORD.

| Value | Meaning |
|---|---|
| `0000`-`1101` | 1 to 14 WORDs (value + 1) |
| `1110` | Extended length 1: the next 1 WORD holds the total WORD count (15 to 65,535) |
| `1111` | Extended length 2: the next 2 WORDs hold the total WORD count (65,536 to 2³²−1) |

- 1 to 14 WORDs must be written as a direct length. A wider notation is not canonical.
- The total WORD count in an extended length includes the Length extension TAG itself.
- No record exceeds 2³²−1 WORDs.
- A 1 WORD record is a single TAG WORD with no Payload. It is used only when the Codec specification allows it (for example Meta `BODY` and `END`, an empty byte string, a slot marker).
- Even without a codebook, a record can be skipped with `next record position = current record start + Length`.

## Codec (7 bits)

| Value | Name | Meaning |
|---|---|---|
| `0x00`-`0x7B` | Direct code | The TAG WORD alone determines the Codec |
| `0x7C` | ISSUER-1WORD | The Codec extension TAG holds a 1 WORD Issuer and a 1 WORD format number |
| `0x7D` | ISSUER-2WORD | The Codec extension TAG holds a 2 WORD Issuer and a 1 WORD format number |
| `0x7E` | ISSUER-4WORD | The Codec extension TAG holds a 4 WORD Issuer and a 1 WORD format number |
| `0x7F` | ISSUER-16WORD | The Codec extension TAG holds a 16 WORD Issuer and a 1 WORD format number |

- The Codec number space is separate for each Kind. The same number under a different Kind is a different Codec.
- A Codec that is not a direct code is an `(Issuer, format number)` pair. The format number is defined by that Issuer ([Issuer and Publication](/grammar/issuer/)). An extended format goes under the Issuer of the body that established the format.
- A Codec that has a direct code is not listed again as an Issuer format.
- Issuer formats exist only for Value and Edge. Reference uses a 4-bit Codec, and Meta is a common specification defined only by GEUL.
- The upper bits of the Codec and format number indicate the family (Value, Edge) or class (Meta). The family is known even without a codebook.
- A direct code cannot be taken back. Only forms whose frequency has been confirmed go into direct codes.

## Issuer Format Record

```
TAG WORD          Codec = 0x7C-0x7F
[Length extension TAG]
Issuer            1/2/4/16 WORD (the Codec sets the width)
Format number     1 WORD. Upper bits are the family
Payload           Value set by the format
```

- A decoder that does not know the format knows only the family from the format number, and skips the Payload.

## Variable-Length Byte Strings

For values whose length is in bytes, such as text, URIs, language tags, and unidentified byte strings, the Codec (or format number) is assigned as an **even/odd pair**.

- If the least significant bit of the Codec is `0`, the byte count is even; if `1`, it is odd.
- Byte count = `2 × Payload WORD count − least significant bit`. There is no Byte Count field.
- If odd, the lower byte of the last WORD is `0x00` padding. If it is not `0x00`, reject the record.
- An empty byte string is a 1 WORD record (the TAG WORD only) with the even Codec.
- Values of a fixed size, such as UUIDs, digests, and addresses, have no pair.

## Example: Reading a TAG WORD

Let us read `148A`.

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10 (Edge), Length 1001 (10 WORDs), Codec 0x0A (TRIPLE)
```

This record is a 10 WORD Edge whose Codec is TRIPLE. Even without a codebook, you know the next record comes 10 WORDs later.

## Slot Marker

TAG WORDs `0x0000` to `0x0007` are 1 WORD records of the reserved Reference Codec `0000`. They do not point to a target; they fill a record field's slot ([Slot marker](/grammar/reference/slot-marker/)).

```
0x0000-0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00 (Reference), LLLL 0000 (1 WORD), CCCC 0000, MMM = marker number
```

| WORD | Name | Meaning | What it speaks about | Logic | World assumption | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | Not written | The document: this slot was not filled | No assertion | Open world | No snak |
| `0x0001` | UNKNOWN-VALUE | Unknown | The world: a value exists, but what it is is unknown | `∃x. P(s, x)` | Existence closed, identity open | `somevalue` |
| `0x0002` | NO-VALUE | None | The world: there is no value | `¬∃x. P(s, x)` | Closed with respect to (s, P, qualifying conditions) | `novalue` |
| `0x0003`-`0x0007` | Reserved | | | | | |

- Example: if children (P40) is ABSENT, the number of children is unknown; if UNKNOWN-VALUE, there is at least one; if NO-VALUE, there are none. If the end time (P582) is ABSENT, it is unknown whether the statement is still valid; if UNKNOWN-VALUE, it has ended but when is unknown; if NO-VALUE, it has not ended.
- The lower 3 bits `MMM` are the marker number, not a Quantifier (see the Quantifier exception in [Reference](/grammar/reference/)).
- A marker is valid only where the field's CODEC list names that exact WORD. It is invalid in a wildcard, in a field with no CODEC, in a HEAD or BODY record position, and in an Edge Id position ([CODEC](/grammar/edge/codec/)).
- Obligations of the reader:
  1. UNKNOWN-VALUE is an existence assertion, not a value. It is neither equal to nor different from any value, and two UNKNOWN-VALUEs are not treated as the same value. A TRIPLE holding UNKNOWN-VALUE is not merged as a duplicate.
  2. NO-VALUE is closed within the qualifying conditions of that proposition. If it coexists with a value TRIPLE of the same Subject, Predicate, and rank whose qualifying conditions are not distinguishable, that is a contradiction, and the checker warns (it does not reject).
  3. rank applies in the same way. When choosing the representative value (truthy), a TRIPLE with either marker is also a candidate.
  4. When used as a QUALIFIER value, it changes the meaning of that qualification (`P582 = UNKNOWN`: it has ended, time unknown. `P582 = NONE`: it has not ended).
  5. ABSENT says nothing about the world. Do not use UNKNOWN-VALUE for a value that could not be carried over.

## Canonical Form

The same content must produce the same bytes, so that the content hash and signature are uniquely determined.

- Length uses the shortest notation (1 to 14 WORDs use a direct length).
- Integers are written in the shortest width. Follow the canonical form set by each Codec specification.
- A record that is not in canonical form is rejected.
