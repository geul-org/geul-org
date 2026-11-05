---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD ist ein Aussage-Edge zum Schreiben von Weltsichten."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD ist ein Aussage-Edge zum Schreiben von Weltsichten. Bedeutung: Struktur zur Darstellung von Weltsichten.

| Eintrag | Wert |
|---|---|
| Name | `WORLD` (BIND des Spezifikationsdokuments `WORLD`) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000B00/` (DECLARE-Ziel `0B00`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 16 |
| Kind | Edge · Familie: Aussage, Gruppe: Struktur |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Struktur zur Darstellung von Weltsichten |
| Hugo-Seite | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[Length-Erweiterungs-TAG]
Codec-TAG         1 WORD. Unterformat
Edge Id           LOCAL Reference-Record
Komponenten       legt das Unterformat fest
```

- Dies ist ein Codec mit Unterformaten. 1 WORD Codec-spezifischer TAG bestimmt das Unterformat ([Record und TAG WORD](../record.md#레코드-레이아웃)).
- Unterformate und Komponenten sind noch nicht festgelegt.

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0B00`). FIELD folgt, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (Deklaration von Codecs mit Unterformaten)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000B00/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
