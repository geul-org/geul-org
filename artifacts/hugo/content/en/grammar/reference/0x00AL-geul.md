---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL is a declaration Reference that points to an entity issued by geul.org under CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `GEUL` (a 5Q bundle. See the member table below for the name of each code) |
| TAG ID | `0x00AL~0x00EL` |
| Section | 0 `0000` (Reference entity), offset within section C = 10~14 |
| Kind | Reference · category: declaration |
| Hugo side | `reference/geul.md` |

## Members {#구성원}

This page covers one 5Q set, five codes together. The quantification is the offset within the section, `C % 5` ([Reference](_index.md#quantifier)). There is one codec document per code. The fields of the five codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Quantification | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | Remaining raw value (`0xFFFF`) |  |  |

GEUL is a declaration Reference that points to an entity issued by geul.org under CC0. It is a serial ID whose number carries no meaning. An identifier that carries meaning in its bits is handled by a separate Codec, [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[Length extension TAG]
GEUL ID           unsigned big-endian in the shortest width
```

- Small numbers are assigned to high-frequency entities. An ID that fits in 1 WORD takes 2 WORD in total.
- geul.org manages ID assignment and the registry. Only items from CC0 sources go into the registry.
- If Variable, it is an anonymous variable of that kind ([Reference](_index.md) Variable).

## Examples {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## Open problems {#열린-문제}

- The GEUL ID assignment rules and the public format of the registry.

## Related pages {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000000A0/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

The above is the codec document of `GEUL-IDENTIFIED` (`0x00AL`). The codec documents of the other members (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`) differ only in the codec ID of the DOC-ID, the DECLARE target, and the name bound in `#1` (BIND).
