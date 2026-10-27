---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY ist ein Value, der eine Größe in vier Records enthält: exakte Dezimalmenge, Einheiten-Reference, untere und obere Schranke."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY ist ein Value, der eine Größe mit exakter Dezimalzahl, Einheit sowie unterer und oberer Schranke darstellt. Direkter Value-Code `0x06`, Familie NUMERIC. Die vier Teile sind jeweils vollständige Records. Einheit und Schranken sind [optionale Felder](/de/grammar/codec-spec/) und erhalten, wenn sie ausgelassen werden, ABSENT (`0x0000`).

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
amount            SIGNED-DECIMAL-Value-Record
unit              Reference-Record (Einheiten-Eintrag), bei Einheitenlosigkeit 0x0000
lower             SIGNED-DECIMAL-Value-Record, falls ausgelassen 0x0000 ABSENT
upper             SIGNED-DECIMAL-Value-Record, falls ausgelassen 0x0000 ABSENT
```

## Interpretation und Gültigkeit

- amount ist [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/) `C×10^E`. C und E bewahren die Stellenzahl der ursprünglichen Schreibweise unverändert: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Beide Werte sind dieselbe Zahl, haben aber unterschiedliche signifikante Stellen und sind daher verschiedene Values. Für die Stellenzahl des Koeffizienten gibt es keine Obergrenze (Zweierkomplement mit minimaler WORD-Zahl, variable Länge).
- unit ist genau ein vollständiger Reference-Record oder `0x0000`. Jedes Reference, das auf einen Einheiten-Eintrag verweist, kann verwendet werden (bei Wikidata-Einheiten WIKIDATA-QID). `0x0000` ist einheitenlos (Anzahl, Verhältnis, Einwohnerzahl usw.).
- lower und upper sind jeweils ein SIGNED-DECIMAL-Record oder `0x0000`. Es genügt, wenn nur eines vorhanden ist. Auch ein symmetrischer Bereich (`652 ± 1`) wird mit unterer und oberer Schranke geschrieben (`651`, `653`). Da es asymmetrische Bereiche gibt und ohnehin zwei Werte nötig sind, gibt es kein auf ein ± verkürztes Format.
- Die Einheit ist Teil des Wertes. Man löst die Einheit nicht per QUALIFIER o. Ä. heraus (ohne sie weiß man bei `652` nicht, ob es km oder m sind).
- Ein in SI-Einheiten umgerechneter Wert wird nicht abgelegt. Er ist ein abgeleiteter Wert, der sich aus Einheit und Umrechnungstabelle berechnen lässt.
- Der Cursor nach dem Lesen der vier Records muss genau mit dem Ende des Payloads übereinstimmen. Jede andere Form ist invalid.
- Das geul.org-Spezifikationsdokument beschreibt es mit vier Record-Feldern: amount (`0810`), unit (`0780`, `0000`), lower und upper (`0810`, `0000`) ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).

## Länge

- Insgesamt sind es TAG 1 WORD + (Length-Erweiterungs-TAG) + vier Records. Ein Dezimal-Record ist TAG 1 + Exponent 2 + Koeffizient mindestens 1 WORD.
- Eine kleine einheitenlose Zahl ohne Schranken hat 8 WORD. Ab 15 WORD wird die erweiterte Länge verwendet ([Record und TAG WORD](/de/grammar/record/)).

## Beispiel

Einheitenlos `1.20`:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower und upper `0000`.

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
- Die unit `"1"` ist einheitenlos (`0x0000`), `http://www.wikidata.org/entity/Qn` ist WIKIDATA-QID. Andere Einheiten sowie Zahlen und Schranken, die nicht dem Format entsprechen, werden nicht konvertiert, sondern der Originaltext wird als UTF8-TEXT bewahrt.
- Wikidata-Stichprobe (etwa 42.000 Quantity-Einträge aus dem Anfang des Dumps): 61 % einheitenlos, 13 % mit Schranken (davon 93 % symmetrisch), längstes amount 31 Zeichen.

## Normgrundlage

- Dezimalschreibweise und Bewahrung der Stellenzahl: Die Konzepte coefficient, exponent und quantum von [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal (GEUL SIGNED-DECIMAL).
- Wikidata-Mengenmodell: Wikibase DataModel `QuantityValue`.

## Verwandte Seiten

- [Value](/de/grammar/value/), [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/de/grammar/value/numeric/coordinate-geo/), [CODEC](/de/grammar/edge/codec/), [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/)
