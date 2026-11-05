---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS represents a civil time without a date as the number of nanoseconds after midnight."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `CIVIL-TIME-NANOSECONDS` (spec document BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| Spec document | `0x00000000/codecs/0x000006B0/` (DECLARE target `06B0`) |
| Section | 3 `0011` (Value), offset C within the section = 11 |
| Kind | Value · family: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Unsigned nanosecond count after midnight of a civil day |
| Hugo side | `value/time/civil-time-nanoseconds.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | raw value, 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS represents a civil time without a date as the number of nanoseconds after midnight.

## Layout {#레이아웃}

- Code: direct Value code `0x06BL`. Family TIME.
- It uses a fixed-width signed int64 physical type, the same as Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and validity {#해석과-유효성}

- The whole 4 WORD Payload is read as a 64-bit two's complement signed count in big-endian WORD order.
- The physical type is signed int64, but the valid range is `0 <= value < 86,400×10^9` ns. A negative value and a value at or above the upper bound are rejected.
- `24:00` and leap-second labels are not allowed. It does not hold a date, a time zone, or a UTC offset either.
- Even a small value always uses 4 WORD.

## Length {#길이}

- The total is exactly 5 WORD, the TAG 1 WORD plus the Payload 4 WORD, and uses the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORD, it is rejected.

## Examples {#예시}

- Midnight is Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 ns after midnight is Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns equals the upper bound, so it is not valid.
- `FFFF FFFF FFFF FFFF` is -1 as a signed int64, so it is not valid.

## Standards basis {#표준-근거}

- `TIME(isAdjustedToUTC=false, unit=NANOS)` of [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) stores the nanoseconds after midnight of a local time in an `int64` and uses signed ordering.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) and its authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) define NANOSECOND Time as a 64-bit signed integer, limit the valid range to less than 86,400 seconds including midnight, and do not allow leap seconds. GEUL adds only the TAG and big-endian 16-bit WORD framing.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000006B0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
