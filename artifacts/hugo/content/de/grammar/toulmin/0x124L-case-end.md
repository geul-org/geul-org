---
title: "CASE-END (0x124L)"
weight: 292
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-END ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-END ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments. Bedeutung: Ende des Fallbereichs.

| Eigenschaft | Wert |
|---|---|
| Name | `CASE-END` (BIND `CASE-END` des Spezifikationsdokuments) |
| TAG ID | `0x124L` |
| Codec ID | `0x00001240` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001240/` (DECLARE-Ziel `1240`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 4 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: ID, REF (Fall) |
| TAG WORD | `0001 0010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Ende des Fallbereichs |
| Hugo-Seite | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Das Ende eines Fallbereichs.

```
ID
Fall             REF(CASE-DECLARE NODE)
```

- Der Bereich eines Falls ([CASE-DECLARE](0x100L-case-declare.md) NODE) liegt zwischen [CASE-BEGIN](0x123L-case-begin.md) und CASE-END, die auf ihn verweisen.

- ID ist die Edge Id, REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](_index.md#공통-필드)). Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1240`). Die Felddeklaration wird zusammen mit dem Spezifikationsdokument des TOULMIN-Codec festgelegt ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [SOURCE und Gliederung](_index.md#source와-구획), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001240/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000124000000000
BODY
#1 DECLARE 0x1240
#2 BIND #1 "CASE-END"
```
