---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL ist ein deklarierendes Reference, das eine von geul.org unter CC0 vergebene Entität bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `GEUL` (5Q-Gruppe. Namen der einzelnen Codes in der Mitgliedertabelle unten) |
| TAG ID | `0x00AL~0x00EL` |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 10~14 |
| Kind | Reference · Klasse: Deklaration |
| Hugo-Seite | `reference/geul.md` |

## Mitglieder {#구성원}

Diese Seite behandelt ein vollständiges 5Q-System, also fünf Codes zusammen. Die Quantifizierung ist der Offset im Abschnitt `C % 5` ([Reference](_index.md#quantifier)). Es gibt ein Codec-Dokument pro Code. Die Felder der fünf Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Quantifizierung | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

GEUL ist ein deklarierendes Reference, das eine von geul.org unter CC0 vergebene Entität bezeichnet. Es ist eine fortlaufende ID, deren Nummer keine Bedeutung trägt. Kennungen, deren Bits Bedeutung tragen, übernimmt der eigene Codec [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[Length-Erweiterungs-TAG]
GEUL ID           vorzeichenloses Big-Endian in der kürzesten Breite
```

- Kleine Nummern werden häufig verwendeten Entitäten zugewiesen. Eine ID, die in 1 WORD passt, ergibt insgesamt 2 WORD.
- Die Vergabe der IDs und das Register verwaltet geul.org. In das Register kommt nur, was aus CC0-Quellen stammt.
- Bei Variable ist es eine anonyme Variable dieser Art ([Reference](_index.md) Variable).

## Beispiel {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## Offene Probleme {#열린-문제}

- Vergaberegeln für GEUL ID und Veröffentlichungsformat des Registers.

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000000A0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

Oben steht das Codec-Dokument von `GEUL-IDENTIFIED` (`0x00AL`). Die Codec-Dokumente der anderen Mitglieder (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`) unterscheiden sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im in `#1` gebundenen Namen (BIND).
