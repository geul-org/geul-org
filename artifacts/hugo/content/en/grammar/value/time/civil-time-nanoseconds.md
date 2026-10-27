---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS is a Value that holds a civil time of day with no date as a nanosecond count after midnight (Codec 0x21)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS represents a civil time of day with no date as a nanosecond count after midnight.

## Layout

- Code: Value direct code `0x21`. Family TIME.
- It uses a fixed-width signed int64 physical type, the same as Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  5 WORD in total
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation and Validity

- All 4 Payload WORDs are read as a 64-bit two's complement signed count in big-endian WORD order.
- The physical type is signed int64, but the valid range is `0 <= value < 86,400×10^9` ns. Negative values and values at or above the upper bound are rejected.
- `24:00` and leap-second labels are not allowed. No date, time zone, or UTC offset is held either.
- Even small values always use 4 WORDs.

## Length

- The total is exactly 5 WORDs, the TAG 1 WORD plus the Payload 4 WORD, using the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, reject.

## Examples

- Midnight is Payload `0000 0000 0000 0000`, 5 WORD in total, `LLLL=0100`.
- 1 ns after midnight is Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns equals the upper bound, so it is not valid.
- `ffff ffff ffff ffff` is -1 as a signed int64, so it is not valid.

## Standards Basis

- In [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/), `TIME(isAdjustedToUTC=false, unit=NANOS)` stores nanoseconds after midnight of local time in an `int64` and uses signed ordering.
- The authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) of the [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) defines NANOSECOND Time as a 64-bit signed integer, limits the valid range to less than 86,400 seconds from midnight inclusive, and does not allow leap seconds. GEUL adds only the TAG and big-endian 16-bit WORD framing.
