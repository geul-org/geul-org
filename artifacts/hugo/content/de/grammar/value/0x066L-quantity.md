---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY ist ein Value, der eine Größe durch Zahl, Einheit sowie untere und obere Grenze darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `QUANTITY` (Spezifikationsdokument BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000660/` (DECLARE-Ziel `0660`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 6 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | numerischer Value amount (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch), Einheiten-Reference, untere und obere Grenze. Einheit und Grenzen sind weglassbar (ABSENT `0x0000`) |
| Hugo-Seite | `value/numeric/quantity.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | Record | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `0000` ABSENT (optionales Feld) |  |
| 3 | `lower` | #4 | Record | `0680` SIGNED-DECIMAL, `0000` ABSENT (optionales Feld), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | Record | `0680` SIGNED-DECIMAL, `0000` ABSENT (optionales Feld), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY ist ein Value, der eine Größe durch Zahl, Einheit sowie untere und obere Grenze darstellt. Direkter Value-Code `0x066L`, Familie NUMERIC. Die vier Teile sind jeweils vollständige Records. Einheit und Grenzen sind [optionale Felder](../codec-spec.md), daher wird beim Weglassen ABSENT (`0x0000`) verwendet.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
amount            numerischer Value-Record (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch)
unit              Reference-Record (Einheitenobjekt), bei Größe ohne Einheit 0x0000
lower             numerischer Value-Record, bei Weglassen 0x0000 ABSENT
upper             numerischer Value-Record, bei Weglassen 0x0000 ABSENT
```

## Interpretation und Gültigkeit {#해석과-유효성}

- amount ist genau ein vollständiger numerischer Value-Record. Zulässige Codec sind sechs: [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`), [FRACTION](0x067L-fraction.md) (`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`), [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). Die Liste ist geschlossen und kein Wildcard. BOOL, COORDINATE-EARTH·COORDINATE-GEO, QUANTITY selbst (Verschachtelung verboten, Tiefe fest) und andere Value werden nicht akzeptiert. In amount darf kein Slot-Marker (`0x0000` usw.) stehen.
- Auch innere Records folgen der kanonischen Form ihres jeweiligen Codec (Ganzzahl und coefficient mit minimaler WORD-Anzahl, BINARY-FLOAT mit 1/2/4/8 WORD, FRACTION nach dessen Regeln). Gibt es einen nicht kanonischen inneren Record, ist das gesamte QUANTITY invalid.
- Sind amount, lower oder upper BINARY-FLOAT, müssen sie endliche Werte sein. NaN und ±Infinity sind invalid (dieselbe Regel wie bei Breite und Länge in [COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- Das Zahlenformat folgt der ursprünglichen Schreibweise. Ein ganzzahliger Originalwert wird als INTEGER, ein Dezimalbruch als DECIMAL, ein Bruch als FRACTION und ein IEEE-754-Binärwert als BINARY-FLOAT gespeichert, und der Encoder normalisiert nicht durch einen Formatwechsel. C und E von DECIMAL bewahren die Stellenzahl der ursprünglichen Schreibweise: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Beide Werte sind dieselbe Zahl, haben aber unterschiedliche signifikante Stellen und sind daher verschiedene Value. Für die Stellenzahl von Ganzzahl und coefficient gibt es keine Obergrenze (minimale WORD-Anzahl, variable Länge).
- unit ist genau ein vollständiger Reference-Record oder `0x0000`. Jeder Reference, der auf ein Einheitenobjekt zeigt, ist zulässig (Wikidata-Einheiten: WIKIDATA-QID). `0x0000` bedeutet ohne Einheit (Anzahl, Verhältnis, Einwohnerzahl usw.).
- lower und upper sind jeweils ein Record eines der sechs Codec wie bei amount oder `0x0000` ABSENT. Als Slot-Marker wird nur das Weglassen durch ABSENT akzeptiert. Es genügt auch, nur eine der beiden zu haben. Die Codec der drei Zahlen müssen nicht gleich sein.
- lower ≤ amount ≤ upper wird nicht nach Bytes oder Codec, sondern nach Zahlenwert verglichen. Auch bei unterschiedlichen Typen wird als Zahl verglichen (z. B. SIGNED-INTEGER `652` und SIGNED-DECIMAL `651.5`). FRACTION wird als exakte rationale Zahl verglichen. Auch ein symmetrischer Bereich (`652 ± 1`) wird mit unterer und oberer Grenze geschrieben (`651`, `653`). Da es auch asymmetrische Bereiche gibt und ohnehin zwei Werte nötig sind, gibt es kein Format, das auf ein einzelnes ± verkürzt.
- Die Einheit ist Teil des Werts. Die Einheit wird nicht durch QUALIFIER o. Ä. abgetrennt (sonst wäre nicht erkennbar, ob `652` km oder m bedeutet).
- Der herausgenommene amount-Record ist unverändert ein eigenständiger Value-Record. Wird die Zahl ohne Einheit gebraucht, wird dieser Record verwendet, ohne neu zu codieren.
- Ein in SI-Einheiten umgerechneter Wert wird nicht gespeichert. Er ist ein abgeleiteter Wert, der sich aus Einheit und Umrechnungstabelle berechnen lässt.
- Der Cursor nach dem Lesen der vier Records muss genau mit dem Ende des Payload übereinstimmen. Jede andere Form ist invalid.
- Das geul.org-Spezifikationsdokument schreibt vier Record-Felder: amount (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`), unit (`000F`, `020F`, `040F`, `0000`), lower und upper (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`, `0000`) ([Codec-Spezifikationsdokument](../codec-spec.md)).

## Länge {#길이}

- Die Gesamtzahl ist 1 WORD TAG + (Length-Erweiterungs-TAG) + vier Records. Ein Ganzzahl-Record hat TAG 1 + Payload ab 1 WORD, ein BINARY-FLOAT-Record 2, 3, 5 oder 9 WORD, ein Dezimal-Record TAG 1 + Exponent 2 + coefficient ab 1 WORD, ein FRACTION-Record ab 5 WORD.
- Eine kleine Ganzzahl ohne Einheit und ohne Grenzen hat 6 WORD, eine kleine Dezimalzahl 8 WORD. Ab 15 WORD wird die erweiterte Länge verwendet ([Record und TAG WORD](../record.md)).

## Beispiel {#예시}

Ohne Einheit `1.20`:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078` (E = -2, C = 120), unit, lower und upper `0000`.

Ohne Einheit, Ganzzahl `42`:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD), amount `0611 002A` (SIGNED-INTEGER 42), unit, lower und upper `0000`.

Ohne Einheit, Bruch `2/3` (zwei Drittel der anwesenden Stimmrechte für einen Beschluss):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD), amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3), unit, lower und upper `0000`.

`652 km`, Bereich `[651, 653]` (km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- Insgesamt 17 WORD, daher `LLLL=1110`, Erweiterungs-TAG `0011`.

## Entsprechung in Wikidata {#위키데이터-대응}

- Das `quantity`-datavalue `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. Die Zeichenketten von amount und Grenzen (`+1.20`, auch mit Exponentialschreibweise) werden mit unveränderter Stellenzahl in C und E übertragen.
- Da amount und Grenzen in Wikidata Dezimalzeichenketten sind, werden sie auch bei ganzzahliger Form (`+652`) als SIGNED-DECIMAL übertragen. Die Wikidata-Konvertierung verwendet keine anderen numerischen Codec.
- Die unit `"1"` ist ohne Einheit (`0x0000`), `http://www.wikidata.org/entity/Qn` ist WIKIDATA-QID. Andere Einheiten sowie Zahlen und Grenzen in unpassendem Format werden nicht konvertiert, sondern der Originaltext wird als UTF8-TEXT bewahrt.
- Wikidata-Stichprobe (etwa 42.000 quantity vom Anfang des Dumps): ohne Einheit 61 %, mit Grenzen 13 % (davon 93 % symmetrisch), längster amount 31 Zeichen.

## Normative Grundlage {#표준-근거}

- Dezimalschreibweise und Bewahrung der Stellenzahl: die Konzepte coefficient, exponent und quantum der Dezimalformate in [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (GEUL SIGNED-DECIMAL).
- Wikidata-Mengenmodell: Wikibase DataModel `QuantityValue`.

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000660/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

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
