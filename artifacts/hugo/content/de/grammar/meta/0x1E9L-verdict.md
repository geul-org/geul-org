---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Hält das Beurteilungsergebnis für das gesamte Dokument fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `VERDICT` (Spezifikationsdokument BIND `VERDICT`) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E90/` (DECLARE-Ziel `1E90`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 9 |
| Kind | Meta · Klasse: Verifikation |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Beurteilungsergebnis für das gesamte Dokument. Pass, Review, Fail. Auf Knoten- und Record-Ebene [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`) |
| Hugo-Seite | `meta/verification/verdict.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | Rohwert 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

Hält das Beurteilungsergebnis für das gesamte Dokument fest. Die Beurteilung auf Knoten- und Record-Ebene übernimmt [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[Length-Erweiterungs-TAG]
Beurteilung       1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x1E9L`, Verifikationsklasse
- Payload: Rohwert (Beurteilung, 1 WORD)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Als Verifikationsklasse fällt es aus dem Inhaltshash heraus.
- Die Beurteilung eines anderen Dokuments steht im BODY eines vom beurteilten Dokument verschiedenen Dokuments.

## Offene Probleme {#열린-문제}

- Ob das beurteilende Subjekt und die Grundlage mitvermerkt werden.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E90/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
