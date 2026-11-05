---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS is a signed count of seconds since the Unix epoch 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `POSIX-TIMESTAMP-SECONDS` (spec document BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| Spec document | `0x00000000/codecs/0x000006C0/` (DECLARE target `06C0`) |
| Section | 3 `0011` (Value), offset C within the section = 12 |
| Kind | Value · family: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Signed second count since the Unix/POSIX epoch |
| Hugo side | `value/time/posix-timestamp-seconds.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | raw value, 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS is a signed count of seconds since the Unix epoch `1970-01-01T00:00:00Z`. Like POSIX seconds-since-the-Epoch, it treats every day as exactly 86,400 seconds and does not count leap seconds.

## Layout {#레이아웃}

- Code: direct Value code `0x06CL`. Family TIME.
- For industry data exchange, it uses a fixed-width signed int64 physical type, the same as Arrow `timestamp[s]`.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation and validity {#해석과-유효성}

- The whole 4 WORD Payload is read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` seconds. A negative value is an instant before the epoch.
- Even a small value always uses 4 WORD. It must not be shortened to a minimum-WORD integer representation.
- It does not hold a timezone, an original UTC offset, a leap-second label, or a leap-second table.

## Length {#길이}

- The total is exactly 5 WORD, the TAG 1 WORD plus the Payload 4 WORD, and uses the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORD, it is rejected.

## Examples {#예시}

- The epoch is Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 second after the epoch is Payload `0000 0000 0000 0001`.
- 1 second before the epoch is Payload `FFFF FFFF FFFF FFFF`.

## Standards basis {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) only defines the members `time_t tv_sec` and `long tv_nsec`; it does not define a wire format that serializes cumulative seconds as a signed int64. The concrete width and representation of `time_t` depend on the implementation environment and are not the same as the GEUL Payload representation.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) defines the calendar correspondence of seconds since the epoch and the rule of 86,400 seconds per day.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) and the authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) define a timestamp as a 64-bit signed integer since a fixed epoch, and support the SECOND unit and non-counting of leap seconds. GEUL adds only the TAG and big-endian 16-bit WORD framing to this physical type.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000006C0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
