---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Hält die Konfidenz des gesamten Dokuments fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `CONFIDENCE` (Spezifikationsdokument BIND `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E80/` (DECLARE-Ziel `1E80`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 8 |
| Kind | Meta · Klasse: Verifikation |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Konfidenz |
| Hugo-Seite | `meta/verification/confidence.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | Record | `0690` UNSIGNED-DECIMAL |  |

Hält die Konfidenz des gesamten Dokuments fest. Die Konfidenz auf Record-Ebene schreibt man als QUALIFIER, der an den Ziel-Edge gehängt wird (die Eigenschaft ist noch offen, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[Length-Erweiterungs-TAG]
Payload           UNSIGNED-DECIMAL-Value, von 0 bis einschließlich 1
```

- Codec: Meta `0x1E8L`, Verifikationsklasse
- Payload: eingebetteter Value ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Wer den Wert vergeben hat, hält man zusätzlich mit [GENERATED-BY](0x1D3L-generated-by.md) usw. fest.

## Offene Probleme {#열린-문제}

- Verhältnis der Skala (0~1) zur TOULMIN-Beurteilung.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E80/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
