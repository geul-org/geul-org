---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH ist ein Koordinaten-Value, der einen Punkt auf der Erde durch Breite, Länge und Unsicherheit darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `COORDINATE-EARTH` (Spezifikationsdokument BIND `COORDINATE-EARTH`) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000640/` (DECLARE-Ziel `0640`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 4 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | Breite und Länge auf der Erde (WGS 84) als binary64, Unsicherheit als binary32 und deren Einheiten-Reference (ABSENT = unbekannt) |
| Hugo-Seite | `value/numeric/coordinate-earth.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | Rohwert 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | Rohwert 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | Rohwert 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `0000` ABSENT (optionales Feld) |  |

COORDINATE-EARTH ist ein Koordinaten-Value, der einen Punkt auf der Erde durch Breite, Länge und Unsicherheit darstellt. Direkter Value-Code `0x064L`, Familie NUMERIC. Die Bedeutung entspricht `geo:Breite,Länge;u=Unsicherheit` (Koordinatensystem WGS 84) aus [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI), wird aber nicht als Zeichenkette, sondern als Zahlenwert fester Breite gespeichert. Die Unsicherheit wird zusammen mit ihrer Einheit angegeben. Koordinaten von Himmelskörpern außerhalb der Erde werden mit [COORDINATE-GEO](0x065L-coordinate-geo.md) (`0x065L`) geschrieben.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD Rohwert, IEEE 754 binary64 (Grad)
Longitude         4 WORD Rohwert, IEEE 754 binary64 (Grad)
Uncertainty       2 WORD Rohwert, IEEE 754 binary32 (in der Einheit Unit)
Unit              1 Reference-Record oder Slot-Marker 0x0000 ABSENT
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der Payload besteht aus Latitude mit 4 WORD, Longitude mit 4 WORD, Uncertainty mit 2 WORD und danach genau einem Unit-Record. Der Cursor nach dem Lesen von Unit muss mit dem Ende des Records übereinstimmen.
- Das Koordinatensystem ist WGS 84 (der Standard `crs=wgs84` aus RFC 5870).
- Latitude und Longitude sind IEEE-754-binary64, die durch Aneinanderfügen der Payload-WORD in big-endian-Reihenfolge entstehen (dieselbe Bitanordnung wie binary64 in [BINARY-FLOAT](0x063L-binary-float.md)). Die Einheit ist Grad (°).
  - Der Wert muss endlich sein. NaN und ±Infinity sind invalid.
  - Latitude liegt in `-90 ≤ φ ≤ 90` (Norden positiv), Longitude in `-180 ≤ λ ≤ 180` (Osten positiv).
  - Die Achsenreihenfolge ist Breite, Länge (wie in RFC 5870 und ISO 6709). Es ist nicht die x(Länge)-y(Breite)-Reihenfolge von WKB und GeoJSON.
- Uncertainty ist ein IEEE-754-binary32, das durch Aneinanderfügen von 2 WORD in big-endian entsteht (dieselbe Bitanordnung wie binary32 in BINARY-FLOAT). Es bedeutet, dass die tatsächliche Position innerhalb dieses Radius liegt, und der Wert wird in der Einheit Unit gelesen.
  - Er muss endlich und mindestens `+0` sein. Negative Werte, `-0` (`8000 0000`), NaN und ±Infinity sind invalid.
  - `0` (wenn Unit vorhanden ist): exakte Koordinate. In jeder Einheit geschrieben ist sie gleich.
- Unit ist ein Reference, der die Einheit von Uncertainty angibt. Ein Value wird nicht akzeptiert. Der Quantifier ist Identified.
  - Empfohlen werden Wikidata-Einheitenobjekte, [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md): Grad Q28390, Bogenminute Q209426, Bogensekunde Q829073, Meter Q11573, Millimeter Q174789 usw. Eine Einheit ohne QID wird durch einen anderen Reference (LOCAL, GEUL usw.) angegeben. Zeigen mehrere Reference auf dieselbe Einheit, ist die QID die kanonische Form.
  - Ist Unit Meter (Q11573), entspricht Uncertainty dem `u` aus RFC 5870.
- **Unbekannt**: An der Stelle von Unit steht der [ABSENT](../slot-marker.md) (`0x0000`), und Uncertainty bleibt `+0` (`0000 0000`). Das entspricht dem Weglassen von `u` in RFC 5870. Ist Unit ABSENT, aber Uncertainty nicht `+0`, ist es invalid (die Darstellung wird auf eine einzige festgelegt).
- Die Höhe wird nicht aufgenommen. Falls nötig, wird sie in einem eigenen Format festgelegt. Die Wikidata-altitude wurde in der Stichprobe nicht verwendet (0/23.066), und ist ein Wert vorhanden, wird er nicht konvertiert, sondern der Originaltext als UTF8-TEXT bewahrt.
- Für Erdkoordinaten wird dieses Format empfohlen. Eine Koordinate, die in COORDINATE-GEO die Erde (Q2) angibt, ist ebenfalls nicht invalid, und die vergleichende Seite gleicht sie als dieselbe Koordinate an.
- Das geul.org-Spezifikationsdokument `0x00000000/codecs/0x00000640` setzt in den Rohwert-Feldern Latitude, Longitude und Uncertainty den [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) (4 WORD = binary64, 2 WORD = binary32) und im Unit-Record-Feld die CODEC `000F`, `020F`, `040F` (beliebiger Reference) und `0000` (ABSENT).

## Länge {#길이}

- Die Gesamtzahl ist 1 WORD TAG + 10 WORD + Unit-Record.

| Unit | Gesamt | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| QID passt in 1 WORD (2 WORD, z. B. Grad Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| QID hat 2 WORD (3 WORD, z. B. Bogenminute Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| Unit-Record mit 4 WORD oder mehr | 15 WORD oder mehr | erweiterte Länge ([Record und TAG WORD](../record.md)) |

- Ein gerades/ungerades Codec-Paar gibt es nicht.

## Entsprechung in Wikidata {#위키데이터-대응}

Wikidata globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | dieses Format (Erde). Andere Himmelskörper: COORDINATE-GEO |
| latitude, longitude | unverändert als binary64 (Wikidata-Werte sind ursprünglich binary64, daher verlustfrei) |
| precision (Grad) | Uncertainty und Unit. Siehe „Genauigkeit“ unten |
| precision null oder fehlend | Unit = ABSENT, Uncertainty = `+0` (unbekannt) |
| altitude | wird verworfen (immer null) |

- Die Wikidata-precision ist keine Messabweichung, sondern die **Aufzeichnungsauflösung** (in welcher Einheit aus Grad, Minuten und Sekunden die Koordinate geschrieben wurde). Die GEUL-Uncertainty übernimmt diesen Wert unverändert. Sie ist kein Radius, in den Mess- oder Koordinatensystemabweichungen eingerechnet wären.

### Genauigkeit {#정밀도}

Die precision wird ohne Umrechnung übernommen. Gewählt wird die erste Einheit aus Grad, Bogenminute und Bogensekunde, die die ursprüngliche Schreibweise wiederherstellt.

| precision im Original (Beispiel) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k Grad) | Grad Q28390 | binary32 dieses Werts |
| kurze Dezimalschreibweise wie `0.0166667` | Grad Q28390 | binary32 dieses Werts |
| `0.016666666666667` (1/60°) | Bogenminute Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | Bogensekunde Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0,1″) | Bogensekunde Q829073 | `0.1` |

- Vorwärtskonvertierung: In der Reihenfolge Grad, Bogenminute (×60), Bogensekunde (×3600) wird als Uncertainty das binary32 verwendet, das dem Produkt aus precision und Einheitenanzahl am nächsten kommt, und es wird die erste Einheit genommen, bei der die untenstehende Rückkonvertierung das Original von precision unverändert wiederherstellt.
- Rückkonvertierung: Die kürzeste Dezimalschreibweise von Uncertainty (die kürzeste Zahl, die wieder als dieses binary32 gelesen wird) wird durch die Einheitenanzahl geteilt und in Grad umgerechnet und so geschrieben, wie Wikibase es in den Dump schreibt (14 signifikante Stellen, unter `1e-4` in Exponentialschreibweise `1.0e-6`, `2.7777777777778e-5`). Die Ziel-DB (jsonb) speichert dies in Dezimalschreibweise `0.0000010`, `0.000027777777777778`.
- Stellt keine Einheit das Original wieder her (Schreibweise mit 17 signifikanten Stellen `0.0002777777777777778`, Ausreißer, die wie berechnete Werte aussehen usw.), wird die gesamte Koordinate nicht konvertiert, sondern der Originaltext als UTF8-TEXT bewahrt. Dasselbe gilt für negative precision und Werte ohne Himmelskörper.
- Wikidata-Stichprobe Q1–Q10000 (7.026 Koordinaten-Claims, 6.824 mit precision): Original wiederhergestellt bei 5.933 (86,9 %; Grad 4.104, Bogensekunde 1.370, Bogenminute 459). Von den 891 nicht wiederhergestellten gehören 753 zur Reihe 1/3600 und 1/60 in der Schreibweise mit 17 signifikanten Stellen.

## Beispiel {#예시}

Berlin 52.516666666667, 13.383333333333, precision 1/60° (Bogenminute 1):

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0142 0003 3212` (WIKIDATA-QID Q209426, Bogenminute).
- Textschreibweise: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

Derselbe Punkt mit unbekannter Unsicherheit: `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Normative Grundlage {#표준-근거}

- Bedeutung: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — Reihenfolge Breite, Länge, Unsicherheit `u` (Meter), Standard-Koordinatensystem WGS 84. Ist Unit Meter, gilt Uncertainty = `u`.
- Zahlenwerte: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (Breite, Länge), binary32 (Unsicherheit).
- Achsenreihenfolge und Wertebereich: ISO 6709 (Standard representation of geographic point location by coordinates).
- Einheit: Wikidata-Einheitenobjekte (QID). Das Layout fester Breite, das Unit-Feld und die Darstellung von „unbekannt“ sind GEUL-Regeln.

## Offene Probleme {#열린-문제}

1. Höhe.
2. Ein Format, das den ISO-6709-Originalstring bewahrt (COORDINATE-ISO6709), wird festgelegt, sobald es einen Verwendungszweck gibt.
3. Ein verlustfreier Weg, die Schreibweise der Wikidata-precision mit 17 signifikanten Stellen (etwa 11 % der Stichprobe) zu übernehmen.

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [Slot-Marker](../slot-marker.md)
- Das Issuer-Format [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) ist ein allgemeiner zweidimensionaler Punkt, der Koordinatensystem, Einheit und Achsenbedeutung dem äußeren Kontext überlässt, dieses Format dagegen eine geografische Koordinate auf der Erde.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000640/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

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
