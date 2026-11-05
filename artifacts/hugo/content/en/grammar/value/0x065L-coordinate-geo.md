---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO is a coordinate Value that represents a point on a specified celestial body (planet, moon, asteroid, etc.) by latitude, longitude, and uncertainty."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `COORDINATE-GEO` (spec document BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| Spec document | `0x00000000/codecs/0x00000650/` (DECLARE target `0650`) |
| Section | 3 `0011` (Value), offset C within the section = 5 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Celestial body Reference, latitude and longitude as binary64, uncertainty as binary32, and its unit Reference |
| Hugo side | `value/numeric/coordinate-geo.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | record | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | raw value, 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | raw value, 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | raw value, 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference), `0000` ABSENT (optional field) |  |

COORDINATE-GEO is a coordinate Value that represents a point on a specified celestial body (planet, moon, asteroid, etc.) by latitude, longitude, and uncertainty. Its direct Value code is `0x065L`, family NUMERIC. It is [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) with a celestial body (Globe) Reference added in front, and the rules for latitude, longitude, uncertainty, and unit are the same as COORDINATE-EARTH.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[Length extension TAG] when the total is 15 WORD or more
Globe             one Reference record (a Reference to the celestial body, Quantifier Identified)
Latitude          4 WORD raw value, IEEE 754 binary64 (degrees)
Longitude         4 WORD raw value, IEEE 754 binary64 (degrees)
Uncertainty       2 WORD raw value, IEEE 754 binary32 (in Unit)
Unit              one Reference record, or the slot marker 0x0000 ABSENT
```

## Interpretation and validity {#해석과-유효성}

- The Payload begins with the Globe record. Globe is exactly one complete Reference record, and its Quantifier is Identified. Any Reference that points to a celestial body can be used: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (a named body), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) in the same document (a body defined within the document), a body in another document ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md), [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)), and so on. Celestial bodies are countless, and those with a QID are only a part.
- After Globe come 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) and one Unit record. The cursor that has read the Unit must match the end of the record.
- Latitude is `-90 ≤ φ ≤ 90`, and Longitude is `-360 ≤ λ ≤ 360`. It is allowed wider than for Earth so that values of celestial coordinate systems that count longitude from 0 to 360° (east or west longitude), and negative values written in the opposite direction, can be held unchanged. The range is the same as the Wikidata globecoordinate data model (Wikibase `LatLongValue`). `λ` and `λ ± 360` are the same meridian, and GEUL does not normalize them. The other rules (binary64, finite values, axis order, the meaning of Uncertainty and Unit, the unknown representation) are the same as COORDINATE-EARTH.
- The coordinate system follows the convention of each celestial body (planetocentric latitude, east or west longitude of 0 to 360°, etc.). The coordinate system of each body is defined by a separate GEUL document.
- Uncertainty in a distance unit (metres, etc.) is a distance on the surface of the body. Angular units (degree, arcminute, arcsecond) are an angular radius in latitude and longitude, regardless of the size of the body.
- For Earth (Q2) coordinates, COORDINATE-EARTH is recommended. Writing Earth in this format is not invalid either, and the side that compares treats them as the same coordinate.
- The geul.org spec document `0x00000000/codecs/0x00000650` puts [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) on the Latitude, Longitude, and Uncertainty raw value fields, and CODEC `000F`, `020F`, `040F` (any Reference) and `0000` (ABSENT) on the Unit record field.

## Length {#길이}

- The total is TAG 1 WORD + (Length extension TAG) + the Globe record + 10 WORD + the Unit record.
- If Globe is 2 WORD (when the QID fits in 1 WORD) and Unit is ABSENT, the total is 14 WORD, `LLLL=1101`, TAG `065D`. If Unit is a Reference (2 WORD or more), the total exceeds 14 WORD and the extended length is used: TAG `065E`, with the total WORD count in the next WORD ([Record and TAG WORD](../record.md)).

## Wikidata mapping {#위키데이터-대응}

- A globecoordinate whose globe is not Earth (Q2) is written in this format. Globe = WIKIDATA-QID (the globe item). The mapping of latitude, longitude, and precision → Uncertainty and Unit is the same as COORDINATE-EARTH (precision is a recording resolution in degrees, so it is carried over as is regardless of the size of the body).
- Non-Earth bodies in the Wikidata sample (about 24,000 coordinate claims): 23 for Mars (Q111), Ceres (Q596), the Moon (Q405), Mercury (Q308), Venus (Q313), and others. The 41 whose globe is empty are not converted, and the original text is preserved as UTF8-TEXT.

## Examples {#예시}

Mars (Q111) 4.5, 137.4, uncertainty unknown:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, unknown).
- Text notation: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

The same point, precision 0.1° (Unit degree Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, extended length), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## Standards basis {#표준-근거}

- Meaning: latitude, longitude, and `u` (when Unit is metre) of [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). The only coordinate system registered for `crs` in RFC 5870 is `wgs84`, so bodies other than Earth are specified by the GEUL Globe Reference.
- Numbers: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (uncertainty).
- Longitude range: `-360 ≤ λ ≤ 360` of the Wikidata globecoordinate data model [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## Open problems {#열린-문제}

1. Coordinate system documents per celestial body: the latitude definition (planetocentric or planetographic) and the longitude direction and range for each body.

## Related pages {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000650/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
