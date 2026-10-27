---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS is a Value that holds an elapsed time as a signed int64 nanosecond count with no epoch (GEUL Issuer format 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS is an elapsed time in signed nanoseconds with no epoch. It is not an instant or a calendar month or year period.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, format number `0x4000`. Family TIME.
- It uses a fixed-width signed int64 physical type, the same as Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD in total
Issuer            1 WORD  0x0000 (GEUL)
Format number     1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and Validity

- All 4 Payload WORDs are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns. The sign is the direction of elapsed time and does not point to an instant at any epoch.
- Even small values always use 4 WORDs.

## Length

- The total is exactly 7 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 4 WORD, using the direct length `LLLL=0110`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, reject.

## Examples

- 0 ns is Payload `0000 0000 0000 0000`, 7 WORD in total, `LLLL=0110`.
- 1 ns is Payload `0000 0000 0000 0001`.
- -1 ns is Payload `ffff ffff ffff ffff`.

## Standards Basis

- The [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designates `Schema.fbs` as the authoritative source of the Arrow standard data types.
- In Arrow's authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs), `Duration` is an absolute elapsed time independent of the calendar, supports the NANOSECOND unit, and is always represented as an 8-byte signed integer. GEUL adds only the TAG and big-endian 16-bit WORD framing.
