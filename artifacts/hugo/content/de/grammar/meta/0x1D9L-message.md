---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält den Grund der Änderung fest (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `MESSAGE` (Spezifikationsdokument BIND `MESSAGE`) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D90/` (DECLARE-Ziel `1D90`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 25 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Grund der Änderung. UTF8-LANGUAGE-TEXT-Value, einer pro Sprache (git commit message) |
| Hugo-Seite | `meta/lineage/message.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | Record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Hält den Grund der Änderung fest (git commit message).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[Length-Erweiterungs-TAG]
Nachricht         1 UTF8-LANGUAGE-TEXT-Value
```

- Codec: Meta `0x1D9L`, Abstammungsklasse
- Payload: eingebetteter Value ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- Anzahl: höchstens eines pro Sprache

## Interpretation und Gültigkeit {#해석과-유효성}

- Nachricht und Sprache stehen zusammen in einem UTF8-LANGUAGE-TEXT. Pro Sprache gibt es nur ein MESSAGE.
- Das Spezifikationsdokument von geul.org wird mit [CODEC](../edge/0x0BEL-codec.md) `0780`·`0790` geschrieben.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D90/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
