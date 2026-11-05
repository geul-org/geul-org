---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF is a Value that holds dates such as year or month precision, BCE, uncertain dates, and intervals as an ISO 8601-2 extended date string (Codec 0x06EL/0x06FL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF is a Value that holds dates such as year or month precision, BCE, uncertain dates, and intervals as an ISO 8601-2 extended date string (Codec 0x06EL/0x06FL).

| Item | Value |
|---|---|
| Name | `EDTF` (even/odd pair; the names per code are in the member table below) |
| TAG ID | `0x06EL`, `0x06FL` |
| Section | 3 `0011` (Value), offset C within the section = 14 to 15 |
| Kind | Value · family: TIME |
| Index description | EDTF (ISO 8601-2) date string. Even and odd byte counts. A date that can be written with GREGORIAN-DATE is not written this way |
| Hugo side | `value/time/edtf.md` |

## Members {#구성원}

This page covers the two codes of the even/odd pair together. The even code is for values with an even number of bytes, and the odd code for an odd number ([Record and TAG WORD](../record.md#가변-길이-바이트열)). There is one codec document per code. The fields of the two codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Byte count | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | even | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | odd | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | remaining raw value (`0xFFFF`) |  |  |

EDTF is a Value that holds a date as an [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Library of Congress, ISO 8601-2:2019) string. It represents precision coarser than a day, BCE, uncertain, approximate, or partly unknown dates, and intervals.

## Layout {#레이아웃}

- Code: direct Value code `0x06EL` (even bytes) and `0x06FL` (odd bytes). Family TIME. The Payload is a string, but it is placed in the TIME family.
- The byte count is determined by the least significant bit of the Codec and the Payload WORD count. It is `2 × Payload WORD count − least significant bit`, and no Byte Count is stored ([Value](_index.md)).

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = odd bytes)
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st ... Nth          ASCII bytes of the EDTF string / last 0x00 if odd
```

## Interpretation and validity {#해석과-유효성}

- The byte sequence is an ASCII string that follows the EDTF Level 0, 1, and 2 grammar. An empty string is invalid.
- Examples: day `1952-03-11`, month `1952-03`, year `1952`, decade `195X`, 44 BCE `-0043`, uncertain `1974?`, approximate `~1974`, interval `1952/2001`, large year `Y-13799999999`.
- Years are in the ISO 8601 astronomical style. `0000` is 1 BCE and `-0043` is 44 BCE. When converting from historical notation, shift by one year.
- It is the Gregorian calendar. EDTF does not handle other calendars. The original notation of other calendars such as the Julian calendar is preserved with [GEDCOM-DATE](0x070L-gedcom-date.md). The value of the same day or period converted to the Gregorian calendar can be written with EDTF or GREGORIAN-DATE.
- **Canonical form:** a date that can be written exactly with [GREGORIAN-DATE](0x06AL-gregorian-date.md), that is, `[-]YYYY-MM-DD` with no qualifier (`?`, `~`, `%`), unknown digit (`X`), interval, or `Y` prefix, is written with GREGORIAN-DATE. Writing such a date with EDTF is invalid. The same day must be written in only one format so that it can be indexed and compared as time.
- The schema does not yet check the EDTF grammar. The producer checks with an EDTF parser. Example: `parser.ParseString` of `github.com/sfomuseum/go-edtf` (BSD-3-Clause). Do not use `parser.IsValid`, because it looks at the grammar only and lets `2023-02-29` and `1974-13` pass. This parser does not yet support `Y`-prefixed years.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload ([Length](../record.md)).

## Examples {#예시}

| Date | Bytes | Total WORD |
|---|---|---|
| `1974` | 4 (even) | `06E2 3139 3734` |
| `197X` | 4 (even) | `06E2 3139 3758` |
| `1952-03` | 7 (odd) | `06F4 3139 3532 2D30 3300` |

## Standards basis {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0 is a subset of ISO 8601-1, and Levels 1 and 2 are features of ISO 8601-2.
- In RDF, the same string is denoted with the datatype `http://id.loc.gov/datatypes/edtf`.

## Open problems {#열린-문제}

- The EDTF grammar check of the validator (whether the validator will rely on an external library).
- The rule for carrying Wikidata century and millennium precision as EDTF unknown digits.

## Related pages {#관련-페이지}

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000006E0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

The above is the codec document of `EDTF-EVEN` (`0x06EL`). The codec document of the other member (`EDTF-ODD`) differs only in the codec ID of the DOC-ID, the DECLARE target, and the name (BIND) bound in `#1`.
