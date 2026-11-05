---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION ist ein Aussage-Edge, der eine Beschreibung des Subject-Ziels in einer bestimmten Sprache mit dem Object verbindet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DESCRIPTION` (BIND des Spezifikationsdokuments `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A60/` (DECLARE-Ziel `0A60`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 6 |
| Kind | Edge · Familie: Aussage, Gruppe: Verweis und Name |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Verbindet die Sprachbeschreibung (description) des Subject. Das Layout ist dasselbe wie bei LABEL |
| Hugo-Seite | `edge/description.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `object` | #3 | Record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION ist ein Aussage-Edge, der eine Beschreibung des Subject-Ziels in einer bestimmten Sprache mit dem Object verbindet. Codec `0x0A6L`.

Eine Beschreibung ist eine kurze Wendung, die das Ziel unterscheidbar macht (Wikidata description, z. B. „Hauptstadt und größte Stadt Deutschlands“). Sie ist weder eine Definition noch eine Behauptung über das Ziel. Eine Proposition über das Ziel wird als [TRIPLE](0x0AAL-triple.md) geschrieben. Das Layout ist dasselbe wie bei [LABEL](0x0A4L-label.md). Beschreibung und Sprache stehen in einem einzigen Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Ein Rohwert-Feld gibt es nicht.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Subject           1 Reference-Record
Object            1 UTF8-LANGUAGE-TEXT-Value oder LOCAL Reference-Record
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Regeln für Subject und Object sind dieselben wie bei [LABEL](0x0A4L-label.md). Das Subject ist genau ein vollständiger Reference-Record. Das Object ist entweder genau ein vollständiger UTF8-LANGUAGE-TEXT-Record (`0x078L`·`0x079L`) oder ein LOCAL Reference, das über eine [REFERENCE-NODE](0x0A0L-reference-node.md)-Bindung im selben Dokument zu UTF8-LANGUAGE-TEXT aufgelöst wird.
- Ein Text ohne Sprache (UTF8-TEXT) kann keine DESCRIPTION sein. Da es eine Beschreibung je Sprache gibt, greift diese Regel nur mit Sprache. Eine für mehrere Sprachen gemeinsame Beschreibung wird mit der Sprache `mul` geschrieben.
- Zu demselben Subject und derselben Sprache gibt es höchstens eine DESCRIPTION.
- Die Beschreibung dient dazu, das Ziel von anderen Zielen mit demselben Namen zu unterscheiden. Es ist wünschenswert, dass sich das Paar aus LABEL und DESCRIPTION in derselben Sprache nicht bei zwei Zielen überschneidet, doch die Spezifikation prüft das nicht (auch Wikidata empfiehlt es nur und erzwingt es nicht).
- Die Spezifikationsdokumente von geul.org beschränken das Object per [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, wie bei LABEL).

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

- Sprach-Record und Textbytes des Object gehören zum Object-Record. Der Cursor nach dem Lesen des letzten Records muss genau mit dem Ende des Edge übereinstimmen.
- Beschreibungen sind länger als Labels, sodass Object und Edge leicht 15 WORD überschreiten. Dann wird die Length-Erweiterung verwendet ([Record](../record.md)).

## Beispiel (nicht normativ) {#예시-비규범}

Edge Id `0009`, Subject Q64 (`0141 0040`), Object `capital and largest city of Germany` (en). Die Sprache ist ein Beispiel im Format LANGUAGE-BCP47-CODE (für `en` gibt es die Registry-Nummer `0x0784`, sodass auch SHORT-CODE möglich ist).

- Das Object ist Sprache `0761 656E` (BCP47 `en`, 2 WORD) + Text mit 35 Byte (ungerade, 18 WORD), also `0x079L`, TAG 1 + Erweiterungs-TAG 1 + 20 = 22 WORD, `079E 0016 …`.
- Der Edge hat TAG 1 + Erweiterungs-TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, also `LLLL=1110`, TAG `0A6E`, Erweiterungs-TAG `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Entsprechung in Wikidata {#위키데이터-대응}

- Die `descriptions` eines Items (eine je Sprache) → je Sprache eine DESCRIPTION. Der Sprachcode wird mit derselben Sprachcode-Zuordnungstabelle wie bei LABEL übertragen.

## Offene Probleme {#열린-문제}

- Ob es Fälle gibt, in denen eine Beschreibung als UTF8-TEXT ohne Sprache zugelassen werden sollte (derzeit nicht zugelassen).

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A60/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
