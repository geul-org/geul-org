---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY is a Value that represents a single quantity by a number, a unit, and a lower and upper bound."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `QUANTITY` (spec document BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| Spec document | `0x00000000/codecs/0x00000660/` (DECLARE target `0660`) |
| Section | 3 `0011` (Value), offset C within the section = 6 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Numeric Value amount (integer, BINARY-FLOAT, decimal, fraction), unit Reference, lower and upper bounds. The unit and bounds may be omitted (ABSENT `0x0000`) |
| Hugo side | `value/numeric/quantity.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | record | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference), `0000` ABSENT (optional field) |  |
| 3 | `lower` | #4 | record | `0680` SIGNED-DECIMAL, `0000` ABSENT (optional field), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | record | `0680` SIGNED-DECIMAL, `0000` ABSENT (optional field), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY is a Value that represents a single quantity by a number, a unit, and a lower and upper bound. Its direct Value code is `0x066L`, family NUMERIC. Each of the four parts is a complete record. The unit and the bounds are [optional fields](../codec-spec.md), so when omitted, ABSENT (`0x0000`) is used.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[Length extension TAG] when the total is 15 WORD or more
amount            numeric Value record (integer, BINARY-FLOAT, decimal, fraction)
unit              Reference record (unit item), 0x0000 if unitless
lower             numeric Value record, 0x0000 ABSENT if omitted
upper             numeric Value record, 0x0000 ABSENT if omitted
```

## Interpretation and validity {#해석과-유효성}

- amount is exactly one complete numeric Value record. The accepted Codecs are six: [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`), [FRACTION](0x067L-fraction.md) (`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`), and [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). It is a closed list, not a wildcard. BOOL, COORDINATE-EARTH and COORDINATE-GEO, QUANTITY itself (no nesting; the depth is fixed), and other Values are not accepted. A slot marker (`0x0000`, etc.) cannot be used for amount.
- The inner records also follow the canonical form of each Codec (integers and coefficients use the minimum WORD, BINARY-FLOAT uses 1/2/4/8 WORD, FRACTION follows its own rules). If any inner record is non-canonical, the whole QUANTITY is invalid.
- If amount, lower, or upper is BINARY-FLOAT, it must be a finite value. NaN and ±Infinity are invalid (the same rule as latitude and longitude of [COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- The number format follows the original notation as is. An integer original is held as INTEGER, a decimal original as DECIMAL, a fraction original as FRACTION, and an IEEE 754 binary value as BINARY-FLOAT; the encoder does not change the format to normalize. C and E of DECIMAL hold the digits of the original notation as is: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. The two are the same number but have different significant digits, so they are different Values. There is no upper limit on the digits of an integer or coefficient (minimum WORD, variable length).
- unit is exactly one complete Reference record, or `0x0000`. Any Reference that points to a unit item can be used (a Wikidata unit is WIKIDATA-QID). `0x0000` means unitless (a count, ratio, population, etc.).
- lower and upper are each a record of one of the same six Codecs as amount, or `0x0000` ABSENT. For slot markers, only the ABSENT omission is accepted. Having only one of the two is allowed. The three numbers need not have the same Codec.
- lower ≤ amount ≤ upper is compared by numeric value, not by bytes or Codec. Numbers are compared as numbers even if their types differ (e.g. SIGNED-INTEGER `652` and SIGNED-DECIMAL `651.5`). FRACTION is compared as an exact rational number. A symmetric range (`652 ± 1`) is also written with the two bounds (`651`, `653`). Since asymmetric ranges exist and two values are needed anyway, no format reduces this to a single ±.
- The unit is part of the value. The unit is not split off into a QUALIFIER or the like (if split off, one cannot tell whether `652` is km or m).
- Taking out the amount record gives an independent Value record as is. If the number without the unit is needed, use that record without re-encoding.
- A value converted to SI units is not held. It is a derived value that can be computed from the unit and a conversion table.
- The cursor that has read the four records must match the end of the Payload exactly. Any other shape is invalid.
- The geul.org spec document describes four record fields: amount (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`), unit (`000F`, `020F`, `040F`, `0000`), and lower and upper (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`, `0000`) ([Codec spec document](../codec-spec.md)).

## Length {#길이}

- The total is TAG 1 WORD + (Length extension TAG) + four records. An integer record is TAG 1 + Payload 1 WORD or more, a BINARY-FLOAT record is 2, 3, 5, or 9 WORD, a decimal record is TAG 1 + exponent 2 + coefficient 1 WORD or more, and a FRACTION record is 5 WORD or more.
- A small integer without unit or bounds is 6 WORD, and a small decimal is 8 WORD. At 15 WORD or more, the extended length is used ([Record and TAG WORD](../record.md)).

## Examples {#예시}

Unitless `1.20`:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078` (E = -2, C = 120), unit, lower, and upper `0000`.

Unitless integer `42`:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD), amount `0611 002A` (SIGNED-INTEGER 42), unit, lower, and upper `0000`.

Unitless fraction `2/3` (two thirds of the voting rights present):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD), amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3), unit, lower, and upper `0000`.

`652 km`, range `[651, 653]` (km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- The total is 17 WORD, so `LLLL=1110` and the extension TAG is `0011`.

## Wikidata mapping {#위키데이터-대응}

- `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. The amount and bound strings (`+1.20`, including exponent notation) are carried over to C and E with their digits as is.
- Wikidata amounts and bounds are decimal strings, so even an integer-looking one (`+652`) is carried over as SIGNED-DECIMAL. The Wikidata conversion does not use the other numeric Codecs.
- unit `"1"` is unitless (`0x0000`), and `http://www.wikidata.org/entity/Qn` is WIKIDATA-QID. Other units, and numbers or bounds that do not fit the format, are not converted, and the original text is preserved as UTF8-TEXT.
- Wikidata sample (about 42,000 quantities from the first part of the dump): 61% unitless, 13% with bounds (93% of those symmetric), longest amount 31 characters.

## Standards basis {#표준-근거}

- Decimal notation and digit preservation: the coefficient, exponent, and quantum concepts of [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal (GEUL SIGNED-DECIMAL).
- Wikidata quantity model: Wikibase DataModel `QuantityValue`.

## Related pages {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000660/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
