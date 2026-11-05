---
title: "COUNTER-DECLARE (0x104L)"
weight: 260
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "COUNTER-DECLARE ist ein NODE-Codec, der einen Knoten des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COUNTER-DECLARE ist ein NODE-Codec, der einen Knoten des TOULMIN-Graphen schreibt. Bedeutung: Deklaration der Gegenbehauptung. Greift mit einer eigenen Schlussfolgerung an. Das Standard-Level ist Fail.

| Eigenschaft | Wert |
|---|---|
| Name | `COUNTER-DECLARE` (BIND `COUNTER-DECLARE` des Spezifikationsdokuments) |
| TAG ID | `0x104L` |
| Codec ID | `0x00001040` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001040/` (DECLARE-Ziel `1040`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 4 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Deklaration, Layout: NODE |
| TAG WORD | `0001 0000 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Deklaration der Gegenbehauptung. Greift mit einer eigenen Schlussfolgerung an. Das Standard-Level ist Fail |
| Hugo-Seite | `edge/toulmin/node.md` |

## Layout {#레이아웃}

Das Layout ist [NODE](_index.md#node). Ein Header von 1 WORD bestimmt role, level, die Form des Claim und die bedingten Felder.

| Eigenschaft | Wert |
|---|---|
| TANGEUL | counter rule |
| Knoten | Gegenbehauptung (Rebuttal) |

- role muss 1 (counter) sein. Ist level 0 (Unset), gilt der Engine-Standardwert Fail.
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1040`). Die bedingten Felder des NODE-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001040/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000104000000000
BODY
#1 DECLARE 0x1040
#2 BIND #1 "COUNTER-DECLARE"
```
