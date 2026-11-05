---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Deklariert das Ende der Gültigkeit dieser Version (befristetes Gesetz)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `EFFECTIVE-UNTIL` (Spezifikationsdokument BIND `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C90/` (DECLARE-Ziel `1C90`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 9 |
| Kind | Meta · Klasse: Definition |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Ende der Gültigkeit dieser Version (befristetes Gesetz). Fehlt es, bis zum Inkrafttreten der nächsten Version |
| Hugo-Seite | `meta/declaration/effective-until.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | Record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Deklariert das Ende der Gültigkeit dieser Version (befristetes Gesetz). Ab diesem Zeitpunkt ist diese Version nicht mehr in Kraft.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value
```

- Codec: Meta `0x1C9L`, Definitionsklasse
- Payload: eingebetteter Value ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) oder [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Fehlt er, gilt diese Version bis zum Inkrafttreten der nächsten Version.
- Nach Ablauf der Gültigkeit ist keine Fassung in Kraft. Frühere Fassungen leben nicht wieder auf.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C90/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
