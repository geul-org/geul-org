---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH is a Value that holds one point on Earth (WGS 84) as binary64 latitude and longitude, a binary32 uncertainty, and a Reference for the uncertainty unit."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH is a coordinate Value that represents a point on Earth with latitude, longitude, and uncertainty. It is Value direct code `0x04`, family NUMERIC. Its meaning is the same as `geo:latitude,longitude;u=uncertainty` (coordinate reference system WGS 84) of [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI), held not as a string but as fixed-width numbers. The uncertainty is written together with its unit. Coordinates of celestial bodies other than Earth are written with [COORDINATE-GEO](/grammar/value/numeric/coordinate-geo/) (`0x05`).

## Layout

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD raw value, IEEE 754 binary64 (degrees)
Longitude         4 WORD raw value, IEEE 754 binary64 (degrees)
Uncertainty       2 WORD raw value, IEEE 754 binary32 (in Unit)
Unit              one Reference record, or the slot marker 0x0000 ABSENT
```

## Interpretation and Validity

- The Payload is Latitude 4 WORD, Longitude 4 WORD, Uncertainty 2 WORD, followed by exactly one Unit record. The cursor after reading Unit must match the end of the record.
- The coordinate reference system is WGS 84 (the default `crs=wgs84` of RFC 5870).
- Latitude and Longitude are IEEE 754 binary64 formed by joining the Payload WORDs in big-endian order (the same bit layout as binary64 in [BINARY-FLOAT](/grammar/value/numeric/binary-float/)). The unit is degrees (°).
  - They must be finite. NaN and ±Infinity are invalid.
  - Latitude is `-90 ≤ φ ≤ 90` (north is positive), and Longitude is `-180 ≤ λ ≤ 180` (east is positive).
  - The axis order is latitude, longitude (the same as RFC 5870 and ISO 6709). It is not the x (longitude), y (latitude) order of WKB and GeoJSON.
- Uncertainty is IEEE 754 binary32 formed by joining 2 WORDs in big-endian order (the same bit layout as binary32 in BINARY-FLOAT). It means the real position is within this radius, and the value is read in Unit.
  - It must be a finite `+0` or greater. A negative value, `-0` (`8000 0000`), NaN, and ±Infinity are invalid.
  - `0` (when Unit is present): an exact coordinate. It is the same in any unit.
- Unit is a Reference that points to the unit of Uncertainty. A Value is not accepted. The Quantifier is Identified (`000`).
  - It is recommended to use a Wikidata unit item [WIKIDATA-QID](/grammar/reference/wikidata-qid/): degree Q28390, arcminute Q209426, arcsecond Q829073, metre Q11573, millimetre Q174789, and so on. A unit with no QID is pointed to with another Reference (LOCAL, GEUL, and so on). If several References point to the same unit, the QID is the canonical form.
  - If Unit is metre (Q11573), Uncertainty is the same as `u` of RFC 5870.
- **Unknown**: write [ABSENT](/grammar/reference/slot-marker/) (`0x0000`) in the Unit position and set Uncertainty to `+0` (`0000 0000`). This is the same as omitting `u` in RFC 5870. If Unit is ABSENT but Uncertainty is not `+0`, it is invalid (this fixes the representation to one).
- Altitude is not held. If needed, it is set in a separate format. Wikidata altitude was not used in the sample (0/23,066), and if a value exists, it is not converted and the original is preserved as UTF8-TEXT.
- For Earth coordinates, using this format is recommended. A coordinate that writes Earth (Q2) in COORDINATE-GEO is also not invalid, and the comparing side aligns them as the same coordinate.
- The geul.org specification document `0x0000/0x0000000000000804` places [CODEC](/grammar/edge/codec/) BINARY-FLOAT (`0803`) on the Latitude, Longitude, and Uncertainty raw-value fields (4 WORD = binary64, 2 WORD = binary32), and places CODEC `0780` (any Reference) and `0000` (ABSENT) on the Unit record field.

## Length

- The total is TAG 1 WORD + 10 WORD + the Unit record.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| QID fits in 1 WORD (2 WORD, e.g. degree Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| QID is 2 WORD (3 WORD, e.g. arcminute Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| Unit record of 4 WORD or more | 15 WORD or more | extended length ([Records and the TAG WORD](/grammar/record/)) |

- No even-odd Codec pair is placed.

## Wikidata Correspondence

Wikidata globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | This format (Earth). Other bodies use COORDINATE-GEO |
| latitude, longitude | binary64 as is (Wikidata values are originally binary64, so nothing is lost) |
| precision (degrees) | Uncertainty and Unit. See "Precision" below |
| precision null or absent | Unit = ABSENT, Uncertainty = `+0` (unknown) |
| altitude | Dropped (always null) |

- Wikidata precision is not a measurement error but the **recording resolution** (in what degrees, minutes, or seconds the coordinate was written). GEUL Uncertainty carries that value over unchanged. It is not a radius that adds measurement or coordinate-system error.

### Precision

Precision is carried over without conversion. Choose the first unit among degree, arcminute, and arcsecond that restores the original notation.

| precision original (example) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k degrees) | degree Q28390 | binary32 of that value |
| a short decimal notation such as `0.0166667` | degree Q28390 | binary32 of that value |
| `0.016666666666667` (1/60°) | arcminute Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | arcsecond Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | arcsecond Q829073 | `0.1` |

- Forward conversion: in the order degree, arcminute (×60), arcsecond (×3600), take the binary32 closest to the precision multiplied by the unit count as Uncertainty, and use the first unit for which the reverse conversion below returns the precision original exactly.
- Reverse conversion: take the shortest decimal notation of Uncertainty (the shortest number that reads back as that binary32), divide it by the unit count to turn it into degrees, and write it the way Wikibase writes it in a dump (14 significant digits, exponent notation `1.0e-6` and `2.7777777777778e-5` below `1e-4`). The loaded DB (jsonb) keeps this in decimal notation as `0.0000010` and `0.000027777777777778`.
- If no unit returns the original (a 17-significant-digit notation such as `0.0002777777777777778`, outliers that look like computed values, and so on), the whole coordinate is not converted and the original is preserved as UTF8-TEXT. The same applies to a negative precision and a value with an empty globe.
- Wikidata Q1-Q10000 sample (7,026 coordinate claims, 6,824 with precision): 5,933 returned the original (86.9%; degree 4,104, arcsecond 1,370, arcminute 459). Of the 891 that did not, 753 are in the 1/3600 and 1/60 series with a 17-significant-digit notation.

## Example

Berlin 52.516666666667, 13.383333333333, precision 1/60° (arcminute 1):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0120 0003 3212` (WIKIDATA-QID Q209426, arcminute).
- Text notation: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

The same point with unknown uncertainty: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Standards Basis

- Meaning: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — the latitude, longitude order, `u` uncertainty (metres), and default coordinate reference system WGS 84. If Unit is metre, Uncertainty = `u`.
- Numbers: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude and longitude), binary32 (uncertainty).
- Axis order and range: ISO 6709 (Standard representation of geographic point location by coordinates).
- Unit: Wikidata unit items (QID). The fixed-width layout, the Unit field, and the unknown representation are GEUL rules.

## Open Questions

1. Altitude.
2. A format that preserves the ISO 6709 string original (COORDINATE-ISO6709) will be decided when a use appears.
3. A way to carry over the 17-significant-digit notation of Wikidata precision (about 11% of the sample) losslessly.

## Related Pages

- [Value](/grammar/value/), [COORDINATE-GEO](/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/grammar/value/numeric/binary-float/), [Slot marker](/grammar/reference/slot-marker/)
- The Issuer format [POINT2-BINARY64](/grammar/value/vector/point2-binary64/) is a general 2-dimensional point that leaves the coordinate system, unit, and axis meaning to the outside context; this format is a geographic coordinate on Earth.
