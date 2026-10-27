---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF is a Value that holds dates in the ISO 8601-2 extended date string, such as year/month precision, BCE, uncertainty, and intervals (Codec 0x24/0x25)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF is a Value that holds a date as a string of the [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Library of Congress, ISO 8601-2:2019). It represents precision coarser than a day, BCE, uncertain, approximate, or partly unknown dates, and intervals.

## Layout

- Code: Value direct codes `0x24` (even bytes) and `0x25` (odd bytes). Family TIME. The Payload is a string, but it is placed in the TIME family so that decoders and indexes treat it as a time value even without knowing the format.
- The byte count is set by the lowest bit of the Codec and the Payload WORD count. It is `2 × Payload WORD count − lowest bit`, and no Byte Count is placed ([Value](/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = odd bytes)
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st ... Nth          ASCII bytes of the EDTF string / a trailing 0x00 if odd
```

## Interpretation and Validity

- The byte sequence is an ASCII string that follows the EDTF Level 0, 1, and 2 grammar. An empty string is invalid.
- Examples: day `1952-03-11`, month `1952-03`, year `1952`, decade `195X`, 44 BCE `-0043`, uncertain `1974?`, approximate `~1974`, interval `1952/2001`, large year `Y-13799999999`.
- Years are the ISO 8601 astronomical kind. `0000` is 1 BCE, and `-0043` is 44 BCE. When carrying over from historical notation, shift by one year.
- It is the Gregorian calendar. EDTF does not handle other calendars. The original notation of other calendars such as Julian is preserved with [GEDCOM-DATE](/grammar/value/time/gedcom-date/). A value that carries the same day or period over to the Gregorian calendar can be written as EDTF or GREGORIAN-DATE.
- **Canonical form:** a date that can be written exactly as [GREGORIAN-DATE](/grammar/value/time/gregorian-date/), that is, `[-]YYYY-MM-DD` with no qualifier (`?`, `~`, `%`), unknown digits (`X`), interval, or `Y` prefix, is written as GREGORIAN-DATE. Writing such a date as EDTF is invalid. Only if the same day is written in just one format can it be indexed and compared as time.
- The schema does not yet check the EDTF grammar. The producer checks with an EDTF parser. For example, `parser.ParseString` of `github.com/sfomuseum/go-edtf` (BSD-3-Clause). Do not use `parser.IsValid`, because it looks only at the grammar and lets `2023-02-29` and `1974-13` pass. This parser does not yet support `Y`-prefixed years.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload ([Length](/grammar/record/)).

## Examples

| Date | Bytes | Whole WORDs |
|---|---|---|
| `1974` | 4 (even) | `0924 3139 3734` |
| `197X` | 4 (even) | `0924 3139 3758` |
| `1952-03` | 7 (odd) | `0A25 3139 3532 2d30 3300` |

## Standards Basis

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0 is a subset of ISO 8601-1, and Levels 1 and 2 are features of ISO 8601-2.
- In RDF, the same string is marked with the datatype `http://id.loc.gov/datatypes/edtf`.

## Open Questions

- The checker's EDTF grammar check (whether the checker relies on an external library).
- Rules for carrying Wikidata century and millennium precision over into EDTF unknown digits.

## Related Pages

- [Value](/grammar/value/), [GREGORIAN-DATE](/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/grammar/value/time/gedcom-date/)
