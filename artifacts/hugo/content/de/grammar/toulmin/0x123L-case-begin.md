---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments. Bedeutung: Beginn des Fallbereichs.

| Eigenschaft | Wert |
|---|---|
| Name | `CASE-BEGIN` (BIND `CASE-BEGIN` des Spezifikationsdokuments) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001230/` (DECLARE-Ziel `1230`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 3 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: ID, REF (Fall) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Beginn des Fallbereichs |
| Hugo-Seite | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Der Beginn eines Fallbereichs.

```
ID
Fall             REF(CASE-DECLARE NODE)
```

- Der Bereich eines Falls ([CASE-DECLARE](0x100L-case-declare.md) NODE) liegt zwischen CASE-BEGIN und [CASE-END](0x124L-case-end.md), die auf ihn verweisen.

- ID ist die Edge Id, REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](_index.md#공통-필드)). Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1230`). Die Felddeklaration wird zusammen mit dem Spezifikationsdokument des TOULMIN-Codec festgelegt ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [SOURCE und Gliederung](_index.md#source와-구획), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001230/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
