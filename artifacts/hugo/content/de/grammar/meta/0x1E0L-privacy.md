---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Hält die Datenschutzstufe des Dokuments fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `PRIVACY` (Spezifikationsdokument BIND `PRIVACY`) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E00/` (DECLARE-Ziel `1E00`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 0 |
| Kind | Meta · Klasse: Richtlinie |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Datenschutzstufe |
| Hugo-Seite | `meta/policy/privacy.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | Rohwert 1 WORD |  |  |

Hält die Datenschutzstufe des Dokuments fest.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[Length-Erweiterungs-TAG]
Stufe             1 WORD
```

- Codec: Meta `0x1E0L`, Richtlinienklasse
- Payload: Rohwert (Stufe, 1 WORD)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Ändert die Interpretation nicht. Bestimmt nur die Behandlung.

## Offene Probleme {#열린-문제}

- Code-Tabelle der Stufen (Zuordnung zur Klassifikation des koreanischen Datenschutzgesetzes).

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E00/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
