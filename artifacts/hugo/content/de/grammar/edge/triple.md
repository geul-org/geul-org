---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE ist ein Beschreibungs-Edge (Codec 0x0A), das eine Proposition (Predicate, Subject, Object) und deren Rang (rank) enthält. Als Object kann anstelle eines Wertes unbekannt (UNKNOWN-VALUE) oder kein Wert (NO-VALUE) stehen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE ist ein Beschreibungs-Edge, das eine Proposition (Predicate, Subject, Object) und deren Rang (rank) enthält. Codec `0x0A`.

Bedingungen, die die Proposition einschränken (Beginn/Ende, Geltungsbereich usw.), hängt man als [QUALIFIER](/de/grammar/edge/qualifier/) an, der auf die Edge Id des TRIPLE verweist. Die Quelle (Wikidata references) hängt man als Beleg-Edge [SOURCE](/de/grammar/edge/source/) an, das auf die Edge Id des TRIPLE verweist.

## Layout

```
TAG WORD          0001 0LLL L000 1010
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Predicate         Reference-Record (WIKIDATA-PID usw.)
Subject           Reference-Record
Object            Reference- oder Value-Record oder Slot-Marker 0x0001 UNKNOWN-VALUE / 0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| Code | Name | Bedeutung |
|---|---|---|
| `0` | normal | Standard |
| `1` | preferred | Aktueller Wert, maßgeblichster Wert |
| `2` | deprecated | Als falsch oder veraltet beurteilter, aber als Aufzeichnung erhaltener Wert |

- Gleich dem statement rank von Wikidata. Der Hauptwert (Wikidata truthy) ist unter denselben Subject und Predicate preferred, falls vorhanden, sonst normal.
- Quellen, die keinen rank vergeben, verwenden `0` (normal).
- Andere Codes sind invalid.

## Interpretation und Gültigkeit

- Predicate und Subject sind jeweils genau ein vollständiger Reference-Record.
- Das Object ist genau ein vollständiger Reference- oder Value-Record oder ein [Slot-Marker](/de/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) / `0x0002` (NO-VALUE) mit 1 WORD. ABSENT (`0x0000`) wird nicht akzeptiert. Das Object ist kein optionales Feld.
- Nach dem Lesen des Object muss genau 1 WORD (Rank) übrig sein.
- Das geul.org-Spezifikationsdokument setzt beim Rohwert-Feld Rank [CODEC](/de/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) und [ENUM](/de/grammar/edge/enum/) 0, 1, 2. Beim Object-Feld setzt es CODEC `0780` (beliebiges Reference), `0F80` (beliebiger Value), `0001` (UNKNOWN-VALUE) und `0002` (NO-VALUE). Predicate und Subject akzeptieren keine Slot-Marker.
- **Die Bedeutung eines TRIPLE ist die Gesamtheit aller QUALIFIER, die im selben Dokument auf seine Edge Id verweisen.** Der Leser sammelt die QUALIFIER, bevor er das TRIPLE interpretiert. Ein ohne QUALIFIER gelesenes TRIPLE kann eine Proposition ohne Einschränkung sein (z. B. „Regierungschef“ ohne zeitliche Einschränkung).

## Unbekannt und kein Wert

Ein Slot-Marker an der Stelle des Object ist keine Wertangabe, sondern eine Behauptung über die Proposition.

| Object | Bedeutung | Logik |
|---|---|---|
| Wert v | Einer der Werte von Predicate des Subject ist v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | Es gibt einen Wert. Welchen, ist unbekannt (Wikidata `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | Es gibt keinen Wert (Wikidata `novalue`) | `¬∃x. P(s, x)` |
| Kein TRIPLE | Behauptet nichts (offene Welt) | |

- **Gelesen wird innerhalb der einschränkenden Bedingungen.** Den Bereich von `∃` und `¬∃` legen die QUALIFIER fest, die auf dieses TRIPLE verweisen. Mit angehängten QUALIFIER ist es nur in diesem Bereich geschlossen. „In den Jahren 1811~1816 gab es keine Zentralbank“ schreibt man als NO-VALUE-TRIPLE mit angehängten QUALIFIER P580 und P582. Es widerspricht Wert-TRIPLEs desselben Predicate aus anderen Zeiträumen nicht.
- **Der rank gilt unverändert.** Bei der Wahl des Hauptwerts (truthy) sind auch TRIPLEs mit UNKNOWN-VALUE und NO-VALUE Kandidaten. Gibt es preferred, bleibt nur preferred übrig.
- **UNKNOWN-VALUE sind untereinander nicht gleich.** UNKNOWN-VALUE ist keinem Wert gleich oder ungleich (Vergleichsergebnis unbestimmt), und zwei UNKNOWN-VALUE gelten untereinander nicht als derselbe Wert. Jedes Auftreten ist eine unabhängige Existenzquantifizierung. Deshalb sind zwei bytegleiche UNKNOWN-VALUE-TRIPLEs kein Duplikat und werden nicht zusammengeführt (es können zwei Kinder sein oder eines).
- Stehen für dasselbe Subject, Predicate und denselben rank ein NO-VALUE und ein Wert-TRIPLE (oder UNKNOWN-VALUE) zusammen, ohne dass sich die einschränkenden Bedingungen unterscheiden, ist das ein Widerspruch. Der Prüfer warnt. Er lehnt nicht ab (dieser Zustand kommt auch in Wikidata vor).
- Ein Wert, der nicht übertragen werden konnte (im Original gibt es einen Wert), wird nicht als UNKNOWN-VALUE geschrieben.

## Beispiel (nicht normativ)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. Das TAG ist `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (USA) P1304 (Zentralbank) NO-VALUE, normal. In den Jahren 1811~1816 gab es keine Zentralbank (die QUALIFIER P580 und P582 stehen im Beispiel bei [QUALIFIER](/de/grammar/edge/qualifier/)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. Das TAG ist `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- „Keine Kinder (P40)“ ist `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Offene Fragen

- scope (Kontext einer Behauptung: Welt, Perspektive): wird festgelegt, sobald es einen Verwendungszweck gibt.
- Eine Kurzform, die TRIPLE und QUALIFIER in einem Record zusammenfasst: erst nach Einführung wiederholter Felder (offene Fragen bei [DECLARE](/de/grammar/edge/declare/)).

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [QUALIFIER](/de/grammar/edge/qualifier/), [SOURCE](/de/grammar/edge/source/), [LABEL](/de/grammar/edge/label/), [ALIAS](/de/grammar/edge/alias/), [Slot-Marker](/de/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/de/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/)
