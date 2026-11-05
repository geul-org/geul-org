---
title: "UNTIL (0x131L)"
weight: 305
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "UNTIL ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNTIL ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Trigger → Fall (`every … until`).

| Eigenschaft | Wert |
|---|---|
| Name | `UNTIL` (BIND `UNTIL` des Spezifikationsdokuments) |
| TAG ID | `0x131L` |
| Codec ID | `0x00001310` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001310/` (DECLARE-Ziel `1310`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 17 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: LINK |
| TAG WORD | `0001 0011 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Trigger → Fall (`every … until`) |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | `every … until c` |
| src → dst | Trigger → Fall |

- dst ist der REF eines Knotens.
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1310`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001310/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000131000000000
BODY
#1 DECLARE 0x1310
#2 BIND #1 "UNTIL"
```
