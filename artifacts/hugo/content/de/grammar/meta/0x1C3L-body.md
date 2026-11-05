---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Der Record, der den HEAD beendet und den BODY beginnt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `BODY` (Spezifikationsdokument BIND `BODY`) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C30/` (DECLARE-Ziel `1C30`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 3 |
| Kind | Meta · Klasse: Struktur |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | 1 WORD. Beendet den HEAD des Dokuments und beginnt den BODY. |
| Hugo-Seite | `meta/structure/body.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Das Spezifikationsdokument enthält kein FIELD. Es deklariert keine Payload-Felder.

Dies ist der Record, der den HEAD beendet und den BODY beginnt.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[Length-Erweiterungs-TAG]
```

- Codec: Meta `0x1C3L`, Strukturklasse
- Payload: keiner (1 WORD)
- Anzahl: höchstens eines pro Dokument

## Interpretation und Gültigkeit {#해석과-유효성}

- Ist der HEAD leer, entfällt er. Ein Dokument ohne `BODY` besteht ganz aus BODY. Enthält der HEAD Meta oder HEAD-Edges (das [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) für das gesamte Dokument und sein QUALIFIER), steht er.
- Es gibt keinen Payload. Der Record umfasst insgesamt 1 WORD.

## Beispiel {#예시}

- `0x1C30`

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C30/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
