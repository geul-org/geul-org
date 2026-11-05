---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE ist ein gerichteter Aussage-Edge, der ein Reference mit einem Object-Record verbindet und damit definiert oder bindet, was dieses Reference ist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `REFERENCE-NODE` (BIND des Spezifikationsdokuments `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A00/` (DECLARE-Ziel `0A00`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 0 |
| Kind | Edge · Familie: Aussage, Gruppe: Verweis und Name |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Gerichtete Bindung: Das Subject (ein Reference) verweist auf das Object |
| Hugo-Seite | `edge/reference-node.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `object` | #3 | Record | `000F` gesamter Abschnitt 0 (Wildcard, Reference), `020F` gesamter Abschnitt 1 (Wildcard, Reference), `040F` gesamter Abschnitt 2 (Wildcard, Reference), `060F` gesamter Abschnitt 3 (Wildcard, Value), `080F` gesamter Abschnitt 4 (Wildcard, Value) |  |

REFERENCE-NODE ist ein gerichteter Aussage-Edge, der ein Reference mit einem Object-Record verbindet und damit definiert oder bindet, was dieses Reference ist. Codec `0x0A0L`.

Das Subject verweist auf das Object. Diese Bindung ist nicht [SAME-NODE](0x0A1L-same-node.md), das semantische Identität behauptet, und bedeutet auch nicht, dass die Bytes beider Records gleich sind.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Subject           1 Reference-Record
Object            1 Reference- oder Value-Record
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Subject muss genau ein vollständiger [Reference](../reference/_index.md)-Record sein. Seine Grenze findet man über die eigene Length des Subject; ist es kein Reference oder unvollständig, ist es invalid.
- Das Object muss genau ein vollständiger Reference- oder Value-Record sein. Seine Grenze findet man über die eigene Length des Object; ist es ein Edge oder Meta oder unvollständig, ist es invalid.
- Ist das Object ein Reference, darf die über REFERENCE-NODE-Bindungen verfolgte Reference-Kette nicht zyklisch sein, und LOCAL muss sich letztlich auflösen lassen. Auflösungszyklen und dangling LOCAL sind invalid.
- Wird in einem Dokument eine LOCAL ID an widersprüchliche Object gebunden, ist es invalid. Geltungsbereich, ID, Mindestbreite und Zusammenführungsregeln von LOCAL richten sich nach [LOCAL](../reference/0x005L-local.md).
- Nicht jedes Reference muss durch REFERENCE-NODE gebunden sein.
- Der typische Anwendungsfall ist `LOCAL → UTF8-LANGUAGE-TEXT`. Steht im Object eines [LABEL](0x0A4L-label.md) ein LOCAL, wird der Text über diese Bindung im selben Dokument aufgelöst.

Die Richtung, in der das Subject auf das Object verweist, darf nicht umgekehrt interpretiert werden. Bedeutung und Einzelregeln von SAME und DIFFERENT legt das jeweilige Format gesondert fest.

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` ist die Anzahl der WORD des Length-Erweiterungs-TAG, `N_id` die Anzahl der WORD des Edge-Id-LOCAL-Records, `N_subject` und `N_object` die Gesamtzahl der WORD des jeweiligen Records. Der Cursor nach dem Lesen von Subject und Object muss genau mit dem Ende des Edge übereinstimmen.

## Beispiel (nicht normativ) {#예시-비규범}

Edge Id `0008`, das Subject ist LOCAL 1, das Object ist der [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) von `Donald Trump` (en).

- Die Edge Id ist `0051 0008`, also 2 WORD.
- Das Subject ist `0051 0001`, also 2 WORD.
- Das Object ist Sprache `0761 656E` (BCP47 `en`) + Text mit 12 Byte (gerade), also `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), insgesamt 9 WORD. Der TAG ist `0788`.
- Der Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Der TAG ist `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A00/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
