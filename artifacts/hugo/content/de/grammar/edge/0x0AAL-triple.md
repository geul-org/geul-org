---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE ist ein Aussage-Edge, der eine Proposition (Predicate, Subject, Object) und ihren Rang (rank) enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `TRIPLE` (BIND des Spezifikationsdokuments `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000AA0/` (DECLARE-Ziel `0AA0`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 10 |
| Kind | Edge · Familie: Aussage, Gruppe: Proposition |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Proposition in der Reihenfolge Predicate, Subject, Object und rank. Das Object ist ein Wert oder ein UNKNOWN-VALUE-/NO-VALUE-Marker. Die Bedeutung ist die Gesamtheit aller QUALIFIER, die auf seine Edge Id verweisen |
| Hugo-Seite | `edge/triple.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | Record | `000F` gesamter Abschnitt 0 (Wildcard, Reference), `020F` gesamter Abschnitt 1 (Wildcard, Reference), `040F` gesamter Abschnitt 2 (Wildcard, Reference) |  |
| 2 | `subject` | #3 | Record | `000F` gesamter Abschnitt 0 (Wildcard, Reference), `020F` gesamter Abschnitt 1 (Wildcard, Reference), `040F` gesamter Abschnitt 2 (Wildcard, Reference) |  |
| 3 | `object` | #4 | Record | `000F` gesamter Abschnitt 0 (Wildcard, Reference), `020F` gesamter Abschnitt 1 (Wildcard, Reference), `040F` gesamter Abschnitt 2 (Wildcard, Reference), `060F` gesamter Abschnitt 3 (Wildcard, Value), `080F` gesamter Abschnitt 4 (Wildcard, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |
| 4 | `rank` | #5 | Rohwert 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE ist ein Aussage-Edge, der eine Proposition (Predicate, Subject, Object) und ihren Rang (rank) enthält. Codec `0x0AAL`.

Bedingungen, die die Proposition einschränken (Beginn- und Endzeitpunkt, Geltungsbereich usw.), werden durch einen [QUALIFIER](0x0ABL-qualifier.md) angefügt, der auf die Edge Id des TRIPLE verweist. Die Quelle (Wikidata references) wird durch den Beleg-Edge [SOURCE](0x0C0L-source.md) angefügt, der auf die Edge Id des TRIPLE verweist.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Predicate         Reference-Record (WIKIDATA-PID usw.)
Subject           Reference-Record
Object            Reference- oder Value-Record, oder Slot-Marker 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| Code | Name | Bedeutung |
|---|---|---|
| `0` | normal | Standard |
| `1` | preferred | Aktueller Wert, maßgeblichster Wert |
| `2` | deprecated | Als falsch oder veraltet beurteilter Wert, der als Aufzeichnung erhalten bleibt |

- Entspricht dem Statement-Rank von Wikidata. Der repräsentative Wert (Wikidata truthy) ist unter denselben Subject und Predicate der preferred-Wert, falls vorhanden, sonst der normal-Wert.
- Quellen ohne eigene Rank-Vergabe verwenden `0` (normal).
- Alle anderen Codes sind invalid.

## Interpretation und Gültigkeit {#해석과-유효성}

- Predicate und Subject sind jeweils genau ein vollständiger Reference-Record.
- Das Object ist genau ein vollständiger Reference- oder Value-Record oder ein [Slot-Marker](../slot-marker.md) `0x0010` (UNKNOWN-VALUE)·`0x0020` (NO-VALUE) mit 1 WORD. ABSENT (`0x0000`) wird nicht akzeptiert. Das Object ist kein optionales Feld.
- Nach dem Lesen des Object muss genau 1 WORD (Rank) übrig bleiben.
- Die Spezifikationsdokumente von geul.org setzen beim Rohwert-Feld Rank den [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) und das [ENUM](0x0BDL-enum.md) 0·1·2. Beim Object-Feld stehen die CODEC `000F`·`020F`·`040F` (beliebiges Reference), `060F`·`080F` (beliebiger Value), `0010` (UNKNOWN-VALUE) und `0020` (NO-VALUE). Bei den Feldern Predicate und Subject stehen die CODEC `000F`·`020F`·`040F` (beliebiges Reference). Da es Wildcards sind, werden Slot-Marker nicht akzeptiert.
- **Die Bedeutung eines TRIPLE ist die Gesamtheit aller QUALIFIER, die im selben Dokument auf seine Edge Id verweisen.** Der Leser sammelt die QUALIFIER, bevor er das TRIPLE interpretiert. Ein ohne QUALIFIER gelesenes TRIPLE kann eine Proposition ohne Einschränkung sein (z. B. „Regierungschef“ ohne zeitliche Einschränkung).

## Unbekannt und nicht vorhanden {#알-수-없음과-없음}

Der Slot-Marker an der Object-Position ist kein Wert, sondern eine Behauptung über die Proposition.

| Object | Bedeutung | Logik |
|---|---|---|
| Wert v | Einer der Predicate-Werte des Subject ist v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | Es gibt einen Wert. Welcher, ist unbekannt (Wikidata `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | Es gibt keinen Wert (Wikidata `novalue`) | `¬∃x. P(s, x)` |
| Kein TRIPLE | Nichts wird behauptet (offene Welt) | |

- **Es wird innerhalb der einschränkenden Bedingungen gelesen.** Den Bereich von `∃` und `¬∃` legen die QUALIFIER fest, die auf dieses TRIPLE verweisen. Sind QUALIFIER angefügt, gilt es nur in diesem Bereich als abgeschlossen. „Von 1811 bis 1816 gab es keine Zentralbank“ wird als NO-VALUE-TRIPLE mit angefügten QUALIFIER P580 und P582 geschrieben. Es widerspricht nicht den Wert-TRIPLE desselben Predicate aus anderen Zeiträumen.
- **Rank gilt unverändert.** Bei der Wahl des repräsentativen Werts (truthy) kommen auch UNKNOWN-VALUE- und NO-VALUE-TRIPLE als Kandidaten in Frage. Gibt es preferred, bleibt nur preferred.
- **UNKNOWN-VALUE sind untereinander nicht gleich.** UNKNOWN-VALUE ist mit keinem Wert gleich oder verschieden (Vergleichsergebnis unbestimmt), und auch zwei UNKNOWN-VALUE gelten nicht als derselbe Wert. Jedes Vorkommen ist eine unabhängige Existenzquantifizierung. Daher sind zwei bytegleiche UNKNOWN-VALUE-TRIPLE keine Duplikate und werden nicht zusammengeführt (es können zwei Kinder oder nur eines sein).
- Stehen für dasselbe Subject, Predicate und denselben Rank ein NO-VALUE-TRIPLE und ein Wert-TRIPLE (oder UNKNOWN-VALUE-TRIPLE) zusammen, ohne dass sich die einschränkenden Bedingungen unterscheiden, ist das ein Widerspruch. Der Prüfer warnt. Er lehnt nicht ab (auch in Wikidata gibt es diesen Zustand).
- Ein nicht übertragbarer Wert (die Quelle hat einen Wert) wird nicht als UNKNOWN-VALUE geschrieben.

## Beispiel (nicht normativ) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. Der TAG ist `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (Vereinigte Staaten) P1304 (Zentralbank) NO-VALUE, normal. Von 1811 bis 1816 gab es keine Zentralbank (die QUALIFIER P580·P582 siehe Beispiel bei [QUALIFIER](0x0ABL-qualifier.md)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. Der TAG ist `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- „Keine Kinder (P40)“ ist `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Offene Probleme {#열린-문제}

- Scope (Kontext der Behauptung: Welt, Perspektive): wird festgelegt, wenn ein Verwendungszweck entsteht.
- Kurzform, die TRIPLE und QUALIFIER in einem Record zusammenfasst: erst nach der Deklaration wiederholter Felder (offenes Problem bei [DECLARE](0x0BBL-declare.md)).

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [Slot-Marker](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000AA0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
