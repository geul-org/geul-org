---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF ist ein Value, der Daten wie Jahres- und Monatsgenauigkeit, v. Chr., Unsicherheit und Intervalle als erweiterte Datumszeichenkette nach ISO 8601-2 enthält (Codec 0x24/0x25)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF ist ein Value, der ein Datum als Zeichenkette im [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Library of Congress, ISO 8601-2:2019) enthält. Er stellt gröbere Genauigkeit als den Tag, v. Chr., Unsicheres/Ungefähres/teilweise Unbekanntes und Intervalle dar.

## Layout

- Code: direkter Value-Code `0x24` (gerade Bytezahl) und `0x25` (ungerade Bytezahl). Familie TIME. Der Payload ist eine Zeichenkette, liegt aber in der TIME-Familie, damit Decoder und Index ihn auch ohne Kenntnis des Formats als Zeitwert behandeln.
- Die Bytezahl ergibt sich aus dem niederwertigsten Bit des Codec und der Zahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niederwertigstes Bit`, und ein Byte Count steht nicht dabei ([Value](/de/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = ungerade Bytezahl)
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st ... Nth          ASCII-Bytes der EDTF-Zeichenkette / bei ungerader Zahl zuletzt 0x00
```

## Interpretation und Gültigkeit

- Die Bytefolge ist eine ASCII-Zeichenkette nach der Grammatik von EDTF Level 0, 1 und 2. Eine leere Zeichenkette ist invalid.
- Beispiele: Tag `1952-03-11`, Monat `1952-03`, Jahr `1952`, Jahrzehnt `195X`, 44 v. Chr. `-0043`, unsicher `1974?`, ungefähr `~1974`, Intervall `1952/2001`, großes Jahr `Y-13799999999`.
- Jahre folgen der astronomischen Zählung nach ISO 8601. `0000` ist 1 v. Chr., `-0043` ist 44 v. Chr. Bei der Übertragung aus historischer Schreibweise verschiebt man um ein Jahr.
- Es ist der gregorianische Kalender. EDTF behandelt keine anderen Kalender. Die Originalschreibweise anderer Kalender wie des Julianischen bewahrt man mit [GEDCOM-DATE](/de/grammar/value/time/gedcom-date/). Ein Wert, der denselben Tag oder Zeitraum in den gregorianischen Kalender überträgt, kann als EDTF oder GREGORIAN-DATE geschrieben werden.
- **Kanonische Form:** Ein Datum, das sich genau als [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/) schreiben lässt, also `[-]YYYY-MM-DD` ohne Qualifier (`?`, `~`, `%`), unbekannte Stellen (`X`), Intervall und `Y`-Präfix, wird als GREGORIAN-DATE geschrieben. Ein solches Datum als EDTF zu schreiben ist invalid. Nur wenn derselbe Tag in einem einzigen Format steht, lässt er sich als Zeit indizieren und vergleichen.
- Das Schema prüft die EDTF-Grammatik noch nicht. Der Erzeuger prüft mit einem EDTF-Parser. Beispiel: `parser.ParseString` von `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` wird nicht verwendet, da es nur die Grammatik betrachtet und auch `2023-02-29` und `1974-13` durchlässt. Dieser Parser unterstützt Jahre mit `Y`-Präfix noch nicht.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload ([Length](/de/grammar/record/)).

## Beispiel

| Datum | Bytes | Gesamt-WORD |
|---|---|---|
| `1974` | 4 (gerade) | `0924 3139 3734` |
| `197X` | 4 (gerade) | `0924 3139 3758` |
| `1952-03` | 7 (ungerade) | `0A25 3139 3532 2d30 3300` |

## Normgrundlage

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0 ist eine Teilmenge von ISO 8601-1, Level 1 und 2 sind Funktionen von ISO 8601-2.
- In RDF wird dieselbe Zeichenkette mit dem Datentyp `http://id.loc.gov/datatypes/edtf` gekennzeichnet.

## Offene Fragen

- Die Prüfung der EDTF-Grammatik durch den Prüfer (ob sich der Prüfer auf eine externe Bibliothek stützt).
- Die Regel, mit der Jahrhundert- und Jahrtausendgenauigkeit aus Wikidata in unbekannte Stellen von EDTF übertragen wird.

## Verwandte Seiten

- [Value](/de/grammar/value/), [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/de/grammar/value/time/gedcom-date/)
