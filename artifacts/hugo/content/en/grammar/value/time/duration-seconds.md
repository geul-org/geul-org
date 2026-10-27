---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS is a Value that holds an elapsed time as a signed int64 second count with no epoch (Codec 0x23)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS is an elapsed time in signed seconds with no epoch. It is not an instant or a calendar month or year period.

## Layout

- Code: Value direct code `0x23`. Family TIME.
- It uses a fixed-width signed int64 physical type, the same as Arrow `Duration(SECOND)`.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  5 WORD in total
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation and Validity

- All 4 Payload WORDs are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` seconds. The sign is the direction of elapsed time and does not point to an instant at any epoch.
- Even small values always use 4 WORDs.

## Length

- The total is exactly 5 WORDs, the TAG 1 WORD plus the Payload 4 WORD, using the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, reject.

## Examples

- 0 seconds is Payload `0000 0000 0000 0000`, 5 WORD in total, `LLLL=0100`.
- 1 second is Payload `0000 0000 0000 0001`.
- -1 second is Payload `ffff ffff ffff ffff`.

## Standards Basis

- The [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designates `Schema.fbs` as the authoritative source of the Arrow standard data types.
- In Arrow's authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs), `Duration` is an absolute elapsed time independent of the calendar, supports the SECOND unit, and is always represented as an 8-byte signed integer. GEUL adds only the TAG and big-endian 16-bit WORD framing.
