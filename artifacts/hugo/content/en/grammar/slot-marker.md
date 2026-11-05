---
title: "Slot Marker"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "A slot marker is a 1 WORD record that fills a record field slot."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A slot marker is a 1 WORD record that fills a record field slot. It points to nothing. These are the codes assigned to the first three slots `0x000L~0x002L` of Reference section 0. Each marker has its own page: [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

Three things can occupy a value slot: the value was not written, a value exists but is unknown, and no value exists. The three are different. The slot marker writes these three as three adjacent WORDs.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, section 0 (Reference), Codec 0~2, LLLL 0000 (1 WORD)
```

| WORD | Name | Meaning | Notation |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | Not written | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | Unknown: a value exists; what it is is unknown | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | None: no value exists | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | This TAG form (a marker with a Payload) is not assigned | |

- A marker has **no Quantifier.** The quantifier is read only from the 5Q schemes (`5 <= C < 30` in section 0, `C < 30` in section 1). Do not read `0x0010` UNKNOWN-VALUE as `C % 5` and interpret it as Generic ([Reference](reference/_index.md) Quantifier).
- It has no Payload. It has no object ID either.
- Even a decoder without a codebook sees from the TAG WORD alone that the Kind is Reference and that it is 1 WORD, and skips it. "A WORD value of `0x0000`, `0x0010`, or `0x0020` is a slot marker" is known by `w & 0xF == 0 && w <= 0x0020`.
- The notations `ABSENT`, `UNKNOWN`, and `NONE` are the text notation of `geul show` and `geul add`.

## Three Distinctions {#세-가지-구분}

| | Not written (ABSENT) | Unknown (UNKNOWN-VALUE) | None (NO-VALUE) |
|---|---|---|---|
| What it speaks about | **Document**: this slot was not filled | **World**: a value exists; what it is is unknown | **World**: no value exists |
| Logic | Asserts nothing | `∃x. P(s, x)`, x is not identified | `¬∃x. P(s, x)` |
| World assumption | Open world (no information) | Existence closed, identity open | Closed world for (s, P, qualifying condition) |
| Wikidata | The snak does not exist | `somevalue` | `novalue` |
| Where it is used | An optional field with CODEC target `0000` (SOURCE Origin and so on) | A field with CODEC target `0010` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | A field with CODEC target `0020` (TRIPLE Object, QUALIFIER Value) |
| "How many children (P40)?" | Unknown | One or more | 0 |
| "Is there an end time (P582)?" | Unknown → unknown whether still valid | It has ended; when is unknown | It has not ended (asserted) |

The same distinction holds at the level of a proposition. **A TRIPLE being absent from the document** is "not written". A GEUL document is an open world, so the absence of a statement does not mean the absence of a fact. "None" can be said only by **writing** NO-VALUE.

## Acceptance Rule {#수용-규칙}

- A slot marker is valid **only when the same WORD is an exact target** in the field's [CODEC](edge/0x0BEL-codec.md) list. Target `0000` means "optional field", `0010` means "accepts unknown", and `0020` means "accepts none".
- Wildcards (`000F`, `060F` and so on, `L=1111`) do not accept markers. Any Reference (`000F`·`020F`·`040F`) does not overlap with markers.
- A record field with no CODEC ("any record") does not accept markers either.
- A marker in the HEAD and BODY record slots or in the Edge Id slot is invalid.
- A marker cannot be used in a raw-value field. A raw value has no TAG, so there is no place for a 1 WORD marker.
- A CODEC list with only marker targets (always a marker) is invalid.
- What a marker means (what exists and what does not) is set by the Edge specification that accepts the marker. This matches the principle that quantification and negation are set by Edges, not by Reference.
- The meaning of markers and the acceptance rule are in [Layer 0](publishing.md#층) (built into the decoder). All three have no Payload, so there is no built-in cost either. Still, each code has a Codec document. The Codec document contains only DECLARE and no FIELD.

## Obligations of the Reader {#읽는-쪽의-의무}

These are written on each marker's page. The gist is as follows.

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무) is not a value but an existence assertion. It is neither equal nor unequal to any value, and its TRIPLE is not merged as a duplicate.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무) is closed within the qualifying condition of that proposition.
- For both markers, rank applies equally, and when used as a QUALIFIER value, they change the meaning of that qualification.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무) says nothing about the world. A value that could not be carried over is not written as UNKNOWN-VALUE.

## Difference from Other "None"s {#다른-없음과의-차이}

- A Codec rule that uses [LOCAL](reference/0x005L-local.md) `0` as "none" ([TOULMIN](toulmin/_index.md) REF and so on) is a convention within that Codec. It differs from a slot marker.
- An Identified LOCAL is not used as null or a sentinel. To write unknown or absent, use a marker in a field that accepts markers.

## Example {#예시}

The border between Q30 (United States) and Q34266 (Russian Empire), end time unknown. The Edge Ids are for illustration.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

The central bank of Q30: it did not exist during 1811 to 1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- The marker slot is 1 WORD. The TRIPLE becomes 9 WORD (`0AA8`) and the QUALIFIER 8 WORD (`0AB7`).
- In simple form, "no children (P40)" is `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Related Pages {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [Codec specification document](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
