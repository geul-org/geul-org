---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE ist ein TOULMIN-Codec, der ein Prädikat (Beurteilungsausdruck) deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE ist ein TOULMIN-Codec, der ein Prädikat (Beurteilungsausdruck) deklariert. Das Layout ist EXPR. EXPR ist ein Layout, das die Bedingungsausdrücke von TANGEUL Rules schreibt. Der Bedingungsbaum wird in Präordnung abgeflacht abgelegt, und Zeichenketten im Ausdruck verweisen auf eine Label-Tabelle innerhalb des Records. Dadurch ist der Record ohne TEXT-Record in sich abgeschlossen.

| Eigenschaft | Wert |
|---|---|
| Name | `PREDICATE-DECLARE` (BIND `PREDICATE-DECLARE` des Spezifikationsdokuments) |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001010/` (DECLARE-Ziel `1010`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 1 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Deklaration, Layout: EXPR |
| TAG WORD | `0001 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Prädikatdeklaration. Beurteilungsfunktion und -ausdruck, Beurteilungskriterium (Spec), Faktenvertrag (Ground) |
| Hugo-Seite | `edge/toulmin/expr.md` |

## Layout {#레이아웃}

```
ID                     LOCAL Reference Record (Edge Id)
Knotenzahl 1 WORD      Gesamtzahl der Ausdrucks-Records
Labelzahl 1 WORD
Label × Labelzahl      UTF8-TEXT Value Record
Ausdrucks-Record × Knotenzahl   Präordnung
```

- Ein Label ist eine Zeichenkette wie ein Feldname, ein Zeichenkettenwert, ein Pfadschritt oder ein Funktionsname. Auch die leere Zeichenkette ist ein Label. Ein Ausdrucks-Record verweist über einen bei 0 beginnenden Index (1 WORD) auf ein Label.
- Ein Ausdrucks-Record legt nach dem Elternknoten nacheinander die Kinder ab (Präordnung). Aus der Kinderzahl jedes Records und dieser Reihenfolge ergibt sich genau ein Baum.

## Ausdrucks-Record {#식-레코드}

Ein Ausdrucks-Record beginnt mit einem Header von 1 WORD.

```
Header 1 WORD    untere 2 Bit der Art (b15–14) | obere 1 Bit der Art (b13) | Kinderzahl 13 Bit (b12–0)
```

Art = `(b13 << 2) | b15–14`.

| Art | Name | Kinderzahl | Nach dem Header |
|---|---|---|---|
| 0 | COMPARE | 0 | Vergleichsoperator 1 WORD, Feldlabel 1 WORD, Wertposition |
| 1 | LOGIC | n | logischer Operator 1 WORD |
| 2 | NOT | 1 | keine |
| 3 | EITHER | n | keine |
| 4 | EXISTS | 1 | Quantifizierungsoperator 1 WORD, Zieloperand, Label des bindenden Namens 1 WORD |
| 5 | CALL | 0 | Alias-Label 1 WORD, Funktionsnamen-Label 1 WORD |
| 6 | COMPARE-X | 0 | Vergleichsoperator 1 WORD, Feldlabel 1 WORD, linke Markierung 1 WORD [+ Operand], Wertposition |
| 7 | Reserved | | |

- Die Kind-Records folgen nach den Feldern hinter dem Header. Das Kind von EXISTS ist eine einzige Bedingung.
- COMPARE ist ein Vergleich `<Feld> <Operator> <Wert>` ohne Operanden auf beiden Seiten. Ist auf mindestens einer Seite ein Operand vorhanden, wird COMPARE-X verwendet.
- Ist die linke Markierung von COMPARE-X `1`, folgt ein Operand; bei `0` gibt es keinen. Ist ein linker Operand vorhanden, ist das Feldlabel die leere Zeichenkette.
- CALL ist ein Host-Funktionsaufruf an der Prädikatposition. Handelt es sich um eine Funktion dieses Dokuments, ist das Alias-Label die leere Zeichenkette.

### Wertposition {#값-자리}

```
Wertart 1 WORD    0 Zahl, 1 Zeichenkette, 2 Operand
Wert              0: UNSIGNED-INTEGER Value Record
                  1: Label 1 WORD
                  2: Operand (nur bei COMPARE-X)
```

- Entspricht die Wertzeichenkette genau der kanonischen Dezimalschreibweise einer nicht negativen ganzen Zahl, wird sie als UNSIGNED-INTEGER Value geschrieben. Jeder andere Wert wird als Label geschrieben. So lässt sich die Wertzeichenkette unverändert wiederherstellen.

### Operand {#피연산자}

```
Operandenart 1 WORD    0 Pfad, 1 Kriteriumsreferenz, 2 Funktionsaufruf
Pfad, Kriteriumsreferenz   Schrittzahl 1 WORD + Label 1 WORD × Schrittzahl
Funktionsaufruf            Alias-Label 1 WORD + Funktionsnamen-Label 1 WORD
```

- Ein Pfad ist ein Pfad in den Eingabedaten; eine Kriteriumsreferenz ist ein Pfad im per `with` eingespeisten Beurteilungskriterium (SPEC).

### Operatorcodes {#연산자-코드}

| Code | Vergleichsoperator |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| Code | logischer Operator |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Code | Quantifizierungsoperator |
|---|---|
| `0x0321` | any |

### Auswertung unbekannter Eingaben {#미상-입력의-평가}

Vergleichsoperatoren werden dreiwertig (wahr, falsch, unbestimmt U) ausgewertet, wenn die Eingabe ein Slot-Marker ist. Bei NO-VALUE ist `is empty` wahr und jeder andere Vergleich falsch. Bei UNKNOWN-VALUE ist `is not empty` wahr, und `equals`, `is in` und Größenvergleiche sind U. Bei ABSENT und fehlender Angabe sind alle Operatoren U. Die logischen Operatoren folgen der starken Kleene-Dreiwertigkeit; ist ein Prädikat U, ist die Beurteilung des Knotens Review. Diese Auswertung gehört zum festen Kern ([TOULMIN](_index.md#미상-위에서-판정하기)).

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Knotenzahl muss der Zahl der abgeflachten Ausdrucks-Records entsprechen. Die Position nach dem Lesen des letzten Ausdrucks-Records muss genau mit dem Ende des Records übereinstimmen.
- Ein Label-Index, der größer oder gleich der Labelzahl ist, wird abgelehnt.
- Die Kinderzahl von NOT und EXISTS muss 1 sein.
- Eine unbekannte Art (7) oder eine unbekannte Wertart oder Operandenart wird abgelehnt.
- Die Kinderzahl hat 13 Bit (höchstens 8191).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1010`). Beim EXPR-Layout bestimmen vorangehende Rohwerte (Knotenzahl, Labelzahl) die Anzahl der Wiederholungen, sodass es sich nicht mit FIELD deklarieren lässt; die Felddeklaration ist daher ein offenes Problem (Wiederholung in [DECLARE](../edge/0x0BBL-declare.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [TOULMIN](_index.md), [NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md), [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001010/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
