---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH ist ein Value, der einen Punkt auf der Erde (WGS 84) mit Breite und Länge als binary64, Unsicherheit als binary32 und dem Einheiten-Reference der Unsicherheit enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH ist ein Koordinaten-Value, der einen Punkt auf der Erde mit Breite, Länge und Unsicherheit darstellt. Direkter Value-Code `0x04`, Familie NUMERIC. Die Bedeutung entspricht `geo:Breite,Länge;u=Unsicherheit` (Koordinatensystem WGS 84) aus [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI), wird aber nicht als Zeichenkette, sondern als Zahlen fester Breite abgelegt. Die Unsicherheit wird mit ihrer Einheit angegeben. Koordinaten von Himmelskörpern außerhalb der Erde schreibt man mit [COORDINATE-GEO](/de/grammar/value/numeric/coordinate-geo/) (`0x05`).

## Layout

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD Rohwert, IEEE 754 binary64 (Grad)
Longitude         4 WORD Rohwert, IEEE 754 binary64 (Grad)
Uncertainty       2 WORD Rohwert, IEEE 754 binary32 (in der Einheit Unit)
Unit              1 Reference-Record oder Slot-Marker 0x0000 ABSENT
```

## Interpretation und Gültigkeit

- Der Payload besteht aus Latitude 4 WORD, Longitude 4 WORD, Uncertainty 2 WORD und danach genau einem Unit-Record. Der Cursor nach dem Lesen von Unit muss mit dem Ende des Records übereinstimmen.
- Das Koordinatensystem ist WGS 84 (das Standard-`crs=wgs84` von RFC 5870).
- Latitude und Longitude sind IEEE 754 binary64, bei dem die Payload-WORD in Big-Endian-Reihenfolge aneinandergehängt sind (dieselbe Bitanordnung wie binary64 bei [BINARY-FLOAT](/de/grammar/value/numeric/binary-float/)). Die Einheit ist Grad (°).
  - Der Wert muss endlich sein. NaN und ±Infinity sind invalid.
  - Latitude liegt in `-90 ≤ φ ≤ 90` (Norden positiv), Longitude in `-180 ≤ λ ≤ 180` (Osten positiv).
  - Die Achsenreihenfolge ist Breite, Länge (wie RFC 5870 und ISO 6709). Es ist nicht die Reihenfolge x (Länge), y (Breite) von WKB und GeoJSON.
- Uncertainty ist IEEE 754 binary32, bei dem 2 WORD in Big-Endian aneinandergehängt sind (dieselbe Bitanordnung wie binary32 bei BINARY-FLOAT). Es bedeutet, dass die tatsächliche Position innerhalb dieses Radius liegt, und der Wert wird in der Einheit Unit gelesen.
  - Er muss endlich und mindestens `+0` sein. Negative Werte, `-0` (`8000 0000`), NaN und ±Infinity sind invalid.
  - `0` (wenn Unit vorhanden ist): exakte Koordinate. In welcher Einheit man es auch schreibt, es ist dasselbe.
- Unit ist ein Reference, das auf die Einheit der Uncertainty verweist. Ein Value wird nicht akzeptiert. Der Quantifier ist Identified (`000`).
  - Empfohlen werden Wikidata-Einheiteneinträge als [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/): Grad Q28390, Bogenminute Q209426, Bogensekunde Q829073, Meter Q11573, Millimeter Q174789 usw. Einheiten ohne QID spricht man mit anderen Reference (LOCAL, GEUL usw.) an. Gibt es mehrere Reference, die auf dieselbe Einheit verweisen, ist die QID die kanonische Form.
  - Ist Unit Meter (Q11573), entspricht Uncertainty dem `u` von RFC 5870.
- **Unbekannt**: An der Stelle von Unit steht [ABSENT](/de/grammar/reference/slot-marker/) (`0x0000`), und Uncertainty ist `+0` (`0000 0000`). Das entspricht dem Auslassen von `u` in RFC 5870. Ist Unit ABSENT, aber Uncertainty nicht `+0`, ist es invalid (die Darstellung wird auf eine festgelegt).
- Die Höhe wird nicht abgelegt. Falls nötig, wird sie als eigenes Format festgelegt. Wikidata altitude kam in der Stichprobe nicht vor (0/23.066), und ist ein Wert vorhanden, wird er nicht konvertiert, sondern der Originaltext als UTF8-TEXT bewahrt.
- Für Koordinaten auf der Erde wird dieses Format empfohlen. Auch eine Koordinate mit der Erde (Q2) in COORDINATE-GEO ist nicht invalid; wer vergleicht, gleicht sie als dieselbe Koordinate ab.
- Das geul.org-Spezifikationsdokument `0x0000/0x0000000000000804` setzt bei den Rohwert-Feldern Latitude, Longitude und Uncertainty [CODEC](/de/grammar/edge/codec/) BINARY-FLOAT (`0803`) (4 WORD = binary64, 2 WORD = binary32) und beim Record-Feld Unit CODEC `0780` (beliebiges Reference) und `0000` (ABSENT).

## Länge

- Insgesamt sind es TAG 1 WORD + 10 WORD + Unit-Record.

| Unit | Gesamt | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| QID passt in 1 WORD (2 WORD, z. B. Grad Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| QID ist 2 WORD (3 WORD, z. B. Bogenminute Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| Unit-Record ab 4 WORD | ab 15 WORD | Erweiterte Länge ([Record und TAG WORD](/de/grammar/record/)) |

- Ein Codec-Paar aus gerade/ungerade gibt es nicht.

## Entsprechung in Wikidata

Wikidata globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | Dieses Format (Erde). Andere Himmelskörper: COORDINATE-GEO |
| latitude, longitude | Unverändert als binary64 (Wikidata-Werte sind ursprünglich binary64, daher verlustfrei) |
| precision (Grad) | Uncertainty und Unit. Siehe unten „Genauigkeit“ |
| precision null oder fehlend | Unit = ABSENT, Uncertainty = `+0` (unbekannt) |
| altitude | Wird verworfen (stets null) |

- Die Wikidata-precision ist keine Messabweichung, sondern die **Aufzeichnungsauflösung** (in welcher Einheit aus Grad, Minuten und Sekunden die Koordinate angegeben wurde). GEUL Uncertainty überträgt diesen Wert unverändert. Es ist kein Radius, in den Mess- oder Koordinatensystemabweichungen eingerechnet wären.

### Genauigkeit

Die precision wird ohne Umrechnung übertragen. Man wählt unter Grad, Bogenminute und Bogensekunde die erste Einheit, die die ursprüngliche Schreibweise wiederherstellt.

| precision im Original (Beispiel) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k Grad) | Grad Q28390 | binary32 dieses Wertes |
| Kurze Dezimalschreibweise wie `0.0166667` | Grad Q28390 | binary32 dieses Wertes |
| `0.016666666666667` (1/60°) | Bogenminute Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | Bogensekunde Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0,1″) | Bogensekunde Q829073 | `0.1` |

- Hinrichtung: In der Reihenfolge Grad, Bogenminute (×60), Bogensekunde (×3600) nimmt man als Uncertainty das binary32, das dem mit der Zahl der Einheiten multiplizierten precision-Wert am nächsten liegt, und verwendet die erste Einheit, bei der die untenstehende Rückrichtung das precision-Original unverändert wiederherstellt.
- Rückrichtung: Man teilt die kürzeste Dezimaldarstellung von Uncertainty (die kürzeste Zahl, die wieder als dieses binary32 gelesen wird) durch die Zahl der Einheiten, rechnet in Grad um und schreibt sie so, wie Wikibase sie in den Dump schreibt (14 signifikante Stellen, unter `1e-4` in Exponentialschreibweise `1.0e-6`, `2.7777777777778e-5`). Die geladene DB (jsonb) bewahrt sie in Dezimalschreibweise `0.0000010`, `0.000027777777777778`.
- Kann keine Einheit das Original wiederherstellen (Schreibweise mit 17 signifikanten Stellen `0.0002777777777777778`, auffällige Werte, die wie berechnete aussehen usw.), wird nicht die gesamte Koordinate konvertiert, sondern der Originaltext als UTF8-TEXT bewahrt. Dasselbe gilt für negative precision und Werte mit leerem Himmelskörper.
- Wikidata-Stichprobe Q1–Q10000 (7.026 Koordinaten-Claims, 6.824 mit precision): Das Original wiederhergestellt wurde in 5.933 Fällen (86,9 %; Grad 4.104, Bogensekunde 1.370, Bogenminute 459). Von den 891 nicht wiederhergestellten gehören 753 zur Reihe 1/3600 und 1/60 in der Schreibweise mit 17 signifikanten Stellen.

## Beispiel

Berlin 52.516666666667, 13.383333333333, precision 1/60° (Bogenminute 1):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0120 0003 3212` (WIKIDATA-QID Q209426, Bogenminute).
- Textnotation: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

Derselbe Punkt mit unbekannter Unsicherheit: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Normgrundlage

- Bedeutung: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — Reihenfolge Breite, Länge, Unsicherheit `u` (Meter), Standard-Koordinatensystem WGS 84. Ist Unit Meter, gilt Uncertainty = `u`.
- Zahlen: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (Breite, Länge), binary32 (Unsicherheit).
- Achsenreihenfolge und Bereich: ISO 6709 (Standard representation of geographic point location by coordinates).
- Einheit: Wikidata-Einheiteneinträge (QID). Das Layout fester Breite, das Unit-Feld und die Darstellung von „unbekannt“ sind GEUL-Regeln.

## Offene Fragen

1. Die Höhe.
2. Ein Format, das den Originaltext einer ISO-6709-Zeichenkette bewahrt (COORDINATE-ISO6709), wird festgelegt, sobald es Verwendungen gibt.
3. Wie sich die Schreibweise mit 17 signifikanten Stellen der Wikidata-precision (etwa 11 % der Stichprobe) verlustfrei übertragen lässt.

## Verwandte Seiten

- [Value](/de/grammar/value/), [COORDINATE-GEO](/de/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/de/grammar/value/numeric/binary-float/), [Slot-Marker](/de/grammar/reference/slot-marker/)
- Das Issuer-Format [POINT2-BINARY64](/de/grammar/value/vector/point2-binary64/) ist ein allgemeiner zweidimensionaler Punkt, der Koordinatensystem, Einheit und Achsenbedeutung dem äußeren Kontext überlässt; dieses Format ist eine geografische Koordinate auf der Erde.
