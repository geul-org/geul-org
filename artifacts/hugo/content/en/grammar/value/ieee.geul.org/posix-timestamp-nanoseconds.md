---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the Unix epoch 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS is a signed nanosecond count from the Unix epoch `1970-01-01T00:00:00Z`. Like the POSIX seconds-since-the-Epoch, it treats every day as exactly 86,400 seconds and does not count leap seconds.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, codec number `0x00004000`. Family TIME.
- For industrial data interchange, it uses the same fixed-width signed int64 physical type as Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD in total
Issuer            2 WORD  0x0000000D (IEEE)
Codec number      2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and validity {#해석과-유효성}

- All 4 Payload WORD are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` ns, and the instant range is `1677-09-21 00:12:43.145224192Z` to `2262-04-11 23:47:16.854775807Z`.
- Small values always use 4 WORD as well. It must not be shortened to a minimal WORD integer representation.
- The timezone, the original UTC offset, leap-second labels, and leap-second tables are not carried.

## Length {#길이}

- The total is exactly 9 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 4 WORD, and it uses the direct length `LLLL=1000`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 4 WORD, it is rejected.

## Example {#예시}

- The epoch is the Payload `0000 0000 0000 0000`, 9 WORD in total, `LLLL=1000`.
- 1 ns after the epoch is the Payload `0000 0000 0000 0001`.
- 1 ns before the epoch is the Payload `FFFF FFFF FFFF FFFF`.

## Standards basis {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) defines the members `time_t tv_sec` and `long tv_nsec`, with `0 <= tv_nsec < 10^9`. The concrete width and representation of `time_t` depend on the implementation environment, and it does not define a cumulative-nanosecond signed int64 wire format that combines the two members.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) treats a day as exactly 86,400 seconds.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` of [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) stores nanoseconds from the Unix epoch as a single `int64`. GEUL adds only the TAG and big-endian 16-bit WORD framing to this physical type.
