---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE is a Value that holds a signed int32 day count with the proleptic Gregorian 1970-01-01 as day 0 (Codec 0x20)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE is a signed day count with the proleptic Gregorian `1970-01-01` as day 0. It holds no time zone or time of day.

## Layout

- Code: Value direct code `0x20`. Family TIME.
- It uses a fixed-width signed int32 physical type, the same as Arrow Date32 and Parquet `DATE`.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  3 WORD in total
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretation and Validity

- All 2 Payload WORDs are read as a 32-bit two's complement signed day count in big-endian WORD order.
- The valid range is `-2^31` to `2^31-1` days. A negative value is a date before the epoch.
- When converting a day count back to year, month, and day, the proleptic Gregorian calendar is used, with no historical calendar changeover.
- Even small values always use 2 WORDs.

## Length

- The total is exactly 3 WORDs, the TAG 1 WORD plus the Payload 2 WORD, using the direct length `LLLL=0010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 2 WORDs, reject.

## Examples

| Date | Payload | Total Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## Relation to EDTF

- Precision coarser than a day, uncertain or approximate, and intervals are written with [EDTF](/grammar/value/time/edtf/). A date that can be written exactly as GREGORIAN-DATE is not written as EDTF (EDTF canonical form).

## Standards Basis

- `DATE` in [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) is an `int32` that stores the number of days since the Unix epoch 1970-01-01 and uses signed ordering.
- Date32 in the [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) and the authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) stores the number of days since the Unix epoch as a 32-bit signed integer.
- The proleptic Gregorian back-conversion is the GEUL calendar profile adopted by this format. The int32 day-count meaning of Arrow/Parquet is kept as it is, and only the TAG and big-endian 16-bit WORD framing are added.
