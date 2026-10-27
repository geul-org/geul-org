---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "A Value is a record that holds a value itself. The upper 2 bits of the Codec give the family (numbers and decimals, time, text, binary); frequently used formats are direct codes, and the rest are Issuer formats under standards bodies."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A Value is a record that holds a value itself. The Codec sets how the Payload is interpreted.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC
[Length extension TAG]
[Codec extension TAG]  for an Issuer format
Payload
```

- `LLLL` is the total WORD count including the TAG WORD, minus 1. 1 to 14 WORDs are a direct length, and 15 WORDs or more use an extended length.
- For an Issuer format, the Codec extension TAG holds the Issuer (width set by the Codec: 1/2/4/16 WORD) and a 1 WORD format number. The upper 2 bits of the format number are the family.
- A decoder knows the family and Length even without knowing the format.

## Families

The upper 2 bits of the Codec are the family. Direct codes (7 bits) and Issuer format numbers (16 bits) follow the same rule. So the family is known even without a codebook.

| Upper 2 bits | Family | Direct codes | Format numbers |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`-`0x1F` | `0x0000`-`0x3FFF` |
| `01` | TIME | `0x20`-`0x3F` | `0x4000`-`0x7FFF` |
| `10` | TEXT | `0x40`-`0x5F` | `0x8000`-`0xBFFF` |
| `11` | BINARY | `0x60`-`0x7B` | `0xC000`-`0xFFFF` |

- NUMERIC / DECIMAL are divided again by the third bit. `000` is NUMERIC and `001` is DECIMAL.
- Numeric values such as vectors, tensors, complex numbers, fractions, and intervals are NUMERIC. As an exception, BIT-VECTOR is BINARY. Language codes are TEXT.
- An Issuer-format record carries a Codec extension TAG (Issuer and format number). If the Payload is long (15 WORDs or more in total), a Length extension TAG is used.

## Direct Codes

| Codec | Name | Family | Description |
|---|---|---|---|
| `0x00` | [BOOL](/grammar/value/numeric/bool/) | NUMERIC | false or true |
| `0x01` | [SIGNED-INTEGER](/grammar/value/numeric/signed-integer/) | NUMERIC | An integer in minimal WORDs, two's complement |
| `0x02` | [UNSIGNED-INTEGER](/grammar/value/numeric/unsigned-integer/) | NUMERIC | An unsigned integer in minimal WORDs |
| `0x03` | [BINARY-FLOAT](/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/grammar/value/numeric/coordinate-earth/) | NUMERIC | Earth (WGS 84) latitude and longitude, and uncertainty (unit Reference) |
| `0x05` | [COORDINATE-GEO](/grammar/value/numeric/coordinate-geo/) | NUMERIC | A celestial body Reference, latitude and longitude, and uncertainty (unit Reference) |
| `0x06` | [QUANTITY](/grammar/value/numeric/quantity/) | NUMERIC | A numeric amount (integer, BINARY-FLOAT, decimal, fraction), a unit Reference, lower and upper bounds |
| `0x07` | [FRACTION](/grammar/value/numeric/fraction/) | NUMERIC | Fraction that preserves its notation (numerator and denominator records, not reduced) |
| `0x10` | [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, signed coefficient |
| `0x11` | [UNSIGNED-DECIMAL](/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, unsigned coefficient |
| `0x20` | [GREGORIAN-DATE](/grammar/value/time/gregorian-date/) | TIME | Day count from 1970-01-01 (Gregorian calendar) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/grammar/value/time/civil-time-nanoseconds/) | TIME | Nanoseconds since midnight |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/grammar/value/time/posix-timestamp-seconds/) | TIME | Seconds since the Unix epoch |
| `0x23` | [DURATION-SECONDS](/grammar/value/time/duration-seconds/) | TIME | Elapsed time in seconds |
| `0x24`/`0x25` | [EDTF](/grammar/value/time/edtf/) | TIME | ISO 8601-2 extended date string (year/month precision, uncertainty, intervals) |
| `0x26`/`0x27` | [GEDCOM-DATE](/grammar/value/time/gedcom-date/) | TIME | GEDCOM 7 date string (Julian and other calendars) |
| `0x40`/`0x41` | [UTF8-TEXT](/grammar/value/text/utf8-text/) | TEXT | A UTF-8 string with no language |
| `0x44`/`0x45` | [URI](/grammar/value/text/uri/) | TEXT | An RFC 3986 URI |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/) | TEXT | A BCP 47 language tag |
| `0x48` | [LANGUAGE-SHORT-CODE](/grammar/value/text/language-short-code/) | TEXT | A 1 WORD compressed language code |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/) | TEXT | Text with a language |
| `0x60` | [UUID](/grammar/value/binary/uuid/) | BINARY | An RFC 9562 UUID |
| `0x61` | [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/) | BINARY | A SHA-256 result |
| `0x62` | [SHA1-DIGEST](/grammar/value/binary/sha1-digest/) | BINARY | A SHA-1 result (for identification, such as git object IDs) |

- Codecs paired as even and odd are variable-length byte sequences. An even code has an even byte count, and an odd code has an odd one ([Records and the TAG WORD](/grammar/record/)).
- A direct code not in the table is reserved.

## Issuer Formats

A format not among the direct codes is placed under the Issuer of the body that established it, with a format number. A conventional format with no establishing body goes under ADHOC (`0x0001`), and a GEUL-specific format under GEUL (`0x0000`).

| Issuer | Example formats |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, integer and real vectors, tensors, complex numbers, fractions, intervals, quaternions, BLAKE3 |
| IETF `0x0020` | relative URI, CRC32C, IPv4 and IPv6 addresses |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, POSIX nanosecond timestamp, MAC address |
| KHRONOS `0x0041` | RGBA8 and BGRA8 pixels |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | TAI timestamps |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | GPS timestamps |

- A decoder that does not know a format knows only the family from the format number and skips the Payload.
- For large values such as images and video, referencing them by URI and SHA-256 is recommended over embedding them directly.
- A work inside a byte sequence follows its original license. The source and license are recorded in Meta.

## Format Bundles

The layout, interpretation, validity, and examples of each format are in the bundle pages.

| Bundle | Family | Formats |
|---|---|---|
| [numeric](/grammar/value/numeric/) | NUMERIC | BOOL, integers, floating point, coordinates, QUANTITY, FRACTION |
| [decimal](/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/grammar/value/time/) | TIME | Dates, times of day, timestamps, durations, EDTF, GEDCOM dates |
| [text](/grammar/value/text/) | TEXT | UTF-8 text, text with a language, URI, language codes |
| [binary](/grammar/value/binary/) | BINARY | UUID, digests, CRC, network addresses, opaque bytes, bit vectors |
| [vector](/grammar/value/vector/) | NUMERIC | Dense integer and real vectors, points and bounding boxes, RGBA and BGRA pixels |
| [tensor](/grammar/value/tensor/) | NUMERIC | Dense and packed tensors with format, rank, and shape |
| [etc](/grammar/value/etc/) | NUMERIC | Complex numbers, fractions, closed intervals, quaternions |

- The vector, tensor, and etc bundles are all NUMERIC-family Issuer formats (ADHOC, KHRONOS).

## Text

Text with a language and text without one are different values. "Paris" (a string) and "Paris" (French) are not equal.

| Format | Where it is used |
|---|---|
| UTF8-TEXT | Strings with no language, such as identifiers, codes, file names, and external IDs |
| UTF8-LANGUAGE-TEXT | Text with a language, such as names, titles, and sentences |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = text has an odd byte count)
[Length extension TAG]
Language          LANGUAGE-SHORT-CODE or LANGUAGE-BCP47-CODE record
Text              UTF-8 bytes (a trailing 0x00 if odd)
```

- Text is well-formed UTF-8 and is preserved as the original. Normalization is up to the side that compares and indexes.
- A name common to several languages is written with the language `mul`, and an undetermined language with `und`. A string with no language content is UTF8-TEXT.

Example: `"Douglas Adams"@en` (13 bytes, odd)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   language en    D o  u g  l a  s ␠  A d  a m  s (padding)
```

## Decimals and Quantities

An exact decimal is written as `C × 10^E`. The exponent `E` is 32 bits, and the coefficient `C` is two's complement in minimal WORDs. The number of digits of the original notation is kept as it is: `1.20` is `C=120, E=−2` and `1.2` is `C=12, E=−1`. The two notations represent the same number but are separate records with different bytes. The encoder does not normalize the notation arbitrarily. The value equality of the two records and the meaning of quantum (significant digits) are open questions ([SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/#open-questions)).

QUANTITY holds an amount, a unit, and bounds as one value.

```
TAG WORD          0000 1LLL L000 0110
[Length extension TAG]
Amount            numeric Value record (integer, BINARY-FLOAT, decimal, fraction)
Unit              Reference record (unit item), 0x0000 if unitless
Lower bound       numeric Value record, 0x0000 ABSENT if omitted
Upper bound       numeric Value record, 0x0000 ABSENT if omitted
```

- The unit is part of the value. The unit is not detached and written elsewhere (once detached, it cannot be known whether `652` is km or m).
- A value converted to SI units is not held. It can be calculated from the unit and a conversion table.
- `0x0000` is ABSENT, the marker that an optional field was omitted ([Codec specification document](/grammar/codec-spec/)).

Example: `652 km`, range `[651, 653]` (km = Wikidata Q828224)

```
0F06 0011                    TAG (extended length 17 WORD)
0990 0000 0000 028C          amount 652
0120 000C A340               unit Q828224
0990 0000 0000 028B          lower bound 651
0990 0000 0000 028D          upper bound 653
```

## Dates

| Precision | Format |
|---|---|
| Date (Gregorian calendar) | GREGORIAN-DATE |
| Year/month, uncertain (`1971~`), intervals | EDTF |
| Original notation of other calendars (Julian and so on) | GEDCOM-DATE |
| Time of day | POSIX, TAI, GPS timestamps |

- A date that can be written as GREGORIAN-DATE is not written as EDTF.

## Open Questions

- Public media formats (JPEG, PNG, MP4, MOV, and so on) are placed as BINARY format numbers of the IANA Issuer (`0x0021`). How to manage the mapping between media types and format numbers.
- The final list of Value direct codes. To be decided by measuring Value frequency in samples of statutes and business conversations (candidates: amounts, percentages, date ranges).
- The detailed specification and placement of 7 small scalars (ADHOC BFLOAT16, 4 ONNX FP8 kinds, OCP FP8-E8M0FNU and FP4-E2M1FN). It is undecided whether to move them into the reserved range for NUMERIC direct codes (`0x08`-`0x0F`). For now only format numbers are assigned.
