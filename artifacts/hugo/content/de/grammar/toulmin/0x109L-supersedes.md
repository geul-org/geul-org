---
title: "SUPERSEDES (0x109L)"
weight: 265
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDES ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDES ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Ausschlussrelation. Ist der Angreifer Active, nimmt er das Ziel deterministisch aus der Aggregation. Eine Kette (`A > B > C`) wird paarweise geschrieben, je Paar ein SUPERSEDES.

| Eigenschaft | Wert |
|---|---|
| Name | `SUPERSEDES` (BIND `SUPERSEDES` des Spezifikationsdokuments) |
| TAG ID | `0x109L` |
| Codec ID | `0x00001090` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001090/` (DECLARE-Ziel `1090`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 9 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Relation, Layout: LINK |
| TAG WORD | `0001 0000 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Ausschlussrelation. Ist der Angreifer Active, nimmt er das Ziel deterministisch aus der Aggregation. Eine Kette (`A > B > C`) wird je Paar mit einem SUPERSEDES geschrieben |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | `X supersedes Y` |
| src → dst | Regel → Regel. Ist er Active, nimmt er das Ziel aus der Aggregation |

- Eine SUPERSEDES-Kette `A > B > C` wird paarweise mit je einem SUPERSEDES geschrieben. Für die Kurzform [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) gibt es noch kein Layout.
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1090`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001090/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000109000000000
BODY
#1 DECLARE 0x1090
#2 BIND #1 "SUPERSEDES"
```
