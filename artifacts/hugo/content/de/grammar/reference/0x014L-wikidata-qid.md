---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID ist ein deklarierendes Reference, das ein Wikidata-Objekt (Item) bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `WIKIDATA-QID` (5Q-Gruppe. Namen der einzelnen Codes in der Mitgliedertabelle unten) |
| TAG ID | `0x014L~0x018L` |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 20~24 |
| Kind | Reference · Klasse: Deklaration |
| Hugo-Seite | `reference/wikidata-qid.md` |

## Mitglieder {#구성원}

Diese Seite behandelt ein vollständiges 5Q-System, also fünf Codes zusammen. Die Quantifizierung ist der Offset im Abschnitt `C % 5` ([Reference](_index.md#quantifier)). Es gibt ein Codec-Dokument pro Code. Die Felder der fünf Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Quantifizierung | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

WIKIDATA-QID ist ein deklarierendes Reference, das ein Wikidata-Objekt (Item) bezeichnet. Der Zahlenteil der Q-ID ohne das `Q` wird als vorzeichenlose ganze Zahl geschrieben.

## Layout {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[Length-Erweiterungs-TAG]
QID               vorzeichenloses Big-Endian in der kürzesten Breite
```

- Die QID wird in der kürzesten Breite geschrieben. `Q1` bis `Q65535` ergeben insgesamt 2 WORD, darüber 3 WORD.
- Die Daten von Wikidata stehen unter CC0.
- Bei Variable ist es eine anonyme Variable der Art, auf die das Item verweist ([Reference](_index.md) Variable).

## Beispiel {#예시}

| Eintrag | WORD sequence |
|---|---|
| `Q5` (Mensch) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (Südkorea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (Präsident), Variable | `0181 76FD` |

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-PID](0x019L-wikidata-pid.md), [TRIPLE](../edge/0x0AAL-triple.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000140/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

Oben steht das Codec-Dokument von `WIKIDATA-QID-IDENTIFIED` (`0x014L`). Die Codec-Dokumente der anderen Mitglieder (`WIKIDATA-QID-GENERIC`, `WIKIDATA-QID-FREE-CHOICE`, `WIKIDATA-QID-UNIVERSAL`, `WIKIDATA-QID-VARIABLE`) unterscheiden sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im in `#1` gebundenen Namen (BIND).
