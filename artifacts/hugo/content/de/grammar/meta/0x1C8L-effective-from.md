---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Deklariert das Inkrafttreten dieser Version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `EFFECTIVE-FROM` (Spezifikationsdokument BIND `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C80/` (DECLARE-Ziel `1C80`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 8 |
| Kind | Meta · Klasse: Definition |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Inkrafttreten dieser Version. GREGORIAN-DATE- oder POSIX-TIMESTAMP-Value. Fehlt es, gilt der Veröffentlichungszeitpunkt |
| Hugo-Seite | `meta/declaration/effective-from.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | Record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Deklariert das Inkrafttreten dieser Version. Das Inkrafttreten unterscheidet sich vom Veröffentlichungszeitpunkt ([Revision](../document.md#개정)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value
```

- Codec: Meta `0x1C8L`, Definitionsklasse
- Payload: eingebetteter Value ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) oder [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Fehlt er, gilt er ab dem Veröffentlichungszeitpunkt.
- Gibt es [EFFECTIVE-UNTIL](0x1C9L-effective-until.md), muss er davor liegen.
- Hat ein Artikel ein abweichendes Inkrafttreten, wird es getrennt am Edge dieses Artikels als QUALIFIER P580 (Beginn)·P582 (Ende) vermerkt ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- Wird das Dokument auf einen bestimmten Zeitpunkt bezogen interpretiert, wird dieser Wert gelesen.

## Beispiel {#예시}

- Inkrafttreten am 02.01.1970: `0x1C83 0x06A2 0x0000 0x0001`

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C80/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
