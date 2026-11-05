---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS is an elapsed time in signed nanoseconds with no epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS is an elapsed time in signed nanoseconds with no epoch. It is not an instant or a calendar period of months or years.

| Item | Value |
|---|---|
| Name | `DURATION-NANOSECONDS` (spec document BIND `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| Spec document | `0x00000000/codecs/0x00000810/` (DECLARE target `0810`) |
| Section | 4 `0100` (Value), offset within section C = 1 |
| Kind | Value · family: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Elapsed time in signed nanoseconds with no epoch |
| Hugo path | `value/time/duration-nanoseconds.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | raw 4 WORDs |  |  |

## Layout {#레이아웃}

- Code: Value direct code `0x081L`. Family TIME.
- It uses the same fixed-width signed int64 physical type as Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  5 WORDs in total
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16 bits
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16 bits
```

## Interpretation and validity {#해석과-유효성}

- Read all 4 Payload WORDs as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns. The sign is the direction of elapsed time and does not point to an instant at a particular epoch.
- Even small values always use 4 WORDs.

## Length {#길이}

- The total is exactly 5 WORDs, the TAG 1 WORD plus the Payload 4 WORDs, and uses the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, it is rejected.

## Examples {#예시}

- 0 ns is Payload `0000 0000 0000 0000`, 5 WORDs in total, `LLLL=0100`. The whole is `0814 0000 0000 0000 0000`.
- 1 ns is Payload `0000 0000 0000 0001`.
- -1 ns is Payload `FFFF FFFF FFFF FFFF`.

## Standards basis {#표준-근거}

- The [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designates `Schema.fbs` as the authoritative source of Arrow standard data types.
- In the authoritative Arrow [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs), `Duration` is an absolute elapsed time independent of the calendar, supports the NANOSECOND unit, and is always represented as an 8-byte signed integer. GEUL adds only the TAG and big-endian 16-bit WORD framing.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000810/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
