---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the GPS epoch 1980-01-06T00:00:00 GPS."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the GPS epoch `1980-01-06T00:00:00 GPS`. It is not divided by GPS week number or truncated to the week rollover width of the broadcast field.

This cumulative count representation is not the IS-GPS-200 broadcast wire format but a GEUL-specific profile that maps the GPS time scale onto a fixed-width signed int64.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000016` GPS, codec number `0x00004001`. Family TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD in total
Issuer            2 WORD  0x00000016 (GPS)
Codec number      2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and validity {#해석과-유효성}

- All 4 Payload WORD are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns. A negative value is a GPS-time instant before the GPS epoch.
- The count is a continuous value running from the epoch. No truncation or rollover of the broadcast week-number field is applied.
- Small values always use 4 WORD as well. No UTC conversion parameters are carried.

## Length {#길이}

- The total is exactly 9 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 4 WORD, and it uses the direct length `LLLL=1000`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 4 WORD, it is rejected.

## Example {#예시}

- The GPS epoch is the Payload `0000 0000 0000 0000`, 9 WORD in total, `LLLL=1000`.
- 1 ns after the epoch is the Payload `0000 0000 0000 0001`.
- 1 ns before the epoch is the Payload `FFFF FFFF FFFF FFFF`.

## Standards basis and formal status {#표준-근거와-형식-지위}

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) is the official distribution point of the GPS interface specifications.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) specifies that GPS time is a continuous time scale and that week 0 begins at midnight on 1980-01-06, and it defines the GPS week number and the time-of-week/Z-count broadcast fields.
- IS-GPS-200 does not define a signed int64 wire representation of a cumulative nanosecond count from the epoch. The rollover-free continuous count in nanoseconds, the signed int64, and the GEUL big-endian WORD placement are a GEUL-specific mapping.
