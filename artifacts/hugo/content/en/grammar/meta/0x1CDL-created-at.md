---
title: "CREATED-AT (0x1CDL)"
weight: 461
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Records the time the document was written (git author date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `CREATED-AT` (spec document BIND `CREATED-AT`) |
| TAG ID | `0x1CDL` |
| Codec ID | `0x00001CD0` |
| Spec document | `0x00000000/codecs/0x00001CD0/` (DECLARE target `1CD0`) |
| Section | 14 `1110` (Meta), offset within section C = 13 |
| Kind | Meta · class: provenance |
| TAG WORD | `0001 1100 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Creation time. TIME Value (git author date) |
| Hugo side | `meta/provenance/created-at.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Records the time the document was written (git author date).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1101 LLLL      Codec 0x1CDL
[Length extension TAG]
Payload           One TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec: Meta `0x1CDL`, provenance class
- Payload: embedded Value (TIME family: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md), etc.)
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Choose the format from the TIME family of Values. When precision is needed, use a nanosecond format defined by an Issuer (for example, [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001CD0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CD000000000
BODY
#1 DECLARE 0x1CD0
#2 FIELD #1 record
#3 BIND #1 "CREATED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
