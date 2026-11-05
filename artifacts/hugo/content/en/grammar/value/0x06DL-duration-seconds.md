---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS is an elapsed time in signed seconds with no epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DURATION-SECONDS` (spec document BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| Spec document | `0x00000000/codecs/0x000006D0/` (DECLARE target `06D0`) |
| Section | 3 `0011` (Value), offset C within the section = 13 |
| Kind | Value · family: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Signed SI-second elapsed time with no epoch |
| Hugo side | `value/time/duration-seconds.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | raw value, 4 WORD |  |  |

DURATION-SECONDS is an elapsed time in signed seconds with no epoch. It is not an instant or a calendar period of months or years.

## Layout {#레이아웃}

- Code: direct Value code `0x06DL`. Family TIME.
- It uses a fixed-width signed int64 physical type, the same as Arrow `Duration(SECOND)`.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation and validity {#해석과-유효성}

- The whole 4 WORD Payload is read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` seconds. The sign is the direction of elapse and does not point to an instant of any particular epoch.
- Even a small value always uses 4 WORD.

## Length {#길이}

- The total is exactly 5 WORD, the TAG 1 WORD plus the Payload 4 WORD, and uses the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORD, it is rejected.

## Examples {#예시}

- 0 seconds is Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 second is Payload `0000 0000 0000 0001`.
- -1 second is Payload `FFFF FFFF FFFF FFFF`.

## Standards basis {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designates `Schema.fbs` as the authoritative source of the Arrow standard data types.
- In Arrow's authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs), `Duration` is an absolute elapsed time independent of the calendar, supports the SECOND unit, and is always represented as an 8-byte signed integer. GEUL adds only the TAG and big-endian 16-bit WORD framing to this.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000006D0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
