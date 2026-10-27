---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR ist das Bedingungsausdruck-Layout, das PREDICATE-DECLARE (Codec 0x61) verwendet. Der Bedingungsbaum steht in einer eigenen Labeltabelle und in Ausdrucks-Records, die in Präfixreihenfolge ausgebreitet sind."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR ist das Layout, mit dem Bedingungsausdrücke der TANGEUL Rules geschrieben werden. Es wird von Codec `0x61` PREDICATE-DECLARE (Prädikat-Deklaration) verwendet. Der Bedingungsbaum wird in Präfixreihenfolge ausgebreitet abgelegt, und Zeichenketten im Ausdruck werden über eine Labeltabelle im Record angesprochen. Deshalb ist der Record ohne TEXT-Records in sich vollständig.

## Layout

```
ID                     LOCAL-Reference-Record (Edge Id)
Knotenzahl 1 WORD       Gesamtzahl der Ausdrucks-Records
Labelzahl 1 WORD
Label × Labelzahl       UTF8-TEXT-Value-Records
Ausdrucks-Record × Knotenzahl   in Präfixreihenfolge
```

- Labels sind Zeichenketten wie Feldnamen, Zeichenkettenwerte, Pfadschritte und Funktionsnamen. Auch die leere Zeichenkette ist ein Label. Ausdrucks-Records verweisen mit einem ab 0 nummerierten Index (1 WORD) auf Labels.
- Ausdrucks-Records stehen mit den Kindern nacheinander hinter dem Elternknoten (Präfixreihenfolge). Die Kinderzahl jedes Records und diese Reihenfolge legen den Baum eindeutig fest.

## Ausdrucks-Record

Ein Ausdrucks-Record beginnt mit einem 1-WORD-Header.

```
Header 1 WORD      Art untere 2 Bit (b15–14) | Art obere 1 Bit (b13) | Kinderzahl 13 Bit (b12–0)
```

Art = `(b13 << 2) | b15–14`.

| Art | Name | Kinderzahl | Nach dem Header |
|---|---|---|---|
| 0 | COMPARE | 0 | Vergleichsoperator 1 WORD, Feldlabel 1 WORD, Wertstelle |
| 1 | LOGIC | n | Logikoperator 1 WORD |
| 2 | NOT | 1 | keines |
| 3 | EITHER | n | keines |
| 4 | EXISTS | 1 | Quantifizierungsoperator 1 WORD, Ziel-Operand, Label des bindenden Namens 1 WORD |
| 5 | CALL | 0 | Alias-Label 1 WORD, Funktionsnamen-Label 1 WORD |
| 6 | COMPARE-X | 0 | Vergleichsoperator 1 WORD, Feldlabel 1 WORD, linker Marker 1 WORD [+ Operand], Wertstelle |
| 7 | reserviert | | |

- Kind-Records folgen auf die Felder nach dem Header. Das Kind von EXISTS ist eine einzige Bedingung.
- COMPARE ist ein Vergleich `<Feld> <Operator> <Wert>` ohne Operanden auf beiden Seiten. Gibt es auf einer Seite einen Operanden, verwendet man COMPARE-X.
- Ist der linke Marker von COMPARE-X `1`, folgt ein Operand, bei `0` keiner. Gibt es einen linken Operanden, ist das Feldlabel die leere Zeichenkette.
- CALL ist ein Aufruf einer Host-Funktion an der Stelle eines Prädikats. Ist es eine Funktion dieses Dokuments, ist das Alias-Label die leere Zeichenkette.

### Wertstelle

```
Wertart 1 WORD    0 Zahl, 1 Zeichenkette, 2 Operand
Wert              0: UNSIGNED-INTEGER-Value-Record
                  1: Label 1 WORD
                  2: Operand (nur bei COMPARE-X)
```

- Entspricht die Wert-Zeichenkette genau der kanonischen Dezimalschreibweise einer nicht negativen Ganzzahl, wird sie als UNSIGNED-INTEGER-Value geschrieben. Andere Werte werden als Label geschrieben. So lässt sich die Wert-Zeichenkette unverändert wiederherstellen.

### Operand

```
Operandenart 1 WORD   0 Pfad, 1 Kriterienreferenz, 2 Funktionsaufruf
Pfad, Kriterienreferenz   Schrittzahl 1 WORD + Label 1 WORD × Schrittzahl
Funktionsaufruf       Alias-Label 1 WORD + Funktionsnamen-Label 1 WORD
```

- Ein Pfad ist ein Pfad der Eingabedaten, eine Kriterienreferenz der Pfad eines per `with` eingespeisten Beurteilungskriteriums (SPEC).

### Operatorcodes

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

| Code | Logikoperator |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Code | Quantifizierungsoperator |
|---|---|
| `0x0321` | any |

### Auswertung bei unbekannter Eingabe

Ist die Eingabe ein Slot-Marker, werden Vergleichsoperatoren dreiwertig (wahr, falsch, unbestimmt U) ausgewertet. Bei NO-VALUE ist `is empty` wahr und jeder andere Vergleich falsch. Bei UNKNOWN-VALUE ist `is not empty` wahr, und `equals`, `is in` und Größenvergleiche ergeben U. Bei ABSENT und fehlender Aussage ergeben alle Operatoren U. Die Logikoperatoren folgen der starken 3-Werte-Logik nach Kleene, und ist das Prädikat U, ist das Urteil des Knotens Review. Diese Auswertung ist der feste Kern ([TOULMIN](/de/grammar/edge/toulmin/#urteilen-auf-unbekannter-grundlage)).

## Interpretation und Gültigkeit

- Die Knotenzahl muss der Zahl der ausgebreiteten Ausdrucks-Records entsprechen. Die Position nach dem Lesen des letzten Ausdrucks-Records muss genau mit dem Ende des Records übereinstimmen.
- Ist ein Label-Index nicht kleiner als die Labelzahl, wird abgelehnt.
- Die Kinderzahl von NOT und EXISTS muss 1 sein.
- Eine unbekannte Art (7) oder eine unbekannte Wertart oder Operandenart wird abgelehnt.
- Die Kinderzahl umfasst 13 Bit (höchstens 8191).

## Verwandte Seiten

- [TOULMIN](/de/grammar/edge/toulmin/), [NODE](/de/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/de/grammar/value/text/utf8-text/), [UNSIGNED-INTEGER](/de/grammar/value/numeric/unsigned-integer/)
