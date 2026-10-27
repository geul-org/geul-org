---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS is a Value that holds a signed int64 nanosecond count from the Unix epoch (IEEE Issuer format 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the Unix epoch `1970-01-01T00:00:00Z`. Like the POSIX seconds-since-the-Epoch, it treats every day as exactly 86,400 seconds and does not count leap seconds.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, format number `0x4000`. Family TIME.
- For industrial data exchange, it uses a fixed-width signed int64 physical type, the same as Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD in total
Issuer            1 WORD  0x0040 (IEEE)
Format number     1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and Validity

- All 4 Payload WORDs are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns, and the instant range is `1677-09-21 00:12:43.145224192Z` to `2262-04-11 23:47:16.854775807Z`.
- Even small values always use 4 WORDs. It must not be shortened to the minimal-WORD integer representation.
- Time zone, the original UTC offset, leap-second labels, and leap-second tables are not held.

## Length

- The total is exactly 7 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 4 WORD, using the direct length `LLLL=0110`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, reject.

## Examples

- The epoch is Payload `0000 0000 0000 0000`, 7 WORD in total, `LLLL=0110`.
- 1 ns after the epoch is Payload `0000 0000 0000 0001`.
- 1 ns before the epoch is Payload `ffff ffff ffff ffff`.

## Standards Basis

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) defines the members `time_t tv_sec` and `long tv_nsec`, with `0 <= tv_nsec < 10^9`. The concrete width and representation of `time_t` depend on the implementation environment, and it does not define a wire format of a cumulative nanosecond signed int64 combining the two members.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) treats a day as exactly 86,400 seconds.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` in [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) stores nanoseconds since the Unix epoch in a single `int64`. GEUL adds only the TAG and big-endian 16-bit WORD framing to this physical type.
