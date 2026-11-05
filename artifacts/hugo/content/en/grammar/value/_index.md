---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "A Value is a record that holds a value itself."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A Value is a record that holds a value itself. The Codec sets how the Payload is interpreted.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      sections 3·4 (0x060L~0x09FL)
[Length extension TAG]
[Codec extension TAG]  for an Issuer format
Payload
```

- `LLLL` is the total WORD count including the TAG WORD, minus 1. 1 to 14 WORDs are a direct length, and 15 WORDs or more use an extended length.
- For an Issuer format, the Codec extension TAG holds the Issuer (width set by the Codec: 2/4/16 WORDs) and a 2 WORD codec number. The codec number is set by the Issuer.
- A decoder knows the Kind, Length, Issuer, and codec number even without knowing the format.

## Families {#계열}

A Value number does not denote a family. Direct codes do not express the family in their bits, and Issuer formats have no family rule either. A family is a grouping by subject.

| Family | Direct codes |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- Numeric values such as vectors, tensors, complex numbers, fractions, and intervals are NUMERIC. As an exception, BIT-VECTOR is BINARY. Language codes are TEXT.
- An Issuer-format record carries a Codec extension TAG (Issuer and codec number). If the Payload is long (15 WORDs or more in total), a Length extension TAG is used.

## Direct codes {#직접-코드}

| Codec | Name | Family | Description |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false or true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | Two's complement integer in the minimum number of WORDs |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | Unsigned integer in the minimum number of WORDs |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | Earth (WGS 84) latitude and longitude with uncertainty (unit Reference) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Celestial body Reference with latitude and longitude, and uncertainty (unit Reference) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | Numeric amount (integer, BINARY-FLOAT, decimal, fraction), unit Reference, lower and upper bounds |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | Fraction that preserves notation (numerator and denominator records, not reduced) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, signed coefficient |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, unsigned coefficient |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | Number of days since 1970-01-01 (Gregorian calendar) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | Nanoseconds since midnight |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | Seconds since the Unix epoch |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | Elapsed time (seconds) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | ISO 8601-2 extended date string (year and month precision, uncertainty, intervals) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | GEDCOM 7 date string (other calendars such as Julian) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | UTF-8 string with no language |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | RFC 3986 URI |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | BCP 47 language tag |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | Language-tagged text |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | 1 WORD compressed language code |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | RFC 9562 UUID |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | SHA-256 result |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | SHA-1 result (for identification, such as git object IDs) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | Byte sequence of unknown meaning and format. Even/odd bytes |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | N bits stored MSB-first after the bit count |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | Elapsed time (nanoseconds) |

- Codecs paired as even/odd are variable-length byte sequences. The even code is for an even byte count, the odd code for an odd byte count ([Record and TAG WORD](../record.md)).
- Direct codes occupy `0x060L~0x081L` with no Reserved gaps. `0x082L~0x09CL` are Reserved, and `0x09DL~0x09FL` are [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## Issuer formats {#issuer-형식}

A format not among the direct codes is placed as a codec number under the Issuer of the body that established the format. Conventional formats with no establishing body go under ADHOC (`0x00000002`). GEUL's own formats (OPAQUE-BYTES, BIT-VECTOR, DURATION-NANOSECONDS) are direct codes.

| Issuer | Example formats |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, integer and real vectors, tensors, complex numbers, fractions, intervals, quaternions, BLAKE3 |
| IETF `0x00000007` | Relative URI, CRC32C, IPv4 and IPv6 addresses |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, POSIX nanosecond timestamps, MAC addresses |
| KHRONOS `0x0000000E` | RGBA8, BGRA8 pixels |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | TAI timestamps |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | GPS timestamps |

- A decoder that does not know the format knows the Issuer and codec number and skips by Length.
- The codec document is placed under the `codecs/` of that Issuer by the record's codec number. Example: IETF CRC32C is `0x00000007/codecs/0x0000C000/` ([Publishing addresses and version list](../publishing.md)).
- For large values such as images and video, referencing them by URI and SHA-256 is recommended rather than embedding them directly.
- Works inside a byte sequence follow their original license. Record the source and license in Meta.

## Format groups {#형식-묶음}

Each group is described below. The layout, interpretation, validity, and examples of each format are in the per-format documents.

| Group | Family | Formats |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, integers, floating point, coordinates, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | Dates, times of day, timestamps, elapsed time, EDTF, GEDCOM dates |
| [text](#text) | TEXT | UTF-8 text, language-tagged text, URI, language codes |
| [binary](#binary) | BINARY | UUID, digests, CRC, network addresses, unknown byte sequences, bit vectors |
| [vector](#vector) | NUMERIC | Integer and real dense vectors, points and bounding boxes, RGBA and BGRA pixels |
| [tensor](#tensor) | NUMERIC | Dense and packed tensors with format, rank, and shape attached |
| [etc](#etc) | NUMERIC | Complex numbers, fractions, closed intervals, quaternions |

- The vector, tensor, and etc groups are all Issuer formats (ADHOC, KHRONOS) of the NUMERIC family.

### numeric {#numeric}

The basic number formats of the NUMERIC family. They are placed in the direct codes `0x060L~0x067L`.

- These are BOOL, signed and unsigned integers, IEEE 754 binary floating point, Earth (WGS 84) and celestial coordinates, QUANTITY that bundles an amount, unit, and bounds, and FRACTION, a fraction in its original notation.
- Integers are written in the minimum number of WORDs the value fits.
- Small scalar Issuer formats (BFLOAT16, FP8, FP4) have only codec numbers assigned and no detailed specification (open problem in [Value](#열린-문제)).
- Vectors, tensors, complex numbers, reduced fractions (RATIONAL-I64), and intervals are also in the NUMERIC family, but being Issuer formats they are placed in the [vector](#vector), [tensor](#tensor), and [etc](#etc) groups.

### decimal {#decimal}

The DECIMAL family is for exact decimal number formats. They are placed in the direct codes `0x068L~0x069L`.

- The direct codes SIGNED-DECIMAL and UNSIGNED-DECIMAL are written as `C × 10^E` and hold the digits of the original notation as they are. `1.20` (`C=120, E=−2`) and `1.2` (`C=12, E=−1`) are different records. Value equality and preservation of the quantum is an open problem of [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- The DPD and BID encodings of IEEE 754 decimal32/64/128 are formats of the IEEE Issuer (`0x0000000D`).

### time {#time}

The TIME family is for date and time formats. They are placed in the direct codes `0x06AL~0x071L` and `0x081L` (DURATION-NANOSECONDS).

| Precision | Format |
|---|---|
| Date (Gregorian calendar) | GREGORIAN-DATE |
| Year and month, uncertainty, intervals | EDTF |
| Original notation of other calendars (Julian, etc.) | GEDCOM-DATE |
| Time of day | POSIX, TAI, GPS timestamps |
| Elapsed time | DURATION-SECONDS, DURATION-NANOSECONDS |

- A date that can be written as GREGORIAN-DATE is not written as EDTF.
- The nanosecond timestamps and the TAI and GPS formats are formats under the Issuers of their standards bodies (IEEE, BIPM, GPS).

### text {#text}

The TEXT family is for text and string identifier formats. They are placed in the direct codes `0x072L~0x07AL`.

- A string with no language is UTF8-TEXT; text with a language, such as a name, title, or sentence, is UTF8-LANGUAGE-TEXT.
- Language codes (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) are also in the TEXT family.
- Variable-length byte sequences use an even/odd Codec pair. If the least significant bit is `1`, the byte count is odd and the lower byte of the last WORD is `0x00` padding ([Record and TAG WORD](../record.md)).

### binary {#binary}

The BINARY family is for byte sequence formats. They are placed in the direct codes `0x07BL~0x080L`.

- UUID, SHA-256, SHA-1, unknown byte sequences (OPAQUE-BYTES), and bit vectors (BIT-VECTOR) are direct codes. The other digests, CRC32C, and IPv4, IPv6, and MAC addresses are Issuer formats.
- Fixed-size values (UUID, digests, addresses) have a set size, so there is no even/odd pair.
- Public media such as images and video are placed as formats of the IANA Issuer (`0x00000008`). Codec numbers are assigned as even/odd pairs and the Payload is a byte sequence. The Length upper bound is 2^32−1 WORDs. For large values, referencing them by URI and SHA-256 is recommended rather than embedding them directly.
- Works inside a byte sequence follow their original license. Record the source and license in Meta.

### vector {#vector}

Vector formats are Issuer formats of the NUMERIC family. Integer and real dense vectors and points and bounding boxes go under ADHOC (`0x00000002`) codec numbers `0x00000500`~`0x0000050C`, and pixel formats under KHRONOS (`0x0000000E`).

- The elements of a dense vector are stored contiguously in big-endian.
- Being Issuer formats, the Codec extension TAG carries the Issuer 2 WORDs and the codec number 2 WORDs.

### tensor {#tensor}

Tensor formats are Issuer formats of the NUMERIC family. They are placed at ADHOC (`0x00000002`) codec numbers `0x00000600`~`0x00000601`.

- DESCRIBED-DENSE-TENSOR holds the element format, rank, shape, and a C-contiguous dense payload.
- DESCRIBED-PACKED-TENSOR holds the packed format, rank, shape, and a payload packed low-bit-first within an octet.

### etc {#etc}

Other number formats are Issuer formats of the NUMERIC family. They are placed at ADHOC (`0x00000002`) codec numbers `0x00000700`~`0x00000704`.

- These are complex numbers (COMPLEX64, COMPLEX128), the normalized fraction (RATIONAL-I64), the binary64 closed interval, and the binary32 quaternion.

## Text {#텍스트}

Text with a language and text without one are different values. "Paris" (string) and "Paris" (French) are not equal.

| Format | Where to use |
|---|---|
| UTF8-TEXT | Strings with no language, such as identifiers, codes, file names, and external IDs |
| UTF8-LANGUAGE-TEXT | Text with a language, such as names, titles, and sentences |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = text has odd bytes)
[Length extension TAG]
Language          LANGUAGE-SHORT-CODE or LANGUAGE-BCP47-CODE record
Text              UTF-8 bytes (last 0x00 if odd)
```

- Text is well-formed UTF-8 and is preserved as is. Normalization is left to the side that compares and indexes.
- A name common to several languages uses the language `mul`, and an undetermined language uses `und`. A string with no linguistic content is UTF8-TEXT.

Example: `"Douglas Adams"@en` (13 bytes, odd)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   lang en    D o  u g  l a  s ␠  A d  a m  s (padding)
```

## Decimals and quantities {#10진수와-수량}

An exact decimal is written as `C × 10^E`. The exponent `E` is 32 bits, and the coefficient `C` is two's complement in the minimum number of WORDs. The digits of the original notation are held as they are: `1.20` is `C=120, E=−2`, and `1.2` is `C=12, E=−1`. The two notations denote the same number but are separate records with different bytes. An encoder does not normalize the notation arbitrarily. The value equality of the two records and the meaning of the quantum (significant digits) are an open problem ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY holds an amount, a unit, and bounds in a single value.

```
TAG WORD          0000 0110 0110 LLLL
[Length extension TAG]
Amount            numeric Value record (integer, BINARY-FLOAT, decimal, fraction)
Unit              Reference record (unit item), 0x0000 if unitless
Lower bound       numeric Value record, 0x0000 ABSENT if omitted
Upper bound       numeric Value record, 0x0000 ABSENT if omitted
```

- The unit is part of the value. The unit is not detached and written elsewhere (if detached, one cannot tell whether `652` is km or m).
- A value converted to SI units is not held. It can be computed from the unit and the conversion table.
- `0x0000` is ABSENT, the marker that an optional field is omitted ([Codec spec document](../codec-spec.md)).

Example: `652 km`, range `[651, 653]` (km = Wikidata Q828224)

```
066E 0011                    TAG (extended length 17 WORDs)
0683 0000 0000 028C          amount 652
0142 000C A340               unit Q828224
0683 0000 0000 028B          lower bound 651
0683 0000 0000 028D          upper bound 653
```

## Dates {#날짜}

| Precision | Format |
|---|---|
| Date (Gregorian calendar) | GREGORIAN-DATE |
| Year and month, uncertainty (`1971~`), intervals | EDTF |
| Original notation of other calendars (Julian, etc.) | GEDCOM-DATE |
| Time of day | POSIX, TAI, GPS timestamps |

- A date that can be written as GREGORIAN-DATE is not written as EDTF.

## Open problems {#열린-문제}

- Public media formats (JPEG, PNG, MP4, MOV, etc.) are placed as codec numbers of the IANA Issuer (`0x00000008`). How to manage the mapping table between media types and codec numbers.
- The final list of Value direct codes. To be decided by measuring Value frequency in samples of statutes and business conversations (candidates: amounts, percentages, date intervals).
- Detailed specification and placement of the 7 small scalars (ADHOC BFLOAT16, the four ONNX FP8, OCP FP8-E8M0FNU·FP4-E2M1FN). Whether to move them to direct codes has not been decided. For now only codec numbers are assigned.
