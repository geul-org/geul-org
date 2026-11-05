---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH is a coordinate Value that represents a point on Earth by latitude, longitude, and uncertainty."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `COORDINATE-EARTH` (spec document BIND `COORDINATE-EARTH`) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| Spec document | `0x00000000/codecs/0x00000640/` (DECLARE target `0640`) |
| Section | 3 `0011` (Value), offset C within the section = 4 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Earth (WGS 84) latitude and longitude as binary64, uncertainty as binary32, and its unit Reference (ABSENT = unknown) |
| Hugo side | `value/numeric/coordinate-earth.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | raw value, 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | raw value, 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | raw value, 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference), `0000` ABSENT (optional field) |  |

COORDINATE-EARTH is a coordinate Value that represents a point on Earth by latitude, longitude, and uncertainty. Its direct Value code is `0x064L`, family NUMERIC. Its meaning is the same as `geo:latitude,longitude;u=uncertainty` of [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI; coordinate system WGS 84), and it is held as fixed-width numbers, not as a string. The uncertainty is written together with its unit. Coordinates of celestial bodies other than Earth are written with [COORDINATE-GEO](0x065L-coordinate-geo.md) (`0x065L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD raw value, IEEE 754 binary64 (degrees)
Longitude         4 WORD raw value, IEEE 754 binary64 (degrees)
Uncertainty       2 WORD raw value, IEEE 754 binary32 (in Unit)
Unit              one Reference record, or the slot marker 0x0000 ABSENT
```

## Interpretation and validity {#해석과-유효성}

- The Payload is Latitude 4 WORD, Longitude 4 WORD, Uncertainty 2 WORD, followed by exactly one Unit record. The cursor that has read the Unit must match the end of the record.
- The coordinate system is WGS 84 (the default `crs=wgs84` of RFC 5870).
- Latitude and Longitude are IEEE 754 binary64 formed by concatenating the Payload WORDs in big-endian order (the same bit layout as binary64 of [BINARY-FLOAT](0x063L-binary-float.md)). The unit is degrees (°).
  - The value must be finite. NaN and ±Infinity are invalid.
  - Latitude is `-90 ≤ φ ≤ 90` (north is positive), and Longitude is `-180 ≤ λ ≤ 180` (east is positive).
  - The axis order is latitude, then longitude (the same as RFC 5870 and ISO 6709). It is not the x (longitude), y (latitude) order of WKB and GeoJSON.
- Uncertainty is IEEE 754 binary32 formed by concatenating 2 WORD in big-endian order (the same bit layout as binary32 of BINARY-FLOAT). It means the actual position lies within this radius, and the value is read in Unit.
  - It must be finite and `+0` or greater. A negative value, `-0` (`8000 0000`), NaN, and ±Infinity are invalid.
  - `0` (when Unit is present): an exact coordinate. It is the same in any unit.
- Unit is a Reference that points to the unit of Uncertainty. A Value is not accepted. The Quantifier is Identified.
  - Using a Wikidata unit item, [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), is recommended: degree Q28390, arcminute Q209426, arcsecond Q829073, metre Q11573, millimetre Q174789, and so on. A unit without a QID is pointed to by another Reference (LOCAL, GEUL, etc.). When several References point to the same unit, the QID is the canonical form.
  - If Unit is metre (Q11573), Uncertainty is the same as `u` of RFC 5870.
- **Unknown**: write [ABSENT](../slot-marker.md) (`0x0000`) in the Unit slot and set Uncertainty to `+0` (`0000 0000`). This is the same as omitting `u` in RFC 5870. If Unit is ABSENT and Uncertainty is not `+0`, it is invalid (this fixes the representation to one).
- Altitude is not held. If needed, it is defined by a separate format. Wikidata altitude was not used in the sample (0/23,066), and if a value is present it is not converted and the original text is preserved as UTF8-TEXT.
- This format is recommended for Earth coordinates. A coordinate that writes Earth (Q2) in COORDINATE-GEO is not invalid either, and the side that compares treats them as the same coordinate.
- The geul.org spec document `0x00000000/codecs/0x00000640` puts [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) on the Latitude, Longitude, and Uncertainty raw value fields (4 WORD = binary64, 2 WORD = binary32), and puts CODEC `000F`, `020F`, `040F` (any Reference) and `0000` (ABSENT) on the Unit record field.

## Length {#길이}

- The total is TAG 1 WORD + 10 WORD + the Unit record.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| QID fits in 1 WORD (2 WORD, e.g. degree Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| QID is 2 WORD (3 WORD, e.g. arcminute Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| Unit record of 4 WORD or more | 15 WORD or more | extended length ([Record and TAG WORD](../record.md)) |

- No even/odd Codec pair is provided.

## Wikidata mapping {#위키데이터-대응}

Wikidata globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | this format (Earth). Other bodies use COORDINATE-GEO |
| latitude, longitude | binary64 as is (Wikidata values are binary64 originally, so nothing is lost) |
| precision (degrees) | Uncertainty and Unit. See "Precision" below |
| precision null or absent | Unit = ABSENT, Uncertainty = `+0` (unknown) |
| altitude | discarded (always null) |

- Wikidata precision is not a measurement error but the **recording resolution** (in what degrees, minutes, or seconds the coordinate was written). GEUL Uncertainty carries that value over unchanged. It is not a radius that adds measurement or coordinate-system error.

### Precision {#정밀도}

The precision is carried over without conversion. The first unit among degree, arcminute, and arcsecond that restores the original notation is chosen.

| precision original (example) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k degrees) | degree Q28390 | binary32 of that value |
| a short decimal notation such as `0.0166667` | degree Q28390 | binary32 of that value |
| `0.016666666666667` (1/60°) | arcminute Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | arcsecond Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | arcsecond Q829073 | `0.1` |

- Forward conversion: in the order degree, arcminute (×60), arcsecond (×3600), take as Uncertainty the binary32 closest to the precision multiplied by the number of units, and use the first unit for which the reverse conversion below returns the original precision text as is.
- Reverse conversion: divide the shortest decimal notation of Uncertainty (the shortest number that reads back as that binary32) by the number of units to convert it to degrees, and write it the way Wikibase writes it in the dump (14 significant digits; below `1e-4`, exponent notation such as `1.0e-6` and `2.7777777777778e-5`). The loaded DB (jsonb) stores this in decimal notation such as `0.0000010` and `0.000027777777777778`.
- If no unit restores the original text (a 17-significant-digit notation such as `0.0002777777777777778`, or outliers that look like computed values), the whole coordinate is not converted and the original text is preserved as UTF8-TEXT. The same applies to a negative precision and to a value whose celestial body is empty.
- Wikidata Q1–Q10000 sample (7,026 coordinate claims, 6,824 with precision): 5,933 restored the original text (86.9%; degree 4,104, arcsecond 1,370, arcminute 459). Of the 891 that could not be restored, 753 are the 1/3600 and 1/60 families in 17-significant-digit notation.

## Examples {#예시}

Berlin 52.516666666667, 13.383333333333, precision 1/60° (1 arcminute):

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0142 0003 3212` (WIKIDATA-QID Q209426, arcminute).
- Text notation: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

The same point with unknown uncertainty: `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Standards basis {#표준-근거}

- Meaning: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — latitude, longitude order, `u` uncertainty (metres), default coordinate system WGS 84. If Unit is metre, Uncertainty = `u`.
- Numbers: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (uncertainty).
- Axis order and range: ISO 6709 (Standard representation of geographic point location by coordinates).
- Unit: Wikidata unit item (QID). The fixed-width layout, the Unit field, and the unknown representation are GEUL rules.

## Open problems {#열린-문제}

1. Altitude.
2. A format that preserves the original ISO 6709 string (COORDINATE-ISO6709) will be defined when a use arises.
3. A lossless way to carry Wikidata precision in 17-significant-digit notation (about 11% of the sample).

## Related pages {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [Slot marker](../slot-marker.md)
- The Issuer format [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) is a general 2D point that leaves the coordinate system, unit, and axis meaning to external context; this format is a geographic coordinate on Earth.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000640/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
