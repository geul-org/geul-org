---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS is a Value that holds a signed nanosecond count from the GPS epoch 1980-01-06T00:00:00 GPS (GPS Issuer format 0x4001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the GPS epoch `1980-01-06T00:00:00 GPS`. It is not divided by GPS week number or cut to the week-rollover width of the broadcast field.

This cumulative count representation is not the IS-GPS-200 broadcast wire format but a GEUL-specific profile that maps the GPS time scale to a fixed-width signed int64.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0063` GPS, format number `0x4001`. Family TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD in total
Issuer            1 WORD  0x0063 (GPS)
Format number     1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and Validity

- All 4 Payload WORDs are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns. A negative value is a GPS-time instant before the GPS epoch.
- The count is a continuous value running from the epoch. Truncation or rollover of the broadcast week-number field is not applied.
- Even small values always use 4 WORDs. UTC conversion parameters are not held.

## Length

- The total is exactly 7 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 4 WORD, using the direct length `LLLL=0110`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, reject.

## Examples

- The GPS epoch is Payload `0000 0000 0000 0000`, 7 WORD in total, `LLLL=0110`.
- 1 ns after the epoch is Payload `0000 0000 0000 0001`.
- 1 ns before the epoch is Payload `ffff ffff ffff ffff`.

## Standards Basis and Format Status

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) is the official distribution point of the GPS interface specifications.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) sets that GPS time is a continuous time scale and that week 0 starts at midnight on 1980-01-06, and defines the GPS week number and the time-of-week/Z-count broadcast fields.
- IS-GPS-200 does not define a wire representation that is a signed int64 of cumulative nanoseconds from the epoch. A continuous count in nanoseconds with no rollover, the signed int64, and the GEUL big-endian WORD placement are a GEUL-specific mapping.
