---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION ist ein Value, der einen im Originaltext angegebenen Bruch in seiner ursprünglichen Schreibweise darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `FRACTION` (Spezifikationsdokument BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000670/` (DECLARE-Ziel `0670`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 7 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | Bruch in der Originalschreibweise: Zähler als Ganzzahl oder Dezimalzahl, Nenner als vorzeichenlose Ganzzahl oder Dezimalzahl. Wird nicht gekürzt |
| Hugo-Seite | `value/numeric/fraction.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | Record | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | Record | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION ist ein Value, der einen im Originaltext angegebenen Bruch in seiner ursprünglichen Schreibweise darstellt. Direkter Value-Code `0x067L`, Familie NUMERIC. Zähler und Nenner sind jeweils vollständige Value-Records. Es wird nicht gekürzt. Aufgenommen werden Brüche, bei denen die Schreibweise selbst der Datensatz ist, etwa „zwei Drittel“ oder „fünf Hundertstel“ in Gesetzen und der Dezimalanteil `23.45/1256.1` in Grundbucheinträgen.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
numerator         1 Value-Record: SIGNED-INTEGER oder SIGNED-DECIMAL
denominator       1 Value-Record: UNSIGNED-INTEGER oder UNSIGNED-DECIMAL
```

## Interpretation und Gültigkeit {#해석과-유효성}

- numerator ist genau ein [SIGNED-INTEGER](0x061L-signed-integer.md)- (`0x061L`) oder [SIGNED-DECIMAL](0x068L-signed-decimal.md)-Record (`0x068L`).
- denominator ist genau ein [UNSIGNED-INTEGER](0x062L-unsigned-integer.md)- (`0x062L`) oder [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md)-Record (`0x069L`).
- Die Liste ist geschlossen. Andere Value, FRACTION selbst (Verschachtelung verboten) und Slot-Marker (`0x0000` usw.) werden nicht akzeptiert.
- Die beiden Records haben jeweils eigene Längen, daher wird keine Grenze gesondert angegeben. Der Cursor nach dem Lesen der beiden Records muss genau mit dem Ende des Payload übereinstimmen.
- Auch innere Records folgen der kanonischen Form ihres jeweiligen Codec (Ganzzahl und coefficient mit minimaler WORD-Anzahl). Gibt es einen nicht kanonischen inneren Record, ist das gesamte FRACTION invalid.
- Der Wert ist `numerator / denominator`.

### Bewahrung der Schreibweise {#표기-보존}

- **Ganzzahl und Dezimalzahl**: Ist die Komponente im Original eine Ganzzahl (ohne Dezimalpunkt), wird ein INTEGER-Record verwendet, mit Dezimalpunkt ein DECIMAL-Record. Eine Komponente als DECIMAL mit Exponent `E = 0` zu schreiben ist invalid. So hat dieselbe Schreibweise genau eine Bytefolge.
- C und E einer DECIMAL-Komponente entsprechen der Stellenzahl des Originals. `23.450` ist `23450×10^-3` und ein anderer Value als `23.45`.
- **Es wird nicht gekürzt.** `2/4` und „fünf Hundertstel“ (`5/100`) werden unverändert geschrieben. Gleiche Bytes bedeuten gleiche Originalschreibweise.
- Auch ein Bruch mit Nenner 1 (`3/1`) wird so geschrieben, wenn das Original ihn so angibt. Ist das Original eine Ganzzahl, wird nicht FRACTION, sondern ein Ganzzahl-Codec verwendet. Ist das Original eine Dezimalzahl (`0.5`, `5%`), wird DECIMAL verwendet.
- Das Vorzeichen steht nur im Zähler. Der Nenner ist ein vorzeichenloser Codec.
- Ist der Wert des Nenners 0, ist es invalid (sowohl `0` als auch `0.0`).

### Vergleich {#비교}

- Die Vergleichsschicht berechnet FRACTION als exakte rationale Zahl `(C1 × 10^E1) / (C2 × 10^E2)` (INTEGER-Komponenten mit `E = 0`). Es wird nicht durch Gleitkomma angenähert.
- Vergleich, Sortierung und Duplikaterkennung erfolgen mit diesem Wert, Speicherung, Signatur und Inhaltshash mit der Schreibweise (den Bytes). `2/4`, `1/2` und `0.5` haben denselben Wert und unterschiedliche Bytes.
- Die Beschlussfähigkeitsprüfung („mindestens zwei Drittel der Stimmrechte der anwesenden Aktionäre“) vergleicht mit diesem exakten Wert.

## Länge {#길이}

- Die Gesamtzahl ist 1 WORD TAG + (Length-Erweiterungs-TAG) + zwei Records. Ein Ganzzahl-Record hat TAG 1 + Payload ab 1 WORD, ein Dezimal-Record TAG 1 + Exponent 2 + coefficient ab 1 WORD.
- Ein Bruch aus kleinen Ganzzahlen hat 5 WORD, ein Bruch aus kleinen Dezimalzahlen 9 WORD. Ab 15 WORD wird die erweiterte Länge verwendet ([Record und TAG WORD](../record.md)).

| Original | Komponenten | Gesamt |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Beispiel {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`, 5 WORD), numerator `0611 0002` (SIGNED-INTEGER 2), denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD), numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Beziehung zu anderen Formaten {#다른-형식과의-관계}

- amount, lower und upper von [QUANTITY](0x066L-quantity.md) akzeptieren FRACTION. „Zwei Drittel der Stimmrechte der anwesenden Aktionäre“ lässt sich als QUANTITY ohne Einheit mit amount `2/3` schreiben.
- Das geul.org-Spezifikationsdokument `0x00000000/codecs/0x00000670` schreibt zwei Record-Felder: numerator (`0610`, `0680`) und denominator (`0620`, `0690`) ([Codec-Spezifikationsdokument](../codec-spec.md)).
- Wird ein Bruch mit fester int64-Breite benötigt, der das Kürzen erzwingt, wird das Issuer-Format [RATIONAL-I64](adhoc.geul.org/rational-i64.md) verwendet.

## Offene Probleme {#열린-문제}

1. Bewahrung der Schreibweise gemischter Brüche (`1 und 2/3`).
2. Ein Format, das einen Bruch mit Einheiten in den Komponenten (Fläche/Fläche) in zwei QUANTITY aufnimmt. FRACTION nimmt keine Einheiten auf.
3. Das Schreibkriterium, ob Prozent und Promille (`5%`, `5‰`) als DECIMAL mit Einheit oder als FRACTION (`5/100`) gelten.
4. Doppelbrüche (FRACTION in Zähler und Nenner). Sie sind derzeit verboten.

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000670/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
