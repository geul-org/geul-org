---
title: "UNDO (0x113L)"
weight: 275
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "UNDO ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNDO ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Kompensationsaktion (Saga) zu DO. Schlägt ein späterer Schritt fehl, wird sie in umgekehrter Reihenfolge ausgeführt.

| Eigenschaft | Wert |
|---|---|
| Name | `UNDO` (BIND `UNDO` des Spezifikationsdokuments) |
| TAG ID | `0x113L` |
| Codec ID | `0x00001130` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001130/` (DECLARE-Ziel `1130`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 19 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Ausführung, Layout: LINK |
| TAG WORD | `0001 0001 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Kompensationsaktion (Saga) zu DO. Schlägt ein späterer Schritt fehl, wird sie in umgekehrter Reihenfolge ausgeführt |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | `undo fn when n` |
| src → dst | Regel → FuncRef |

- dst ist ein FuncRef. Das `once` von UNDO wird mit F_ONCE in flags geschrieben.
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1130`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001130/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000113000000000
BODY
#1 DECLARE 0x1130
#2 BIND #1 "UNDO"
```
