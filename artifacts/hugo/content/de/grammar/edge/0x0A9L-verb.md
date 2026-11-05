---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB ist ein Verbaussage-Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB ist ein Verbaussage-Edge. Die Kurzform ist [VERB-SHORT](0x0A8L-verb-short.md) (`0x0A8L`) ([Edge](_index.md#서술-edge)).

| Eintrag | Wert |
|---|---|
| Name | `VERB` (BIND des Spezifikationsdokuments `VERB`) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A90/` (DECLARE-Ziel `0A90`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 9 |
| Kind | Edge · Familie: Aussage, Gruppe: Proposition |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Verbaussage |
| Hugo-Seite | `edge/_index.md` |

## Layout {#레이아웃}

Das Layout ist noch nicht festgelegt. Es folgt dem gemeinsamen Edge-Layout (TAG, [Length-Erweiterungs-TAG], Edge Id, Komponenten) ([Edge](_index.md#레이아웃)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0A90`). FIELD folgt, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A90/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
