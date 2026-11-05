---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE is a Value that holds a GEDCOM 7 date value string, preserving dates in other calendars such as the Julian calendar exactly as written (Codec 0x070L/0x071L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE is a Value that holds a GEDCOM 7 date value string, preserving dates in other calendars such as the Julian calendar exactly as written (Codec 0x070L/0x071L).

| Item | Value |
|---|---|
| Name | `GEDCOM-DATE` (even/odd pair. Names per code are in the member table below) |
| TAG ID | `0x070L`·`0x071L` |
| Section | 3 `0011` (Value), offset within section C = 16~17 |
| Kind | Value · family: TIME |
| Index description | GEDCOM 7 date value string. Preserves the original notation of other calendars (Julian, etc.). Even/odd bytes |
| Hugo path | `value/time/gedcom-date.md` |

## Members {#구성원}

This page covers the two codes of an even/odd pair together. The even code is for values with an even byte count, the odd code for an odd byte count ([Record and TAG WORD](../record.md#가변-길이-바이트열)). There is one codec document per code. The fields of the two codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Byte count | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | even | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | odd | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | remaining raw bytes (`0xFFFF`) |  |  |

GEDCOM-DATE is a Value that holds the date value (`DateValue`) string of [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). It preserves, **exactly as written**, dates that the source wrote in a calendar other than the Gregorian calendar (Julian, etc.).

## Layout {#레이아웃}

- Code: Value direct codes `0x070L` (even bytes) and `0x071L` (odd bytes). Family TIME.
- The byte count is set by the least significant bit of the Codec and the number of Payload WORDs. It is `2 × Payload WORD count − least significant bit`, and no Byte Count is stored ([Value](_index.md)).

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = odd bytes)
[Length extension TAG] when the total is 15 WORDs or more
Payload WORD 1st ... Nth          ASCII bytes of the GEDCOM date string / last 0x00 if odd
```

## Interpretation and validity {#해석과-유효성}

- The byte sequence is an ASCII string that follows the GEDCOM 7 `DateValue` grammar. An empty string is invalid. GEDCOM allows an empty `DateValue`, but if there is no value, no record is written.
- Grammar summary: `[calendar] [[day] month] year [BCE]`. Prefixes may be added: `ABT`·`CAL`·`EST` (approximate), `BEF`·`AFT`·`BET … AND …` (range), `FROM … TO …` (period). The separator is a single space.
- Calendars: `GREGORIAN` (the default if omitted), `JULIAN`, `FRENCH_R`, `HEBREW`, and extension tags. Month names are fixed per calendar (the Julian calendar uses the same `JAN`…`DEC` as the Gregorian).
- Years are **historical**. There is no year 0, and years before the common era take `BCE` (`44 BCE` = 44 BCE). This differs by one year from the astronomical numbering of EDTF and GREGORIAN-DATE.
- The schema checks only the byte format: ASCII `0x20`~`0x7E`, non-empty, no leading or trailing space. The producer checks the grammar and whether the day actually exists. Example: `gedcom.ParseDate` in `github.com/cacack/gedcom-go/v3` (MIT). The `Validate` of this library checks days only in the Gregorian calendar, so it lets `JULIAN 30 FEB 1100` pass, and `ToGregorian` does not actually convert year and month precision. Checking that a date exists and normalizing it are done separately.
- **Where to use:** Write Gregorian dates with [GREGORIAN-DATE](0x06AL-gregorian-date.md) or [EDTF](0x06EL-edtf.md). Use GEDCOM-DATE for dates in other calendars whose original notation must be preserved.

## Use with a normalized value {#정규화된-값과-함께-쓰기}

- To compare and index the same date on the time axis, a Gregorian value is needed. For day precision, the exact counterpart is a GREGORIAN-DATE of the same day; for year and month precision, it is an EDTF interval in the Gregorian calendar for that period (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- How to hold the original notation (GEDCOM-DATE) and the normalized value together as two Values has not been decided yet (open problem).

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if present), and the Payload added together ([Length](../record.md)).

## Example {#예시}

| Date | Bytes | Total WORDs |
|---|---|---|
| `JULIAN 1300` | 11 (odd) | `0716 4A55 4C49 414E 2031 3330 3000` |

## Standards basis {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). The specification repository is licensed under Apache 2.0. GEUL only refers to the format and does not copy the text of the specification.
- ISO 8601, EDTF, XSD, and the CLDR calendar identifier (`u-ca`) do not include the Julian calendar. GEDCOM 7 is an open interchange format that handles calendar prefix, BCE, precision, and qualifiers in one grammar.

## Open problems {#열린-문제}

- How to write the original notation and the normalized value together (how to link the two in one TRIPLE).
- GEDCOM grammar checking in the schema.
- Century and decade precision. GEDCOM has no such format. Dates that cannot be carried over from Wikidata are kept as the original text in UTF8-TEXT.

## Related pages {#관련-페이지}

- [Value](_index.md), [EDTF](0x06EL-edtf.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000700/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

The above is the codec document of `GEDCOM-DATE-EVEN` (`0x070L`). The codec document of the other member (`GEDCOM-DATE-ODD`) differs only in the codec ID in the DOC-ID, the DECLARE target, and the name bound to `#1` (BIND).
