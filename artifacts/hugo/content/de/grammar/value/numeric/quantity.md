---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY ist ein Value, der eine Größe in vier Records enthält: Menge als numerischer Value-Record (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch), Einheiten-Reference, untere und obere Schranke."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY ist ein Value, der eine Größe mit einer Zahl, Einheit sowie unterer und oberer Schranke darstellt. Direkter Value-Code `0x06`, Familie NUMERIC. Die vier Teile sind jeweils vollständige Records. Einheit und Schranken sind [optionale Felder](/de/grammar/codec-spec/) und erhalten, wenn sie ausgelassen werden, ABSENT (`0x0000`).

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
amount            numerischer Value-Record (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch)
unit              Reference-Record (Einheiten-Eintrag), bei Einheitenlosigkeit 0x0000
lower             numerischer Value-Record, falls ausgelassen 0x0000 ABSENT
upper             numerischer Value-Record, falls ausgelassen 0x0000 ABSENT
```

## Interpretation und Gültigkeit

- amount ist genau ein vollständiger numerischer Value-Record. Zulässig sind sechs Codecs: [SIGNED-INTEGER](/de/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/de/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/de/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/de/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/) (`0x10`) und [UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/) (`0x11`). Die Liste ist geschlossen, kein Wildcard. BOOL, COORDINATE-EARTH und COORDINATE-GEO, QUANTITY selbst (keine Verschachtelung, feste Tiefe) und andere Values sind nicht zulässig. Für amount kann kein Platzhalter-Marker (`0x0000` o. Ä.) stehen.
- Auch die inneren Records folgen der kanonischen Form ihres Codecs (minimale WORD-Zahl für Ganzzahlen und Koeffizienten, 1/2/4/8 WORD für BINARY-FLOAT, FRACTION nach seinen eigenen Regeln). Ist ein innerer Record nicht kanonisch, ist die ganze QUANTITY invalid.
- Ist amount, lower oder upper ein BINARY-FLOAT, muss der Wert endlich sein. NaN und ±Infinity sind invalid (dieselbe Regel wie für Breite und Länge von [COORDINATE-EARTH](/de/grammar/value/numeric/coordinate-earth/)).
- Das Zahlformat folgt unverändert der ursprünglichen Schreibweise. Ein ganzzahliges Original wird als INTEGER, ein Original mit Nachkommastellen als DECIMAL, ein Bruch als FRACTION und ein IEEE-754-Binärwert als BINARY-FLOAT abgelegt; der Encoder normalisiert nicht durch Wechsel des Formats. C und E eines DECIMAL bewahren die Stellenzahl der ursprünglichen Schreibweise unverändert: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Beide Werte sind dieselbe Zahl, haben aber unterschiedliche signifikante Stellen und sind daher verschiedene Values. Für die Stellenzahl von Ganzzahlen und Koeffizienten gibt es keine Obergrenze (minimale WORD-Zahl, variable Länge).
- unit ist genau ein vollständiger Reference-Record oder `0x0000`. Jedes Reference, das auf einen Einheiten-Eintrag verweist, kann verwendet werden (bei Wikidata-Einheiten WIKIDATA-QID). `0x0000` ist einheitenlos (Anzahl, Verhältnis, Einwohnerzahl usw.).
- lower und upper sind jeweils ein Record eines der sechs Codecs von amount oder `0x0000` ABSENT. Als Platzhalter-Marker ist nur das Auslassen mit ABSENT zulässig. Es genügt, wenn nur eines vorhanden ist. Die drei Zahlen müssen nicht denselben Codec haben. Auch ein symmetrischer Bereich (`652 ± 1`) wird mit unterer und oberer Schranke geschrieben (`651`, `653`). Da es asymmetrische Bereiche gibt und ohnehin zwei Werte nötig sind, gibt es kein auf ein ± verkürztes Format.
- lower ≤ amount ≤ upper wird nach dem Zahlenwert verglichen, nicht nach Bytes oder Codec. Auch bei unterschiedlichen Typen wird als Zahl verglichen (z. B. SIGNED-INTEGER `652` und SIGNED-DECIMAL `651.5`). FRACTION wird als exakte rationale Zahl verglichen.
- Die Einheit ist Teil des Wertes. Man löst die Einheit nicht per QUALIFIER o. Ä. heraus (ohne sie weiß man bei `652` nicht, ob es km oder m sind).
- Herausgelöst ist der amount-Record unverändert ein eigenständiger Value-Record. Wird die Zahl ohne Einheit gebraucht, verwendet man diesen Record ohne Neukodierung.
- Ein in SI-Einheiten umgerechneter Wert wird nicht abgelegt. Er ist ein abgeleiteter Wert, der sich aus Einheit und Umrechnungstabelle berechnen lässt.
- Der Cursor nach dem Lesen der vier Records muss genau mit dem Ende des Payloads übereinstimmen. Jede andere Form ist invalid.
- Das geul.org-Spezifikationsdokument beschreibt es mit vier Record-Feldern: amount (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`), unit (`0780`, `0000`), lower und upper (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`, `0000`) ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).

## Länge

- Insgesamt sind es TAG 1 WORD + (Length-Erweiterungs-TAG) + vier Records. Ein Ganzzahl-Record ist TAG 1 + Payload mindestens 1 WORD, ein BINARY-FLOAT-Record 2, 3, 5 oder 9 WORD und ein Dezimal-Record TAG 1 + Exponent 2 + Koeffizient mindestens 1 WORD. Ein FRACTION-Record hat mindestens 5 WORD.
- Eine kleine einheitenlose Ganzzahl ohne Schranken hat 6 WORD, eine kleine Dezimalzahl 8 WORD. Ab 15 WORD wird die erweiterte Länge verwendet ([Record und TAG WORD](/de/grammar/record/)).

## Beispiel

Einheitenlos `1.20`:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower und upper `0000`.

Einheitenlose Ganzzahl `42`:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit, lower und upper `0000`.

Einheitenloser Bruch `2/3` (zwei Drittel der anwesenden Stimmrechte):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/de/grammar/value/numeric/fraction/) 2/3), unit, lower und upper `0000`.

`652 km`, Bereich `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- Insgesamt 17 WORD, daher `LLLL=1110`, Erweiterungs-TAG `0011`.

## Entsprechung in Wikidata

- Das `quantity`-datavalue `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. Amount und Schranken-Zeichenketten (`+1.20`, auch Exponentialschreibweise) werden mit ihrer Stellenzahl unverändert in C und E übertragen.
- amount und Schranken in Wikidata sind Dezimal-Strings; auch in ganzzahliger Form (`+652`) werden sie daher als SIGNED-DECIMAL übernommen. Die Wikidata-Konvertierung verwendet keine anderen numerischen Codecs.
- Die unit `"1"` ist einheitenlos (`0x0000`), `http://www.wikidata.org/entity/Qn` ist WIKIDATA-QID. Andere Einheiten sowie Zahlen und Schranken, die nicht dem Format entsprechen, werden nicht konvertiert, sondern der Originaltext wird als UTF8-TEXT bewahrt.
- Wikidata-Stichprobe (etwa 42.000 Quantity-Einträge aus dem Anfang des Dumps): 61 % einheitenlos, 13 % mit Schranken (davon 93 % symmetrisch), längstes amount 31 Zeichen.

## Normgrundlage

- Dezimalschreibweise und Bewahrung der Stellenzahl: Die Konzepte coefficient, exponent und quantum von [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal (GEUL SIGNED-DECIMAL).
- Wikidata-Mengenmodell: Wikibase DataModel `QuantityValue`.

## Verwandte Seiten

- [Value](/de/grammar/value/), [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/de/grammar/value/numeric/coordinate-geo/), [CODEC](/de/grammar/edge/codec/), [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/)
