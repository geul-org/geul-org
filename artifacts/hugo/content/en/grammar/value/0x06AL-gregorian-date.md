---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE is a signed day count with proleptic Gregorian 1970-01-01 as day 0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `GREGORIAN-DATE` (spec document BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| Spec document | `0x00000000/codecs/0x000006A0/` (DECLARE target `06A0`) |
| Section | 3 `0011` (Value), offset C within the section = 10 |
| Kind | Value · family: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Signed day count relative to proleptic Gregorian `1970-01-01` |
| Hugo side | `value/time/gregorian-date.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | raw value, 2 WORD |  |  |

GREGORIAN-DATE is a signed day count with proleptic Gregorian `1970-01-01` as day 0. It does not hold a time zone or a time of day.

## Layout {#레이아웃}

- Code: direct Value code `0x06AL`. Family TIME.
- It uses a fixed-width signed int32 physical type, the same as Arrow Date32 and Parquet `DATE`.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  total 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretation and validity {#해석과-유효성}

- The whole 2 WORD Payload is read as a 32-bit two's complement signed day count in big-endian WORD order.
- The valid range is `-2^31` to `2^31-1` days. A negative value is a date before the epoch.
- When converting a day count back to year, month, and day, the proleptic Gregorian calendar is used, with no historical calendar transition.
- Even a small value always uses 2 WORD.

## Length {#길이}

- The total is exactly 3 WORD, the TAG 1 WORD plus the Payload 2 WORD, and uses the direct length `LLLL=0010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 2 WORD, it is rejected.

## Examples {#예시}

| Date | Payload | Total Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## Relation to EDTF {#edtf와의-관계}

- Precision coarser than a day, uncertain or approximate dates, and intervals are written with [EDTF](0x06EL-edtf.md). A date that can be written exactly with GREGORIAN-DATE is not written with EDTF (EDTF canonical form).

## Standards basis {#표준-근거}

- `DATE` of [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) is an `int32` that stores the number of days since the Unix epoch, 1970-01-01, and uses signed ordering.
- Date32 of [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) and the authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) stores the number of days since the Unix epoch as a 32-bit signed integer.
- The proleptic Gregorian conversion is the GEUL calendar profile adopted by this format. It keeps the int32 day-count meaning of Arrow/Parquet as is and adds only the TAG and big-endian 16-bit WORD framing.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000006A0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
