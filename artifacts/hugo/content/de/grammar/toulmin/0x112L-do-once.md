---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Aktion, die auch bei Wiederholungsversuchen nur einmal ausgeführt wird.

| Eigenschaft | Wert |
|---|---|
| Name | `DO-ONCE` (BIND `DO-ONCE` des Spezifikationsdokuments) |
| TAG ID | `0x112L` |
| Codec ID | `0x00001120` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001120/` (DECLARE-Ziel `1120`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 18 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Ausführung, Layout: LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Aktion, die auch bei Wiederholungsversuchen nur einmal ausgeführt wird |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | Regel → FuncRef |

- dst ist ein FuncRef. `do … once` wird von diesem Codec ausgedrückt. In flags wird F_ONCE nicht verwendet (ist es gesetzt, wird abgelehnt).
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1120`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001120/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
