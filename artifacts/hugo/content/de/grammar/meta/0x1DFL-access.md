---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Hält den Zugriffsbereich des Dokuments fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `ACCESS` (Spezifikationsdokument BIND `ACCESS`) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001DF0/` (DECLARE-Ziel `1DF0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 31 |
| Kind | Meta · Klasse: Richtlinie |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Zugriffsbereich |
| Hugo-Seite | `meta/policy/access.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | Rohwert 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

Hält den Zugriffsbereich des Dokuments fest.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[Length-Erweiterungs-TAG]
Stufe             1 WORD (0 öffentlich, 1 intern, 2 vertraulich, sonst Reserved)
```

- Codec: Meta `0x1DFL`, Richtlinienklasse
- Payload: Rohwert (Stufe, 1 WORD)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Vertrauliche Dokumente werden nicht veröffentlicht ([Issuer](../issuer.md)).
- Ändert die Interpretation nicht. Bestimmt nur die Behandlung.

## Offene Probleme {#열린-문제}

- Code-Tabelle der Stufen.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001DF0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
