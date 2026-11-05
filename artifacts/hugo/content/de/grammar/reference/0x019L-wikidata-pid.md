---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID ist ein deklarierendes Reference, das eine Wikidata-Eigenschaft (Property) bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `WIKIDATA-PID` (5Q-Gruppe. Namen der einzelnen Codes in der Mitgliedertabelle unten) |
| TAG ID | `0x019L~0x01DL` |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 25~29 |
| Kind | Reference · Klasse: Deklaration |
| Hugo-Seite | `reference/wikidata-pid.md` |

## Mitglieder {#구성원}

Diese Seite behandelt ein vollständiges 5Q-System, also fünf Codes zusammen. Die Quantifizierung ist der Offset im Abschnitt `C % 5` ([Reference](_index.md#quantifier)). Es gibt ein Codec-Dokument pro Code. Die Felder der fünf Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Quantifizierung | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

WIKIDATA-PID ist ein deklarierendes Reference, das eine Wikidata-Eigenschaft (Property) bezeichnet. Der Zahlenteil der P-ID ohne das `P` wird als vorzeichenlose ganze Zahl geschrieben.

## Layout {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[Length-Erweiterungs-TAG]
PID               vorzeichenloses Big-Endian in der kürzesten Breite
```

- Die PID wird in der kürzesten Breite geschrieben. Die derzeitigen Eigenschaftsnummern passen in 1 WORD und ergeben insgesamt 2 WORD; über 65535 wächst es von selbst auf 3 WORD.
- Sie wird vor allem im Predicate von [TRIPLE](../edge/0x0AAL-triple.md) und im Property-Slot von [QUALIFIER](../edge/0x0ABL-qualifier.md) verwendet.

## Beispiel {#예시}

| Eigenschaft | WORD sequence |
|---|---|
| `P31` (ist ein(e)) | `0191 001F` |
| `P279` (Unterklasse von) | `0191 0117` |
| `P569` (Geburtsdatum) | `0191 0239` |

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-QID](0x014L-wikidata-qid.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000190/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

Oben steht das Codec-Dokument von `WIKIDATA-PID-IDENTIFIED` (`0x019L`). Die Codec-Dokumente der anderen Mitglieder (`WIKIDATA-PID-GENERIC`, `WIKIDATA-PID-FREE-CHOICE`, `WIKIDATA-PID-UNIVERSAL`, `WIKIDATA-PID-VARIABLE`) unterscheiden sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im in `#1` gebundenen Namen (BIND).
