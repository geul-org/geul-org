---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS is a Value that holds a signed nanosecond count from 1970-01-01T00:00:00 TAI (BIPM Issuer format 0x4001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the same TAI epoch `1970-01-01T00:00:00 TAI`. This cumulative count representation is not a BIPM standard wire format but a GEUL-specific profile that maps the TAI time scale to a fixed-width signed int64.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0060` BIPM, format number `0x4001`. Family TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD in total
Issuer            1 WORD  0x0060 (BIPM)
Format number     1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and Validity

- All 4 Payload WORDs are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns. A negative value is a TAI instant before the epoch set by GEUL.
- Even small values always use 4 WORDs. No UTC offset or leap-second table is stored.

## Length

- The total is exactly 7 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 4 WORD, using the direct length `LLLL=0110`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, reject.

## Examples

- The GEUL TAI epoch is Payload `0000 0000 0000 0000`, 7 WORD in total, `LLLL=0110`.
- 1 ns after the epoch is Payload `0000 0000 0000 0001`.
- 1 ns before the epoch is Payload `ffff ffff ffff ffff`.

## Standards Basis and Format Status

- The [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) specifies the SI second and the International Atomic Time (TAI) time scale.
- BIPM does not define a signed int64 cumulative nanosecond count from the `1970-01-01 TAI` epoch or its wire encoding. The epoch, the count per unit, the signed int64, and the GEUL big-endian WORD placement are a GEUL-specific mapping.
- The fixed-width int64 was chosen for consistency of exchange with other TIME count profiles, and does not mean it reproduces a BIPM format as it is.
