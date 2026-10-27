---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO is a Value that holds one point on a celestial body such as a planet or moon, with a celestial body Reference, binary64 latitude and longitude, a binary32 uncertainty, and its unit Reference."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO is a coordinate Value that represents a point on a specified celestial body (planet, moon, asteroid, and so on) with latitude, longitude, and uncertainty. It is Value direct code `0x05`, family NUMERIC. It is [COORDINATE-EARTH](/grammar/value/numeric/coordinate-earth/) (`0x04`) with a celestial body (Globe) Reference added in front, and the rules for latitude, longitude, uncertainty, and unit are the same as COORDINATE-EARTH.

## Layout

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length extension TAG] when the total is 15 WORD or more
Globe             one Reference record (a Reference to the celestial body, Quantifier Identified)
Latitude          4 WORD raw value, IEEE 754 binary64 (degrees)
Longitude         4 WORD raw value, IEEE 754 binary64 (degrees)
Uncertainty       2 WORD raw value, IEEE 754 binary32 (in Unit)
Unit              one Reference record, or the slot marker 0x0000 ABSENT
```

## Interpretation and Validity

- The Payload starts with the Globe record. Globe is exactly one complete Reference record and its Quantifier is Identified (`000`). Any Reference that points to a celestial body can be used: [WIKIDATA-QID](/grammar/reference/wikidata-qid/) (a named body), [GEUL](/grammar/reference/geul/), a [LOCAL](/grammar/reference/local/) of the same document (a body defined in the document), a body of another document ([EXTERNAL-POINTER](/grammar/reference/external-pointer/), [EXTERNAL-ISSUER](/grammar/reference/external-issuer/)), and so on. Celestial bodies are countless, and those with a QID are only a part.
- After Globe come 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) and one Unit record. The cursor after reading Unit must match the end of the record.
- Latitude is `-90 ≤ φ ≤ 90`, and Longitude is `-180 ≤ λ ≤ 360`. `(180, 360]` is allowed so that values of celestial coordinate systems that count longitude from 0 to 360° can be held as they are. The other rules (binary64, finite values, axis order, the meaning of Uncertainty and Unit, the unknown representation) are the same as COORDINATE-EARTH.
- The coordinate system follows the convention of each body (planetocentric latitude, east or west longitude 0 to 360°, and so on). The coordinate system of each body is set in a separate GEUL document.
- Uncertainty in a distance unit (metres and so on) is a distance on the surface of the body. An angular unit (degree, arcminute, arcsecond) is an angular radius of latitude and longitude regardless of the size of the body.
- For Earth (Q2) coordinates, using COORDINATE-EARTH is recommended. Writing Earth in this format is also not invalid, and the comparing side aligns them as the same coordinate.
- The geul.org specification document `0x0000/0x0000000000000805` places [CODEC](/grammar/edge/codec/) BINARY-FLOAT (`0803`) on the Latitude, Longitude, and Uncertainty raw-value fields, and CODEC `0780` (any Reference) and `0000` (ABSENT) on the Unit record field.

## Length

- The total is TAG 1 WORD + (Length extension TAG) + the Globe record + 10 WORD + the Unit record.
- If Globe is 2 WORD (when the QID fits in 1 WORD) and Unit is ABSENT, it is 14 WORD, `LLLL=1101`, TAG `0E85`. If Unit is a Reference (2 WORD or more), it exceeds 15 WORD and uses the extended length: TAG `0F05`, with the total WORD count in the next WORD ([Records and the TAG WORD](/grammar/record/)).

## Wikidata Correspondence

- A globecoordinate whose globe is not Earth (Q2) is written in this format. Globe = WIKIDATA-QID (the globe item). Latitude, longitude, and the precision → Uncertainty and Unit mapping are the same as COORDINATE-EARTH (precision is a recording resolution in degrees, so it is carried over unchanged regardless of the size of the body).
- Bodies other than Earth in the Wikidata sample (about 24,000 coordinate claims): 23 for Mars (Q111), Ceres (Q596), the Moon (Q405), Mercury (Q308), Venus (Q313), and so on. The 41 with an empty globe are not converted and the original is preserved as UTF8-TEXT.

## Examples

Mars (Q111) 4.5, 137.4, uncertainty unknown:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, unknown).
- Text notation: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

The same point, precision 0.1° (Unit degree Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, extended length), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## Standards Basis

- Meaning: latitude, longitude, and `u` (when Unit is metre) of [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). The only coordinate system registered for `crs` in RFC 5870 is `wgs84`, so bodies other than Earth are specified with a GEUL Globe Reference.
- Numbers: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude and longitude), binary32 (uncertainty).

## Open Questions

1. Per-body coordinate system documents: for each body, the definition of latitude (planetocentric or planetographic) and the direction and range of longitude.

## Related Pages

- [Value](/grammar/value/), [COORDINATE-EARTH](/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/grammar/reference/wikidata-qid/), [GEUL](/grammar/reference/geul/), [LOCAL](/grammar/reference/local/)
