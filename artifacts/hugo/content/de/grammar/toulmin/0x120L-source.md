---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments. Bedeutung: Originaltext des Autors.

| Eigenschaft | Wert |
|---|---|
| Name | `SOURCE` (BIND `SOURCE` des Spezifikationsdokuments) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001200/` (DECLARE-Ziel `1200`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 0 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: ID, SPAN-Breite-WORD, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Originaltext des Autors |
| Hugo-Seite | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Der gesamte Originaltext des Autors. Jeder SPAN ist ein Bytebereich in diesem Originaltext.

```
ID
SPAN-Breite-WORD   obere 2 Bit = Breite (00=1, 01=2, 10=4, 11=8 WORD), restliche 14 Bit = 0
Originaltext       UTF8-TEXT Value Record
```

- SOURCE ist der erste Record des BODY. Es gibt genau einen pro Dokument.
- Ein SPAN besteht aus zwei Feldern, Startbyte und Bytezahl. Jedes Feld ist eine unsigned-Ganzzahl mit der vom SPAN-Breite-WORD bestimmten Breite (1/2/4/8 WORD).
- Ein anderer Codec als der Beleg-Edge [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).

- ID ist die Edge Id, REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](_index.md#공통-필드)). Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1200`). Die Felddeklaration wird zusammen mit dem Spezifikationsdokument des TOULMIN-Codec festgelegt ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [SOURCE und Gliederung](_index.md#source와-구획), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001200/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
