---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Records the retention period of the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `RETENTION` (spec document BIND `RETENTION`) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| Spec document | `0x00000000/codecs/0x00001E10/` (DECLARE target `1E10`) |
| Section | 15 `1111` (Meta), offset within section C = 1 |
| Kind | Meta · class: policy |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Retention period |
| Hugo side | `meta/policy/retention.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

Records the retention period of the document.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[Length extension TAG]
Payload           Expiry time (GREGORIAN-DATE, etc.) or duration (DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`, policy class
- Payload: embedded Value (TIME family: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), etc., or [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- If it is a duration, count from [RECORDED-AT](0x1D0L-recorded-at.md).

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E10/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
