---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declares the effective date of this version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `EFFECTIVE-FROM` (spec document BIND `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| Spec document | `0x00000000/codecs/0x00001C80/` (DECLARE target `1C80`) |
| Section | 14 `1110` (Meta), offset within section C = 8 |
| Kind | Meta · class: declaration |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The effective date of this version. A GREGORIAN-DATE or POSIX-TIMESTAMP Value. If absent, the publication time |
| Hugo side | `meta/declaration/effective-from.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Declares the effective date of this version. The effective date differs from the publication time ([revision](../document.md#개정)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[Length extension TAG]
Payload           One TIME Value
```

- Codec: Meta `0x1C8L`, declaration class
- Payload: embedded Value ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) or [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- If absent, the document takes effect from its publication time.
- If [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) is present, this value must precede it.
- If provisions take effect on different dates, write them separately on each provision's Edge with QUALIFIER P580 (start) and P582 (end) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- Read this value when interpreting the document as of a given point in time.

## Example {#예시}

- Effective 1970-01-02: `0x1C83 0x06A2 0x0000 0x0001`

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C80/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
