---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Records the confidence of the whole document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `CONFIDENCE` (spec document BIND `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| Spec document | `0x00000000/codecs/0x00001E80/` (DECLARE target `1E80`) |
| Section | 15 `1111` (Meta), offset within section C = 8 |
| Kind | Meta · class: verification |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Confidence |
| Hugo side | `meta/verification/confidence.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | record | `0690` UNSIGNED-DECIMAL |  |

Records the confidence of the whole document. Record-level confidence is written as a QUALIFIER attached to the target Edge (the property is undecided, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[Length extension TAG]
Payload           UNSIGNED-DECIMAL Value, 0 or more and 1 or less
```

- Codec: Meta `0x1E8L`, verification class
- Payload: embedded Value ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Who assigned the value is written alongside with [GENERATED-BY](0x1D3L-generated-by.md) and the like.

## Open issues {#열린-문제}

- The scale (0 to 1) and its relation to TOULMIN verdicts.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E80/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
