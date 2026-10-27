---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS is a Value that holds a signed int64 second count from the Unix epoch (Codec 0x22)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS is a signed second count from the Unix epoch `1970-01-01T00:00:00Z`. Like the POSIX seconds-since-the-Epoch, it treats every day as exactly 86,400 seconds and does not count leap seconds.

## Layout

- Code: Value direct code `0x22`. Family TIME.
- For industrial data exchange, it uses a fixed-width signed int64 physical type, the same as Arrow `timestamp[s]`.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  5 WORD in total
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation and Validity

- All 4 Payload WORDs are read as a 64-bit two's complement signed count in big-endian WORD order.
- The valid range is `-2^63` to `2^63-1` seconds. A negative value is an instant before the epoch.
- Even small values always use 4 WORDs. It must not be shortened to the minimal-WORD integer representation.
- Time zone, the original UTC offset, leap-second labels, and leap-second tables are not held.

## Length

- The total is exactly 5 WORDs, the TAG 1 WORD plus the Payload 4 WORD, using the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 4 WORDs, reject.

## Examples

- The epoch is Payload `0000 0000 0000 0000`, 5 WORD in total, `LLLL=0100`.
- 1 second after the epoch is Payload `0000 0000 0000 0001`.
- 1 second before the epoch is Payload `ffff ffff ffff ffff`.

## Standards Basis

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) only defines the members `time_t tv_sec` and `long tv_nsec`, and does not define a wire format that serializes cumulative seconds as a signed int64. The concrete width and representation of `time_t` depend on the implementation environment and are not the same as the GEUL Payload representation.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) defines the calendar correspondence of seconds after the epoch and the 86,400-seconds-per-day rule.
- The [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) and the authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) define a timestamp as a 64-bit signed integer from a fixed epoch, and support the SECOND unit and non-counting of leap seconds. GEUL adds only the TAG and big-endian 16-bit WORD framing to this physical type.
