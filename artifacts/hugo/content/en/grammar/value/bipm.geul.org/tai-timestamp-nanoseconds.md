---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1021
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the same TAI epoch, 1970-01-01T00:00:00 TAI."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the same TAI epoch `1970-01-01T00:00:00 TAI`. This cumulative count representation is not a BIPM standard wire format but a GEUL-specific profile that maps the TAI time scale onto a fixed-width signed int64.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000013` BIPM, codec number `0x00004001`. Family TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD in total
Issuer            2 WORD  0x00000013 (BIPM)
Codec number      2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and validity {#해석과-유효성}

- All 4 Payload WORD are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns. A negative value is a TAI instant before the epoch defined by GEUL.
- Small values always use 4 WORD as well. No UTC offset or leap-second table is stored.

## Length {#길이}

- The total is exactly 9 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 4 WORD, and it uses the direct length `LLLL=1000`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 4 WORD, it is rejected.

## Example {#예시}

- The GEUL TAI epoch is the Payload `0000 0000 0000 0000`, 9 WORD in total, `LLLL=1000`.
- 1 ns after the epoch is the Payload `0000 0000 0000 0001`.
- 1 ns before the epoch is the Payload `FFFF FFFF FFFF FFFF`.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) specifies the SI second and the International Atomic Time (TAI) time scale.
- BIPM does not define a signed int64 cumulative nanosecond count from the `1970-01-01 TAI` epoch or its wire encoding. The epoch, the count per unit, the signed int64, and the GEUL big-endian WORD placement are a GEUL-specific mapping.
- The fixed-width int64 was chosen for interchange consistency with other TIME count profiles, and it does not mean that a BIPM format is reproduced as is.
