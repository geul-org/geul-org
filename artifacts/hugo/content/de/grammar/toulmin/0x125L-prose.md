---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments. Bedeutung: Prosaabsatz.

| Eigenschaft | Wert |
|---|---|
| Name | `PROSE` (BIND `PROSE` des Spezifikationsdokuments) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001250/` (DECLARE-Ziel `1250`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 5 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Prosaabsatz |
| Hugo-Seite | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Ein Prosaabsatz, der keine Regel ist. Er verweist nur auf den Bereich (SPAN) des Originaltexts.

```
ID
SPAN             vom SOURCE bestimmte Breite × 2 (Startbyte, Bytezahl)
```

- ID ist die Edge Id, REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](_index.md#공통-필드)). Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1250`). Da das SOURCE die SPAN-Breite bestimmt, lässt sie sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [SOURCE und Gliederung](_index.md#source와-구획), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001250/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
