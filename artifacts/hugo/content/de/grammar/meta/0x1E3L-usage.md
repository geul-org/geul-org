---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Hält Nutzungsbeschränkungen fest (z. B. Trainingsverbot, Verbot kommerzieller Nutzung)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `USAGE` (Spezifikationsdokument BIND `USAGE`) |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E30/` (DECLARE-Ziel `1E30`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 3 |
| Kind | Meta · Klasse: Richtlinie |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Nutzungsbeschränkung |
| Hugo-Seite | `meta/policy/usage.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Hält Nutzungsbeschränkungen fest (z. B. Trainingsverbot, Verbot kommerzieller Nutzung).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[Length-Erweiterungs-TAG]
Payload           Text oder Reference, die eine Nutzungsbeschränkung ausdrückt
```

- Codec: Meta `0x1E3L`, Richtlinienklasse
- Payload: eingebetteter Value oder Reference
- Anzahl: mehrere möglich

## Offene Probleme {#열린-문제}

- Code-Tabelle der Beschränkungsarten.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E30/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
