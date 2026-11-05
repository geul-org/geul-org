---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Knoten → TEXT, Namensschreibweise.

| Eigenschaft | Wert |
|---|---|
| Name | `LABEL` (BIND `LABEL` des Spezifikationsdokuments) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001340/` (DECLARE-Ziel `1340`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 20 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Knoten → TEXT, Namensschreibweise |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | Name in Backticks |
| src → dst | Knoten → TEXT. Namensschreibweise |

- dst ist der REF eines TEXT-Records. Ob ein Name in Backticks als Aussage-[LABEL](../edge/0x0A4L-label.md) bzw. -[BIND](../edge/0x0A3L-bind.md) gesetzt wird, ist ein offenes Problem ([TOULMIN](_index.md#열린-문제)).
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1340`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001340/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
