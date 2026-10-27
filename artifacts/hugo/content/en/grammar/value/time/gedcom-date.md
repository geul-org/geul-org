---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE is a Value that preserves, as written, dates in other calendars such as the Julian calendar, as a GEDCOM 7 date value string (Codec 0x26/0x27)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE is a Value that holds a date value (`DateValue`) string of [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). It preserves, **exactly as written**, a date that the source wrote in a calendar other than Gregorian (Julian and so on).

## Layout

- Code: Value direct codes `0x26` (even bytes) and `0x27` (odd bytes). Family TIME.
- The byte count is set by the lowest bit of the Codec and the Payload WORD count. It is `2 × Payload WORD count − lowest bit`, and no Byte Count is placed ([Value](/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = odd bytes)
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st ... Nth          ASCII bytes of the GEDCOM date string / a trailing 0x00 if odd
```

## Interpretation and Validity

- The byte sequence is an ASCII string that follows the GEDCOM 7 `DateValue` grammar. An empty string is invalid. GEDCOM allows an empty `DateValue`, but if there is no value, no record is written.
- Grammar outline: `[calendar] [[day] month] year [BCE]`. `ABT`, `CAL`, `EST` (approximate), `BEF`, `AFT`, `BET … AND …` (range), and `FROM … TO …` (period) can be prefixed. The separator is a single space.
- Calendars: `GREGORIAN` (the default if omitted), `JULIAN`, `FRENCH_R`, `HEBREW`, and extension tags. Month names are fixed per calendar (the Julian calendar uses the same `JAN`…`DEC` as the Gregorian).
- Years are **historical**. There is no year 0, and BCE is marked with `BCE` (`44 BCE` = 44 BCE). It differs by one year from the astronomical numbering of EDTF and GREGORIAN-DATE.
- The schema checks only the byte form: ASCII `0x20`-`0x7E`, non-empty, no leading or trailing spaces. The grammar and whether the day really exists are checked by the producer. For example, `gedcom.ParseDate` of `github.com/cacack/gedcom-go/v3` (MIT). `Validate` of this library checks days only in the Gregorian calendar, so it lets `JULIAN 30 FEB 1100` pass, and `ToGregorian` does not actually convert year and month precision. Checking that a date exists and normalizing it are done separately.
- **Where it is used:** Gregorian dates are written as [GREGORIAN-DATE](/grammar/value/time/gregorian-date/) or [EDTF](/grammar/value/time/edtf/). GEDCOM-DATE is used for dates in other calendars whose original notation must be preserved.

## Using It with a Normalized Value

- To compare and index the same date on the time axis, a Gregorian value is needed. For day precision, the exact match is a GREGORIAN-DATE of the same day; for year and month precision, it is the EDTF Gregorian interval of that period (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- How to hold the original notation (GEDCOM-DATE) and the normalized value together as two Values is not yet decided (open question).

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload ([Length](/grammar/record/)).

## Example

| Date | Bytes | Whole WORDs |
|---|---|---|
| `JULIAN 1300` | 11 (odd) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## Standards Basis

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). The license of the specification repository is Apache 2.0. GEUL only refers to the format and does not copy the text of the specification.
- ISO 8601, EDTF, XSD, and the CLDR calendar identifier (`u-ca`) have no Julian calendar. GEDCOM 7 is a public interchange format that handles calendar prefixes, BCE, precision, and qualifiers in one grammar.

## Open Questions

- How to write the original notation and the normalized value together (how to link the two in one TRIPLE).
- Checking the GEDCOM grammar in the schema.
- Century and decade precision. GEDCOM has no such format. Dates that cannot be carried over from Wikidata keep the original as UTF8-TEXT.

## Related Pages

- [Value](/grammar/value/), [EDTF](/grammar/value/time/edtf/), [GREGORIAN-DATE](/grammar/value/time/gregorian-date/)
