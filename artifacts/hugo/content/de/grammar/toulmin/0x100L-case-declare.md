---
title: "CASE-DECLARE (0x100L)"
weight: 256
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-DECLARE ist ein NODE-Codec, der einen Knoten des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-DECLARE ist ein NODE-Codec, der einen Knoten des TOULMIN-Graphen schreibt. Bedeutung: Falldeklaration. Ein Beurteilungsgraph, der Knoten und Relationen enthält.

| Eigenschaft | Wert |
|---|---|
| Name | `CASE-DECLARE` (BIND `CASE-DECLARE` des Spezifikationsdokuments) |
| TAG ID | `0x100L` |
| Codec ID | `0x00001000` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001000/` (DECLARE-Ziel `1000`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 0 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Deklaration, Layout: NODE |
| TAG WORD | `0001 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Falldeklaration. Ein Beurteilungsgraph, der Knoten und Relationen enthält |
| Hugo-Seite | `edge/toulmin/node.md` |

## Layout {#레이아웃}

Das Layout ist [NODE](_index.md#node). Ein Header von 1 WORD bestimmt role, level, die Form des Claim und die bedingten Felder.

| Eigenschaft | Wert |
|---|---|
| TANGEUL | in case of |
| Knoten | Fall |

- role muss 0 sein.
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1000`). Die bedingten Felder des NODE-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001000/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000100000000000
BODY
#1 DECLARE 0x1000
#2 BIND #1 "CASE-DECLARE"
```
