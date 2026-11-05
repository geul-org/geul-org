---
title: "RUN (0x110L)"
weight: 272
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUN ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUN ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Ausführungskomposition. Ist der Knoten Active, wird der untergeordnete Fall ausgeführt (DAG).

| Eigenschaft | Wert |
|---|---|
| Name | `RUN` (BIND `RUN` des Spezifikationsdokuments) |
| TAG ID | `0x110L` |
| Codec ID | `0x00001100` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001100/` (DECLARE-Ziel `1100`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 16 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Ausführung, Layout: LINK |
| TAG WORD | `0001 0001 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Ausführungskomposition. Ist der Knoten Active, wird der untergeordnete Fall ausgeführt (DAG) |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | `run c when n` |
| src → dst | Regel → Fall |

- dst ist der REF eines Knotens.
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1100`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001100/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000110000000000
BODY
#1 DECLARE 0x1100
#2 BIND #1 "RUN"
```
