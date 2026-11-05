---
title: "Record Structure"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "GEUL data is a sequence of records."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL data is a sequence of records. Every record starts with one TAG WORD.

## Record Layout {#레코드-레이아웃}

```
TAG WORD (16 bits)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[Length extension TAG]
[Codec extension TAG]
[Codec-specific TAG]
Payload
```

- The TAG WORD is `000K KKKC CCCC LLLL`. The upper 4 bits `KKKK` are the section `S = w >> 9`, and one section has 32 slots. `C` is the 5-bit offset within the section `(w >> 4) & 0x1F`.
- The TAG ID is written as `0x000L`. The first three digits are the 9-bit Codec position (`w >> 4`) combining the section and `C`, and `L` is the Length position. The actual WORD value writes a number in the L position (for example, TRIPLE is `0x0AAL`, and the TAG WORD of a 10 WORD TRIPLE is `0x0AA9`).
- Extension TAGs are placed only in the order above. The Length extension TAG is always immediately after the TAG WORD.
- The composition of the Codec-specific TAG and the Payload is set by each Codec specification. The length of the Codec-specific TAG is not written in the TAG WORD, because interpreting the Payload requires the codebook anyway.
- A Codec with subformats designates the subformat with a 1 WORD Codec-specific TAG (Edge WORLD and so on).

## Byte Order {#바이트-순서}

- Canonical serialization is big-endian.
- Bit fields are laid out from the most significant bit.
- Within a WORD, the upper byte comes first; for a value of several WORDs, the upper WORD is written first.
- The in-memory representation is left to the implementation.

## Kind (Section Range) {#kind-섹션-구간}

| Section | Kind | TAG ID | Definition |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | Points to an object. Identifies the object by Codec and object ID |
| 3·4 | Value | `0x060L~0x09FL` | Holds a value itself. The Codec determines the interpretation of the Payload |
| 5~13 | Edge | `0x0A0L~0x1BFL` | Binds other records as components. The Codec determines the role and order of the components |
| 14·15 | Meta | `0x1C0L~0x1FFL` | Speaks about documents and records |

- Kind is determined by the section range alone: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, the rest Meta. There are no exceptions.

- Kind is an immutable property of a Codec. Once assigned, a Codec does not change its Kind.
- Value and Edge have the same "Codec + Payload" form. Only an Edge has other records as components.
- Reference divides markers, pointers, the 5Q schemes, and REFERENCE-ISSUER into code tables. The quantifier is in the scheme code. The quantifier of REFERENCE-ISSUER is set by the Issuer document ([Reference](reference/_index.md)).

## Length (4 bits) {#length-4비트}

Length is the **total number of WORDs** the record occupies. It includes the TAG WORD, extension TAGs, the Payload, and the padding of the last WORD.

| Value | Meaning |
|---|---|
| `0000`~`1101` | 1~14 WORD (value + 1) |
| `1110` | Extended length 1: the total WORD count in the next 1 WORD (15~65,535) |
| `1111` | Extended length 2: the total WORD count in the next 2 WORDs (65,536~2³²−1) |

- 1~14 WORD must be written as a direct length. A wider notation is not canonical.
- The total WORD count of an extended length includes the Length extension TAG itself.
- No record exceeds 2³²−1 WORDs.
- A 1 WORD record is a single TAG WORD with no Payload. Use it only when the Codec specification allows (for example, Meta `BODY`, `END`, an empty byte string, a slot marker).
- Even without a codebook, a record can be skipped by `next record position = current record start + Length`.

## Codec (Section and C, 9 bits) {#codec-섹션과-c-9비트}

| TAG ID | Name | Meaning |
|---|---|---|
| Front of each Kind zone | Direct code | The Codec is determined by the TAG WORD alone |
| `0x05DL`, `0x09DL`, `0x1BDL` | REFERENCE-ISSUER-2WORD, VALUE-ISSUER-2WORD, EDGE-ISSUER-2WORD | Issuer 2 WORD and Codec number 2 WORD in the Codec extension TAG |
| `0x05EL`, `0x09EL`, `0x1BEL` | REFERENCE-ISSUER-4WORD, VALUE-ISSUER-4WORD, EDGE-ISSUER-4WORD | Issuer 4 WORD and Codec number 2 WORD in the Codec extension TAG |
| `0x05FL`, `0x09FL`, `0x1BFL` | REFERENCE-ISSUER-16WORD, VALUE-ISSUER-16WORD, EDGE-ISSUER-16WORD | Issuer 16 WORD and Codec number 2 WORD in the Codec extension TAG |

- **The last three slots of each Kind zone are ISSUER.** The Issuer width is the low 2 bits of C (`01` 2 WORD, `10` 4 WORD, `11` 16 WORD). Meta has no Issuer format.
- The `C` of a direct code is separate in each section. The same `C` value in a different section is a different Codec. The Codec ID of a direct code is the whole TAG WORD (L=0), so it contains the Kind.
- Issuer Codec numbers form one space per Issuer, regardless of Kind. The Issuer assigns them so that they do not overlap within its own `codecs/` ([Publication addresses and version lists](publishing.md#id-표기)).
- A Codec that is not a direct code is an `(Issuer, Codec number)` pair. The Codec number is defined by that Issuer ([Issuer and Publication](issuer.md)). An extension format goes under the Issuer of the body that established that format.
- A Codec that has a direct code is not separately registered as an Issuer format.
- Issuer formats exist for Reference, Value, and Edge. Meta is a common specification that only GEUL defines.
- The section (`w >> 9`) of an Edge direct code is the family. Value direct codes and Meta do not express family or class in bits. The meaning of a Codec number is set by the Issuer.
- A direct code cannot be reclaimed. Only formats whose frequency is confirmed are placed in direct codes.

## Issuer Format Record {#issuer-형식-레코드}

```
TAG WORD          ISSUER code (the last three slots of each Kind zone)
[Length extension TAG]
Issuer            2/4/16 WORD (the Codec sets the width)
Codec number      2 WORD. Defined by the Issuer
Payload           Set by the Codec document the Issuer issued
```

- The layout is the same for all three Kinds. If numbers run short, obtain one more Issuer.
- The Payload of an Edge (EDGE-ISSUER) starts with an Edge Id like other Edges. So the order is TAG, Issuer, Codec number, Edge Id, then the rest of the Payload.
- A decoder that does not know the format knows up to the Issuer and Codec number and skips by Length.

## Variable-Length Byte Strings {#가변-길이-바이트열}

For values whose length is in bytes, such as text, URIs, language tags, and opaque byte strings, assign the Codec (or Codec number) as an **even-odd pair**.

- If the lowest bit of the Codec (for a direct code, the lowest bit of C) is `0`, the byte count is even; if `1`, it is odd.
- Byte count = `2 × Payload WORD count − lowest bit`. There is no Byte Count field.
- If odd, the low byte of the last WORD is `0x00` padding. If it is not `0x00`, reject.
- An empty byte string is a 1 WORD record (TAG WORD only) of the even Codec.
- Values of fixed size, such as UUIDs, digests, and addresses, have no pair.

## Example: Reading a TAG WORD {#예-tag-word-읽기}

Let us read `0AA9`.

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, section 0101 (5, Edge), C 01010, Codec 0x0AAL (TRIPLE), Length 1001 (10 WORD)
```

This record is a 10 WORD Edge whose Codec is TRIPLE. Even without a codebook, we know the next record is 10 WORDs ahead.

## Slot Markers {#자리-표지}

The TAG WORDs `0x0000`, `0x0010`, and `0x0020` are 1 WORD records of Reference slot markers. They do not point to an object and fill a record field slot ([Slot markers](slot-marker.md)).

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, section 0 (Reference), C 0~2, LLLL 0000 (1 WORD)
```

| WORD | Name | Meaning | What it speaks about | Logic | World assumption | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | Not written | Document: this slot was not filled | No assertion | Open world | no snak |
| `0x0010` | UNKNOWN-VALUE | Unknown | World: a value exists; what it is is unknown | `∃x. P(s, x)` | Existence closed, identity open | `somevalue` |
| `0x0020` | NO-VALUE | None | World: no value exists | `¬∃x. P(s, x)` | Closed for (s, P, qualifying condition) | `novalue` |

- Example: if children (P40) is ABSENT, how many is unknown; if UNKNOWN-VALUE, one or more; if NO-VALUE, zero. If the end time (P582) is ABSENT, it is unknown whether it is still valid; if UNKNOWN-VALUE, it has ended but when is unknown; if NO-VALUE, it has not ended.
- A marker is valid only when the field's CODEC list names that WORD exactly. In wildcards, fields with no CODEC, HEAD and BODY record slots, and the Edge Id slot, it is invalid ([CODEC](edge/0x0BEL-codec.md)).
- Obligations of the reader:
  1. UNKNOWN-VALUE is not a value but an existence assertion. It is neither equal nor unequal to any value, and two UNKNOWN-VALUEs are not treated as the same value either. A TRIPLE holding UNKNOWN-VALUE is not merged as a duplicate.
  2. NO-VALUE is closed within the qualifying condition of that proposition. If it coexists with a value TRIPLE of the same Subject, Predicate, and rank whose qualifying conditions are not distinguishable, it is a contradiction, and a checker warns (it does not reject).
  3. rank applies equally. When choosing the representative value (truthy), TRIPLEs with either marker are also candidates.
  4. When used as a QUALIFIER value, it changes the meaning of that qualification (`P582 = UNKNOWN`: it has ended, time unknown. `P582 = NONE`: it has not ended).
  5. ABSENT says nothing about the world. A value that could not be carried over is not written as UNKNOWN-VALUE.

## Canonical Form {#정규형}

The same content must become the same bytes. Only then are the content hash and signature uniquely determined.

- Use the shortest notation for lengths (1~14 WORD as a direct length).
- Write integers in the shortest width. Follow the canonical form set by each Codec specification.
- Reject a record that is not in canonical form.
- Exception: for the target WORD of a [CODEC](edge/0x0BEL-codec.md), `L=1111` looks only at the section `KKKK`, regardless of the `C` value. The first slot of the section (`C = 0`) is recommended, and a different `C` in the same section is not rejected.
