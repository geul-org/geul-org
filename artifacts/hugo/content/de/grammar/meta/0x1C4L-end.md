---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Der Record, der das Dokument schließt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `END` (Spezifikationsdokument BIND `END`) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C40/` (DECLARE-Ziel `1C40`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 4 |
| Kind | Meta · Klasse: Struktur |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | 1 WORD. Schließt das Dokument. |
| Hugo-Seite | `meta/structure/end.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Das Spezifikationsdokument enthält kein FIELD. Es deklariert keine Payload-Felder.

Dies ist der Record, der das Dokument schließt.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[Length-Erweiterungs-TAG]
```

- Codec: Meta `0x1C4L`, Strukturklasse
- Payload: keiner (1 WORD)
- Anzahl: eines pro Dokument, ganz am Ende

## Interpretation und Gültigkeit {#해석과-유효성}

- Pflicht. Die Position wird anhand der Länge von [DOC](0x1C0L-doc-1word.md) (`DOC-*`) geprüft.
- Endet die Eingabe ohne END, ist das Dokument abgeschnitten. Ob der Inhalt eines abgeschnittenen Dokuments als gültig gilt, ist Richtlinie des Decoders.
- Danach folgt nichts mehr.

## Beispiel {#예시}

- `0x1C40`

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C40/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
