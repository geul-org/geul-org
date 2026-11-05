---
title: "TIMELINE (0x0B1L)"
weight: 177
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TIMELINE ist ein Aussage-Edge zum Schreiben von Ereignisfolgen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TIMELINE ist ein Aussage-Edge zum Schreiben von Ereignisfolgen. Bedeutung: Struktur zur Darstellung der Reihenfolge von Welt und Ereignissen.

| Eintrag | Wert |
|---|---|
| Name | `TIMELINE` (BIND des Spezifikationsdokuments `TIMELINE`) |
| TAG ID | `0x0B1L` |
| Codec ID | `0x00000B10` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000B10/` (DECLARE-Ziel `0B10`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 17 |
| Kind | Edge · Familie: Aussage, Gruppe: Struktur |
| TAG WORD | `0000 1011 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Struktur zur Darstellung der Reihenfolge von Welt und Ereignissen |
| Hugo-Seite | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0001 LLLL      Codec 0x0B1L
[Length-Erweiterungs-TAG]
Codec-TAG         1 WORD. Unterformat
Edge Id           LOCAL Reference-Record
Komponenten       legt das Unterformat fest
```

- Dies ist ein Codec mit Unterformaten. 1 WORD Codec-spezifischer TAG bestimmt das Unterformat ([Record und TAG WORD](../record.md#레코드-레이아웃)).
- Unterformate und Komponenten sind noch nicht festgelegt.

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0B10`). FIELD folgt, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [WORLD](0x0B0L-world.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (Deklaration von Codecs mit Unterformaten)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000B10/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B1000000000
BODY
#1 DECLARE 0x0B10
#2 BIND #1 "TIMELINE"
```
