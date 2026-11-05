---
title: "MEANS (0x12CL)"
weight: 300
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "MEANS ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MEANS ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Definitionseintrag → Wert/Typ.

| Eigenschaft | Wert |
|---|---|
| Name | `MEANS` (BIND `MEANS` des Spezifikationsdokuments) |
| TAG ID | `0x12CL` |
| Codec ID | `0x000012C0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000012C0/` (DECLARE-Ziel `12C0`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 12 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: LINK |
| TAG WORD | `0001 0010 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Definitionseintrag → Wert/Typ |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | Definitions `means` |
| src → dst | Definitionseintrag → Wert/Typ |

- dst ist der REF eines Knotens.
- F_FORCE wird nicht verwendet (ist es gesetzt, wird abgelehnt).
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `12C0`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000012C0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012C000000000
BODY
#1 DECLARE 0x12C0
#2 BIND #1 "MEANS"
```
