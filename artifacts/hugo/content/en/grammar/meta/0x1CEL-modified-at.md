---
title: "MODIFIED-AT (0x1CEL)"
weight: 462
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Records the time the document was modified."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `MODIFIED-AT` (spec document BIND `MODIFIED-AT`) |
| TAG ID | `0x1CEL` |
| Codec ID | `0x00001CE0` |
| Spec document | `0x00000000/codecs/0x00001CE0/` (DECLARE target `1CE0`) |
| Section | 14 `1110` (Meta), offset within section C = 14 |
| Kind | Meta · class: provenance |
| TAG WORD | `0001 1100 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Modification time. TIME Value |
| Hugo side | `meta/provenance/modified-at.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Records the time the document was modified.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1110 LLLL      Codec 0x1CEL
[Length extension TAG]
Payload           One TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec: Meta `0x1CEL`, provenance class
- Payload: embedded Value (TIME family: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md), etc.)
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Choose the format from the TIME family of Values. When precision is needed, use a nanosecond format defined by an Issuer (for example, [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001CE0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CE000000000
BODY
#1 DECLARE 0x1CE0
#2 FIELD #1 record
#3 BIND #1 "MODIFIED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
