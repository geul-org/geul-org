---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Verknüpfung, die ohne Nebenwirkungen nur beurteilt.

| Eigenschaft | Wert |
|---|---|
| Name | `CHECKING` (BIND `CHECKING` des Spezifikationsdokuments) |
| TAG ID | `0x114L` |
| Codec ID | `0x00001140` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001140/` (DECLARE-Ziel `1140`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 20 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Ausführung, Layout: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Verknüpfung, die ohne Nebenwirkungen nur beurteilt |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | `checking c` |
| src → dst | Regel → Fall. Beurteilung ohne Nebenwirkungen |

- dst ist der REF eines Knotens.
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1140`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001140/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
