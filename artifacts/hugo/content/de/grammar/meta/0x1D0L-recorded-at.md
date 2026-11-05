---
title: "RECORDED-AT (0x1D0L)"
weight: 464
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Hält den Zeitpunkt fest, zu dem das Dokument aufgezeichnet wurde (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `RECORDED-AT` (Spezifikationsdokument BIND `RECORDED-AT`) |
| TAG ID | `0x1D0L` |
| Codec ID | `0x00001D00` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D00/` (DECLARE-Ziel `1D00`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 16 |
| Kind | Meta · Klasse: Herkunft |
| TAG WORD | `0001 1101 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Aufzeichnungszeitpunkt. TIME-Value (git commit date) |
| Hugo-Seite | `meta/provenance/recorded-at.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | Record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Hält den Zeitpunkt fest, zu dem das Dokument aufgezeichnet wurde (git commit date).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0000 LLLL      Codec 0x1D0L
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS usw.)
```

- Codec: Meta `0x1D0L`, Herkunftsklasse
- Payload: eingebetteter Value (TIME-Familie: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) usw.)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Format wird aus den Values der TIME-Familie gewählt. Ist Präzision nötig, verwendet man ein vom Issuer definiertes Nanosekundenformat (z. B. [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).
- Das Versionslisten-Dokument ([PUBLICATION](../edge/0x0B8L-publication.md)) verwendet diesen Wert als Zeitpunkt der Veröffentlichung, der Verwerfung (deprecate) und der Löschung.

## Offene Probleme {#열린-문제}

- Herkunfts-Meta gehen in den Inhaltshash ein. Ob es zulässig ist, dass derselbe Inhalt, zu einem anderen Zeitpunkt aufgezeichnet, einen anderen Hash ergibt.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D00/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D0000000000
BODY
#1 DECLARE 0x1D00
#2 FIELD #1 record
#3 BIND #1 "RECORDED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
