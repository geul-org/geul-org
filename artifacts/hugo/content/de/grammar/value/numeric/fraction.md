---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION ist ein Bruch-Value, der Zähler (Ganzzahl oder Dezimalzahl) und Nenner (vorzeichenlose Ganzzahl oder Dezimalzahl) genau so enthält, wie sie im Original stehen, ohne zu kürzen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION ist ein Value, der einen in einem Originaltext geschriebenen Bruch unter Wahrung seiner Schreibweise darstellt. Direkter Value-Code `0x07`, Familie NUMERIC. Zähler und Nenner sind jeweils ein vollständiger Value-Record. Es wird nicht gekürzt. FRACTION enthält Brüche, deren Schreibweise selbst der Nachweis ist, etwa „zwei Drittel“ und „fünf von hundert“ in Gesetzen und den dezimalen Anteil `23.45/1256.1` im Grundbuch.

## Layout

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
numerator         ein Value-Record: SIGNED-INTEGER oder SIGNED-DECIMAL
denominator       ein Value-Record: UNSIGNED-INTEGER oder UNSIGNED-DECIMAL
```

## Interpretation und Gültigkeit

- numerator ist genau ein Record [SIGNED-INTEGER](/de/grammar/value/numeric/signed-integer/) (`0x01`) oder [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/) (`0x10`).
- denominator ist genau ein Record [UNSIGNED-INTEGER](/de/grammar/value/numeric/unsigned-integer/) (`0x02`) oder [UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/) (`0x11`).
- Die Liste ist geschlossen. Andere Values, FRACTION selbst (keine Verschachtelung) und Platzhalter-Marker (`0x0000` o. Ä.) sind nicht zulässig.
- Jeder der beiden Records trägt seine eigene Länge, daher wird keine Grenze gesondert geschrieben. Der Cursor nach dem Lesen beider Records muss genau mit dem Ende des Payloads übereinstimmen.
- Auch die inneren Records folgen der kanonischen Form ihres Codecs (minimale WORD-Zahl für Ganzzahlen und Koeffizienten). Ist ein innerer Record nicht kanonisch, ist die ganze FRACTION invalid.
- Der Wert ist `numerator / denominator`.

### Wahrung der Schreibweise

- **Ganzzahl und Dezimalzahl**: Ist eine Komponente im Original eine Ganzzahl (ohne Dezimalpunkt), wird ein INTEGER-Record verwendet, mit Dezimalpunkt ein DECIMAL-Record. Eine Komponente als DECIMAL mit Exponent `E = 0` zu schreiben ist invalid. So hat eine Schreibweise genau eine Bytefolge.
- C und E einer DECIMAL-Komponente bewahren die Stellenzahl des Originals unverändert. `23.450` ist `23450×10^-3` und ein anderer Value als `23.45`.
- **Es wird nicht gekürzt.** `2/4` und „fünf von hundert“ (`5/100`) werden so geschrieben, wie sie stehen. Sind die Bytes gleich, ist die ursprüngliche Schreibweise gleich.
- Ein Bruch mit Nenner 1 (`3/1`) wird ebenfalls so geschrieben, wenn das Original ihn so schreibt. Ist das Original eine Ganzzahl, wird ein Ganzzahl-Codec statt FRACTION verwendet. Ist das Original eine Dezimalzahl (`0.5`, `5%`), wird DECIMAL verwendet.
- Das Vorzeichen steht nur am Zähler. Der Nenner ist ein vorzeichenloser Codec.
- Ein Nenner mit dem Wert 0 ist invalid (sowohl `0` als auch `0.0`).

### Vergleich

- Die Vergleichsschicht berechnet FRACTION als exakte rationale Zahl `(C1 × 10^E1) / (C2 × 10^E2)` (bei einer INTEGER-Komponente `E = 0`). Sie nähert nicht mit Gleitkomma an.
- Vergleich, Sortierung und Duplikaterkennung verwenden diesen Wert; Speicherung, Signaturen und Inhalts-Hashes verwenden die Schreibweise (Bytes). `2/4`, `1/2` und `0.5` haben denselben Wert und verschiedene Bytes.
- Die Quorumsprüfung („mindestens zwei Drittel der Stimmrechte der anwesenden Aktionäre“) vergleicht mit diesem exakten Wert.

## Länge

- Insgesamt sind es TAG 1 WORD + (Length-Erweiterungs-TAG) + zwei Records. Ein Ganzzahl-Record ist TAG 1 + Payload mindestens 1 WORD, ein Dezimal-Record TAG 1 + Exponent 2 + Koeffizient mindestens 1 WORD.
- Ein kleiner ganzzahliger Bruch hat 5 WORD, ein kleiner dezimaler Bruch 9 WORD. Ab 15 WORD wird die erweiterte Länge verwendet ([Record und TAG WORD](/de/grammar/record/)).

| Original | Komponenten | Gesamt |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Beispiel

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`, 5 WORD), numerator `0881 0002` (SIGNED-INTEGER 2), denominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD), numerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Beziehung zu anderen Formaten

- amount, lower und upper von [QUANTITY](/de/grammar/value/numeric/quantity/) nehmen FRACTION an. „Zwei Drittel der anwesenden Stimmrechte“ lässt sich als einheitenlose QUANTITY mit amount `2/3` schreiben.
- Das Spezifikationsdokument `0x0000/0x0000000000000807` auf geul.org schreibt es mit zwei Record-Feldern: numerator (`0801`, `0810`) und denominator (`0802`, `0811`) ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).
- Wird ein fester int64-Bruch mit erzwungener Kürzung gebraucht, verwendet man das Issuer-Format [RATIONAL-I64](/de/grammar/value/etc/rational-i64/).

## Offene Fragen

1. Die Wahrung der Schreibweise gemischter Zahlen (`1 2/3`).
2. Ein Format, das einen Bruch mit Einheiten in den Komponenten (Fläche/Fläche) als zwei QUANTITY enthält. FRACTION enthält keine Einheit.
3. Die Schreibregel für Prozent und Promille (`5%`, `5‰`): DECIMAL mit Einheit oder FRACTION (`5/100`).
4. Doppelbrüche (FRACTION im Zähler oder Nenner). Derzeit verboten.

## Verwandte Seiten

- [Value](/de/grammar/value/), [QUANTITY](/de/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/de/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/de/grammar/value/etc/rational-i64/)
