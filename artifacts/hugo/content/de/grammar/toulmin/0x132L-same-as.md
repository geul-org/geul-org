---
title: "SAME-AS (0x132L)"
weight: 306
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SAME-AS ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-AS ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Knoten → globaler Bezeichner.

| Eigenschaft | Wert |
|---|---|
| Name | `SAME-AS` (BIND `SAME-AS` des Spezifikationsdokuments) |
| TAG ID | `0x132L` |
| Codec ID | `0x00001320` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001320/` (DECLARE-Ziel `1320`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 18 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: LINK |
| TAG WORD | `0001 0011 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Knoten → globaler Bezeichner |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | — |
| src → dst | Knoten → globaler Bezeichner |

- dst ist der REF eines Knotens.
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1320`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001320/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000132000000000
BODY
#1 DECLARE 0x1320
#2 BIND #1 "SAME-AS"
```
