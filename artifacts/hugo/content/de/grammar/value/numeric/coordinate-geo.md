---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO ist ein Value, der einen Punkt auf einem Himmelskörper wie Planet oder Mond mit Himmelskörper-Reference, Breite und Länge als binary64, Unsicherheit als binary32 und deren Einheiten-Reference enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO ist ein Koordinaten-Value, der einen Punkt auf einem bestimmten Himmelskörper (Planet, Mond, Asteroid usw.) mit Breite, Länge und Unsicherheit darstellt. Direkter Value-Code `0x05`, Familie NUMERIC. Es ist das Format [COORDINATE-EARTH](/de/grammar/value/numeric/coordinate-earth/) (`0x04`) mit einem vorangestellten Himmelskörper-Reference (Globe); die Regeln für Breite, Länge, Unsicherheit und Einheit sind dieselben wie bei COORDINATE-EARTH.

## Layout

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Globe             1 Reference-Record (Reference, der auf den Himmelskörper verweist, Quantifier Identified)
Latitude          4 WORD Rohwert, IEEE 754 binary64 (Grad)
Longitude         4 WORD Rohwert, IEEE 754 binary64 (Grad)
Uncertainty       2 WORD Rohwert, IEEE 754 binary32 (in der Einheit Unit)
Unit              1 Reference-Record oder Slot-Marker 0x0000 ABSENT
```

## Interpretation und Gültigkeit

- Der Payload beginnt mit dem Globe-Record. Globe ist genau ein vollständiger Reference-Record, und der Quantifier ist Identified (`000`). Jedes Reference, das auf einen Himmelskörper verweist, kann verwendet werden: [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) (benannte Himmelskörper), [GEUL](/de/grammar/reference/geul/), ein [LOCAL](/de/grammar/reference/local/) im selben Dokument (im Dokument definierter Himmelskörper), Himmelskörper anderer Dokumente ([EXTERNAL-POINTER](/de/grammar/reference/external-pointer/), [EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/)) usw. Es gibt unzählige Himmelskörper, und die mit QID sind nur ein Teil.
- Nach Globe folgen 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) und ein Unit-Record. Der Cursor nach dem Lesen von Unit muss mit dem Ende des Records übereinstimmen.
- Latitude liegt in `-90 ≤ φ ≤ 90`, Longitude in `-180 ≤ λ ≤ 360`. `(180, 360]` ist zugelassen, um Werte von Himmelskörper-Koordinatensystemen, die die Länge von 0 bis 360° zählen, unverändert aufnehmen zu können. Die übrigen Regeln (binary64, endliche Werte, Achsenreihenfolge, Bedeutung von Uncertainty und Unit, Darstellung von „unbekannt“) sind wie bei COORDINATE-EARTH.
- Das Koordinatensystem folgt für jeden Himmelskörper den Konventionen dieses Himmelskörpers (planetozentrische Breite, östliche oder westliche Länge 0~360° usw.). Koordinatensysteme je Himmelskörper werden in eigenen GEUL-Dokumenten festgelegt.
- Eine Uncertainty in Entfernungseinheiten (Meter usw.) ist eine Entfernung auf der Oberfläche des Himmelskörpers. Winkeleinheiten (Grad, Bogenminute, Bogensekunde) sind unabhängig von der Größe des Himmelskörpers der Winkelradius von Breite und Länge.
- Für Koordinaten auf der Erde (Q2) wird COORDINATE-EARTH empfohlen. Auch die Erde in diesem Format ist nicht invalid; wer vergleicht, gleicht sie als dieselbe Koordinate ab.
- Das geul.org-Spezifikationsdokument `0x0000/0x0000000000000805` setzt bei den Rohwert-Feldern Latitude, Longitude und Uncertainty [CODEC](/de/grammar/edge/codec/) BINARY-FLOAT (`0803`) und beim Record-Feld Unit CODEC `0780` (beliebiges Reference) und `0000` (ABSENT).

## Länge

- Insgesamt sind es TAG 1 WORD + (Length-Erweiterungs-TAG) + Globe-Record + 10 WORD + Unit-Record.
- Ist Globe 2 WORD (wenn die QID in 1 WORD passt) und Unit ABSENT, sind es 14 WORD, `LLLL=1101`, TAG `0E85`. Ist Unit ein Reference (ab 2 WORD), überschreitet es 15 WORD und verwendet die erweiterte Länge: TAG `0F05`, im nächsten WORD die Gesamtzahl der WORD ([Record und TAG WORD](/de/grammar/record/)).

## Entsprechung in Wikidata

- Eine globecoordinate, deren globe nicht die Erde (Q2) ist, wird in diesem Format geschrieben. Globe = WIKIDATA-QID (globe-Eintrag). Breite, Länge und die Zuordnung von precision → Uncertainty und Unit sind wie bei COORDINATE-EARTH (die precision ist die Aufzeichnungsauflösung in Grad und wird unabhängig von der Größe des Himmelskörpers unverändert übertragen).
- Himmelskörper außerhalb der Erde in der Wikidata-Stichprobe (etwa 24.000 Koordinaten-Claims): 23 Fälle wie Mars (Q111), Ceres (Q596), Mond (Q405), Merkur (Q308) und Venus (Q313). Die 41 Fälle mit leerem globe werden nicht konvertiert, sondern der Originaltext als UTF8-TEXT bewahrt.

## Beispiel

Mars (Q111) 4.5, 137.4, Unsicherheit unbekannt:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, unbekannt).
- Textnotation: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Derselbe Punkt, precision 0,1° (Unit Grad Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, erweiterte Länge), insgesamt `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## Normgrundlage

- Bedeutung: Breite, Länge und `u` von [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (wenn Unit Meter ist). Das einzige in `crs` von RFC 5870 registrierte Koordinatensystem ist `wgs84`, daher legt man Himmelskörper außerhalb der Erde über das GEUL-Globe-Reference fest.
- Zahlen: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (Breite, Länge), binary32 (Unsicherheit).

## Offene Fragen

1. Dokumente zu den Koordinatensystemen der einzelnen Himmelskörper: Definition der Breite (planetozentrisch, planetographisch) sowie Richtung und Bereich der Länge je Himmelskörper.

## Verwandte Seiten

- [Value](/de/grammar/value/), [COORDINATE-EARTH](/de/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/), [GEUL](/de/grammar/reference/geul/), [LOCAL](/de/grammar/reference/local/)
