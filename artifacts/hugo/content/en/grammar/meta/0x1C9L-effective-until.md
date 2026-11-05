---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declares the end of the validity period of this version (a time-limited law)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `EFFECTIVE-UNTIL` (spec document BIND `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| Spec document | `0x00000000/codecs/0x00001C90/` (DECLARE target `1C90`) |
| Section | 14 `1110` (Meta), offset within section C = 9 |
| Kind | Meta · class: declaration |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The end of the validity period of this version (time-limited law). If absent, until the next version takes effect |
| Hugo side | `meta/declaration/effective-until.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Declares the end of the validity period of this version (a time-limited law). From that time on, this version is not in force.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[Length extension TAG]
Payload           One TIME Value
```

- Codec: Meta `0x1C9L`, declaration class
- Payload: embedded Value ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) or [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- If absent, the version is valid until the next version takes effect.
- Once the validity period has passed, no edition is in force. The old edition is not revived.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C90/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
