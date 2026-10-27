---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY is a Value that holds one quantity as four records: a numeric Value amount (integer, BINARY-FLOAT, decimal, fraction), a unit Reference, and lower and upper bounds."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY is a Value that represents one quantity with a number, a unit, and lower and upper bounds. It is Value direct code `0x06`, family NUMERIC. Each of the four parts is a complete record. The unit and bounds are [optional fields](/grammar/codec-spec/), so when omitted, ABSENT (`0x0000`) is written.

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length extension TAG] when the total is 15 WORD or more
amount            numeric Value record (integer, BINARY-FLOAT, decimal, fraction)
unit              Reference record (unit item), 0x0000 if unitless
lower             numeric Value record, 0x0000 ABSENT if omitted
upper             numeric Value record, 0x0000 ABSENT if omitted
```

## Interpretation and Validity

- amount is exactly one complete numeric Value record. The accepted Codecs are the six [SIGNED-INTEGER](/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/) (`0x10`), and [UNSIGNED-DECIMAL](/grammar/value/decimal/unsigned-decimal/) (`0x11`). The list is closed, not a wildcard. BOOL, COORDINATE-EARTH and COORDINATE-GEO, QUANTITY itself (no nesting, fixed depth), and other Values are not accepted. No slot marker (`0x0000` and the like) can be written for amount.
- The inner records also follow the canonical form of each Codec (minimal WORDs for integers and coefficients, 1/2/4/8 WORD for BINARY-FLOAT, FRACTION by its own rules). If an inner record is non-canonical, the whole QUANTITY is invalid.
- If amount, lower, or upper is BINARY-FLOAT, it must be a finite value. NaN and ±Infinity are invalid (the same rule as the latitude and longitude of [COORDINATE-EARTH](/grammar/value/numeric/coordinate-earth/)).
- The number format follows the original notation as it is. An integer original is held as INTEGER, a decimal original as DECIMAL, a fraction original as FRACTION, and an IEEE 754 binary value as BINARY-FLOAT; the encoder does not normalize by changing the format. The C and E of a DECIMAL hold the digits of the original notation as they are: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. The two are the same number but have different significant digits, so they are different Values. There is no upper limit on the number of digits of an integer or a coefficient (minimal WORDs, variable length).
- unit is exactly one complete Reference record, or `0x0000`. Any Reference that points to a unit item can be used (a Wikidata unit is WIKIDATA-QID). `0x0000` is unitless (counts, ratios, populations, and so on).
- lower and upper are each a record of one of the same six Codecs as amount, or `0x0000` ABSENT. The only slot marker accepted is the ABSENT omission. Only one of them may be present. The three numbers need not have the same Codec. A symmetric range (`652 ± 1`) is also written with lower and upper (`651`, `653`). Since asymmetric ranges exist and two values are needed anyway, no format that reduces it to a single ± is provided.
- lower ≤ amount ≤ upper is compared by numeric value, not by bytes or Codec. Even if the types differ, they are compared as numbers (e.g. SIGNED-INTEGER `652` and SIGNED-DECIMAL `651.5`). FRACTION is compared as an exact rational number.
- The unit is part of the value. The unit is not detached into a QUALIFIER or the like (once detached, it cannot be known whether `652` is km or m).
- Taken out, the amount record is an independent Value record as it is. When the number without the unit is needed, that record is used without re-encoding.
- A value converted to SI units is not held. It is a derived value that can be calculated from the unit and a conversion table.
- The cursor after reading the four records must match the end of the Payload exactly. Any other form is invalid.
- The geul.org specification document writes it with four record fields: amount (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`), unit (`0780`, `0000`), and lower and upper (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`, `0000`) ([Codec specification document](/grammar/codec-spec/)).

## Length

- The total is TAG 1 WORD + (Length extension TAG) + the four records. An integer record is TAG 1 + Payload of at least 1 WORD, a BINARY-FLOAT record is 2, 3, 5, or 9 WORD, and a decimal record is TAG 1 + exponent 2 + coefficient of at least 1 WORD. A FRACTION record is 5 WORD or more.
- A small unitless integer with no bounds is 6 WORD, and a small decimal is 8 WORD. At 15 WORD or more, the extended length is used ([Records and the TAG WORD](/grammar/record/)).

## Examples

Unitless `1.20`:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower, and upper `0000`.

Unitless integer `42`:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit, lower, and upper `0000`.

Unitless fraction `2/3` (two-thirds of the voting rights present):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/grammar/value/numeric/fraction/) 2/3), unit, lower, and upper `0000`.

`652 km`, range `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- The total is 17 WORD, so `LLLL=1110` and the extension TAG is `0011`.

## Wikidata Correspondence

- The `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. The amount and bound strings (`+1.20`, including exponent notation) are carried over into C and E with their digits unchanged.
- Wikidata amounts and bounds are decimal strings, so even when they look like integers (`+652`) they are carried over as SIGNED-DECIMAL. Wikidata conversion does not use other numeric Codecs.
- unit `"1"` is unitless (`0x0000`), and `http://www.wikidata.org/entity/Qn` is WIKIDATA-QID. Other units, and numbers and bounds that do not fit the format, are not converted and the original is preserved as UTF8-TEXT.
- Wikidata sample (about 42,000 quantities at the start of the dump): 61% unitless, 13% with bounds (of which 93% symmetric), longest amount 31 characters.

## Standards Basis

- Decimal notation and digit preservation: the coefficient, exponent, and quantum concepts of [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal (GEUL SIGNED-DECIMAL).
- The Wikidata quantity model: Wikibase DataModel `QuantityValue`.

## Related Pages

- [Value](/grammar/value/), [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/grammar/value/numeric/coordinate-geo/), [CODEC](/grammar/edge/codec/), [WIKIDATA-QID](/grammar/reference/wikidata-qid/)
