---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments. Bedeutung: Name oder Zeichenkette.

| Eigenschaft | Wert |
|---|---|
| Name | `TEXT` (BIND `TEXT` des Spezifikationsdokuments) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001210/` (DECLARE-Ziel `1210`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 1 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Name oder Zeichenkette |
| Hugo-Seite | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Genau ein Name oder eine Zeichenkette. Die Listen F_WITH und F_GROUNDS von NODE sowie [LABEL](0x134L-label.md) und [IMPORTED-FROM](0x133L-imported-from.md) von LINK verweisen per REF darauf.

```
ID
Zeichenkette     UTF8-TEXT Value Record
```

- ID ist die Edge Id, REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](_index.md#공통-필드)). Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1210`). Die Felddeklaration wird zusammen mit dem Spezifikationsdokument des TOULMIN-Codec festgelegt ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [SOURCE und Gliederung](_index.md#source와-구획), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001210/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
