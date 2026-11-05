---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO ist ein Koordinaten-Value, der einen Punkt auf einem angegebenen Himmelskörper (Planet, Mond, Asteroid usw.) durch Breite, Länge und Unsicherheit darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `COORDINATE-GEO` (Spezifikationsdokument BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000650/` (DECLARE-Ziel `0650`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 5 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | Himmelskörper-Reference und Breite und Länge als binary64, Unsicherheit als binary32 und deren Einheiten-Reference |
| Hugo-Seite | `value/numeric/coordinate-geo.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | Record | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | Rohwert 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | Rohwert 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | Rohwert 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `0000` ABSENT (optionales Feld) |  |

COORDINATE-GEO ist ein Koordinaten-Value, der einen Punkt auf einem angegebenen Himmelskörper (Planet, Mond, Asteroid usw.) durch Breite, Länge und Unsicherheit darstellt. Direkter Value-Code `0x065L`, Familie NUMERIC. Es ist das Format [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) mit vorangestelltem Himmelskörper-Reference (Globe), und die Regeln für Breite, Länge, Unsicherheit und Einheit sind dieselben wie bei COORDINATE-EARTH.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
Globe             1 Reference-Record (Reference auf den Himmelskörper, Quantifier Identified)
Latitude          4 WORD Rohwert, IEEE 754 binary64 (Grad)
Longitude         4 WORD Rohwert, IEEE 754 binary64 (Grad)
Uncertainty       2 WORD Rohwert, IEEE 754 binary32 (in der Einheit Unit)
Unit              1 Reference-Record oder Slot-Marker 0x0000 ABSENT
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der Payload beginnt mit dem Globe-Record. Globe ist genau ein vollständiger Reference-Record, und der Quantifier ist Identified. Jeder Reference, der auf einen Himmelskörper zeigt, ist zulässig: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (benannter Himmelskörper), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) im selben Dokument (im Dokument definierter Himmelskörper), ein Himmelskörper in einem anderen Dokument ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md), [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)) usw. Es gibt unzählige Himmelskörper, und die mit einer QID sind nur ein Teil davon.
- Nach Globe folgen 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) und ein Unit-Record. Der Cursor nach dem Lesen von Unit muss mit dem Ende des Records übereinstimmen.
- Latitude liegt in `-90 ≤ φ ≤ 90`, Longitude in `-360 ≤ λ ≤ 360`. Der Bereich ist weiter als bei der Erde, um Werte von Himmelskörper-Koordinatensystemen, die die Länge von 0 bis 360° zählen (Ost- und Westlänge), und die in Gegenrichtung geschriebenen negativen Werte unverändert aufnehmen zu können. Der Bereich entspricht dem Wikidata-globecoordinate-Datenmodell (Wikibase `LatLongValue`). `λ` und `λ ± 360` sind derselbe Meridian, und GEUL normalisiert nicht. Die übrigen Regeln (binary64, endlicher Wert, Achsenreihenfolge, Bedeutung von Uncertainty und Unit, Darstellung von „unbekannt“) sind dieselben wie bei COORDINATE-EARTH.
- Das Koordinatensystem folgt je Himmelskörper der Konvention dieses Himmelskörpers (planetozentrische Breite, Ost- oder Westlänge 0 bis 360° usw.). Das Koordinatensystem je Himmelskörper wird in einem eigenen GEUL-Dokument festgelegt.
- Eine Uncertainty in einer Entfernungseinheit (Meter usw.) ist eine Entfernung auf der Oberfläche des Himmelskörpers. Winkeleinheiten (Grad, Bogenminute, Bogensekunde) sind unabhängig von der Größe des Himmelskörpers der Winkelradius von Breite und Länge.
- Für Koordinaten der Erde (Q2) wird COORDINATE-EARTH empfohlen. Auch die Erde in diesem Format anzugeben ist nicht invalid, und die vergleichende Seite gleicht sie als dieselbe Koordinate an.
- Das geul.org-Spezifikationsdokument `0x00000000/codecs/0x00000650` setzt in den Rohwert-Feldern Latitude, Longitude und Uncertainty den [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) und im Unit-Record-Feld die CODEC `000F`, `020F`, `040F` (beliebiger Reference) und `0000` (ABSENT).

## Länge {#길이}

- Die Gesamtzahl ist 1 WORD TAG + (Length-Erweiterungs-TAG) + Globe-Record + 10 WORD + Unit-Record.
- Hat Globe 2 WORD (wenn die QID in 1 WORD passt) und ist Unit ABSENT, sind es 14 WORD, `LLLL=1101`, TAG `065D`. Ist Unit ein Reference (2 WORD oder mehr), liegt die Gesamtzahl über 15 WORD und es wird die erweiterte Länge verwendet: TAG `065E`, im nächsten WORD die Gesamtzahl der WORD ([Record und TAG WORD](../record.md)).

## Entsprechung in Wikidata {#위키데이터-대응}

- Ein globecoordinate, dessen globe nicht die Erde (Q2) ist, wird in diesem Format geschrieben. Globe = WIKIDATA-QID (globe-Objekt). Die Entsprechung von Breite, Länge und precision → Uncertainty·Unit ist dieselbe wie bei COORDINATE-EARTH (die precision ist eine Aufzeichnungsauflösung in Grad und wird unabhängig von der Größe des Himmelskörpers unverändert übernommen).
- Himmelskörper außerhalb der Erde in der Wikidata-Stichprobe (etwa 24.000 Koordinaten-Claims): 23 Fälle wie Mars (Q111), Ceres (Q596), Mond (Q405), Merkur (Q308), Venus (Q313). Die 41 Fälle mit leerem globe werden nicht konvertiert, sondern der Originaltext wird als UTF8-TEXT bewahrt.

## Beispiel {#예시}

Mars (Q111) 4.5, 137.4, Unsicherheit unbekannt:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, unbekannt).
- Textschreibweise: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Derselbe Punkt, precision 0,1° (Unit Grad Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, erweiterte Länge), Gesamtzahl `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## Normative Grundlage {#표준-근거}

- Bedeutung: Breite, Länge und `u` (wenn Unit Meter ist) aus [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). Das einzige in `crs` von RFC 5870 registrierte Koordinatensystem ist `wgs84`, daher werden Himmelskörper außerhalb der Erde durch den GEUL-Globe-Reference angegeben.
- Zahlenwerte: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (Breite, Länge), binary32 (Unsicherheit).
- Längenbereich: `-360 ≤ λ ≤ 360` des Wikidata-globecoordinate-Datenmodells [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## Offene Probleme {#열린-문제}

1. Dokumente zum Koordinatensystem je Himmelskörper: Definition der Breite (planetozentrisch, planetographisch) sowie Richtung und Bereich der Länge je Himmelskörper.

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000650/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

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
