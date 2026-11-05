---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS ist ein Aussage-Edge, der einen anderen Namen (Alias) des Subject-Ziels mit dem Object verbindet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `ALIAS` (BIND des Spezifikationsdokuments `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A50/` (DECLARE-Ziel `0A50`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 5 |
| Kind | Edge · Familie: Aussage, Gruppe: Verweis und Name |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Verbindet einen anderen Namen (Alias) des Subject. Das Layout ist dasselbe wie bei LABEL |
| Hugo-Seite | `edge/alias.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `object` | #3 | Record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS ist ein Aussage-Edge, der einen anderen Namen (Alias) des Subject-Ziels mit dem Object verbindet. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) ist der Hauptname in der jeweiligen Sprache (höchstens einer je Sprache), ALIAS ist ein anderer Name desselben Ziels (mehrere je Sprache, Wikidata „also known as“). Er dient vor allem der Suche. Layout und Gültigkeit sind dieselben wie bei LABEL.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Subject           1 Reference-Record
Object            1 UTF8-LANGUAGE-TEXT-Value oder LOCAL Reference-Record
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Regeln für Subject und Object sind dieselben wie bei [LABEL](0x0A4L-label.md) (das Object ist [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) oder ein LOCAL, das dazu aufgelöst wird).
- Zu demselben Subject und derselben Sprache können mehrere ALIAS stehen. Die Reihenfolge ist die Reihenfolge im Dokument.
- Derselbe Text wie beim LABEL desselben Subject und derselben Sprache wird nicht als ALIAS angelegt (der Hauptname genügt als ein LABEL). Diese Regel ist eine Empfehlung.
- Die Spezifikationsdokumente von geul.org beschränken das Object per [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, wie bei LABEL).

## Beispiel (nicht normativ) {#예시-비규범}

Edge Id `0003`, Subject Q42 (`0141 002A`), Object `DNA` (en): Sprache `0761 656E` (BCP47 `en`) + Text mit 3 Byte (ungerade) → `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. Der TAG ist `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A50/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
