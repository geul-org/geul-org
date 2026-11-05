---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX is a declaration Reference that points to a target with a GEUL SIDX (Semantic-aligned Index)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `GEUL-SIDX` (a 5Q bundle. See the member table below for the name of each code) |
| TAG ID | `0x00FL~0x013L` |
| Section | 0 `0000` (Reference entity), offset within section C = 15~19 |
| Kind | Reference · category: declaration |
| Hugo side | `reference/geul-sidx.md` |

## Members {#구성원}

This page covers one 5Q set, five codes together. The quantification is the offset within the section, `C % 5` ([Reference](_index.md#quantifier)). There is one codec document per code. The fields of the five codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Quantification | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | Remaining raw value (`0xFFFF`) |  |  |

GEUL-SIDX is a declaration Reference that points to a target with a GEUL SIDX (Semantic-aligned Index). A SIDX is an identifier that carries meaning (kind, attributes) in its bits.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[Length extension TAG]
SIDX              all the rest
```

- The Quantifier is the same as in the other declaration Codecs. If Variable, it is an anonymous variable of that kind ([Reference](_index.md) Variable). Quantification is done only by the 5Q code (`0x00FL~0x013L`, `C % 5`). No quantification is put into the SIDX value.
- The spec document declares the SIDX as one remaining-width raw-value field. It will change once the width rule is decided.

## Examples {#예시}

| SIDX | WORD sequence |
|---|---|
| (non-normative) 64-bit `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## Assignment policy {#배정-방침}

- Its role differs from [GEUL](0x00AL-geul.md). GEUL is an identity ID assigned mostly in order (auto increment), while GEUL-SIDX is a semantic address that gives close values to targets that are close in meaning.
- How close is determined by statistics built up from usage data. Until the statistics accumulate, use GEUL IDs; after a SIDX is assigned, link the GEUL and GEUL-SIDX of the same target with [SAME-NODE](../edge/0x0A1L-same-node.md).

## Open problems {#열린-문제}

- **Width.** To be decided by looking at the statistics. 4 WORD (64 bits), 16 WORD, and others are under review. A SIDX has meaning in its high bits, so the "shortest width" rule of the other declaration Codecs (no leading `0x0000`) cannot be used as is. So it will be a fixed width (or a fixed width per subformat). Until it is decided, the spec document declares the SIDX as a remaining-width raw value.
- **Stability of assignment.** For a Reference, the same integer value means the same target, and an assigned ID is not reused. To avoid moving an already assigned SIDX when the statistics change, append-only assignment (sparse assignment that leaves room near items close in meaning) is needed. If moves are frequent, decide whether to define the SIDX not as a permanent identifier but as an index tied to a registry edition.
- **Uniqueness.** If a SIDX is generated from bit meaning and can collide, that does not fit the premise "the same integer value is the same target". Resolve collisions at assignment time to guarantee uniqueness.
- The codebook and the public format of the registry.

## Related pages {#관련-페이지}

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000000F0/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

The above is the codec document of `GEUL-SIDX-IDENTIFIED` (`0x00FL`). The codec documents of the other members (`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`) differ only in the codec ID of the DOC-ID, the DECLARE target, and the name bound in `#1` (BIND).
