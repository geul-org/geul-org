---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Deklariert die GEUL-Spezifikationsfassung, der das Dokument folgt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SPEC-VERSION` (Spezifikationsdokument BIND `SPEC-VERSION`) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C50/` (DECLARE-Ziel `1C50`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 5 |
| Kind | Meta · Klasse: Definition |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Die befolgte GEUL-Spezifikationsfassung. Der Payload selbst ist eine unsigned Ganzzahl in der schmalsten Breite. v1 ist `0x0001` (Record `0x1C51 0x0001`) |
| Hugo-Seite | `meta/declaration/spec-version.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | Rest-Rohwert (`0xFFFF`) |  |  |

Deklariert die GEUL-Spezifikationsfassung, der das Dokument folgt. Dieser Wert bestimmt, wie die übrigen Records gelesen werden.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[Length-Erweiterungs-TAG]
Payload           Spezifikationsfassung. v1 = 0x0001
```

- Codec: Meta `0x1C5L`, Definitionsklasse
- Payload: Rohwert (unsigned Ganzzahl in der schmalsten Breite)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Stützt sich nicht auf Value-Codes. Damit der Decoder jeder Fassung ihn lesen kann, steht nur eine Ganzzahl ohne eingebetteten Value.
- Bei einer unbekannten Fassung lehnt der Decoder ab oder gibt eine Warnung aus.
- Fehlt er, wird mit der Fassung gelesen, die der Decoder kennt. Veröffentlichte Dokumente geben ihn an.

## Beispiel {#예시}

- `0x1C51 0x0001`: GEUL v1

## Offene Probleme {#열린-문제}

- Zuordnung zu den Versionen der Codebook-Dokumente ([Spezifikationsdokument](../codec-spec.md)).

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C50/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
