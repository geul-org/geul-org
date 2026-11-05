---
title: "VERB-SHORT (0x0A8L)"
weight: 168
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB-SHORT ist die Kurzform des Verbaussage-Edge VERB."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB-SHORT ist die Kurzform des Verbaussage-Edge [VERB](0x0A9L-verb.md). `-SHORT` und die Normalform bilden ein gerades/ungerades Paar ([Edge](_index.md#서술-edge)).

| Eintrag | Wert |
|---|---|
| Name | `VERB-SHORT` (BIND des Spezifikationsdokuments `VERB-SHORT`) |
| TAG ID | `0x0A8L` |
| Codec ID | `0x00000A80` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A80/` (DECLARE-Ziel `0A80`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 8 |
| Kind | Edge · Familie: Aussage, Gruppe: Proposition |
| TAG WORD | `0000 1010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Kurzform der Verbaussage |
| Hugo-Seite | `edge/_index.md` |

## Layout {#레이아웃}

Das Layout ist noch nicht festgelegt. Es folgt dem gemeinsamen Edge-Layout (TAG, [Length-Erweiterungs-TAG], Edge Id, Komponenten) ([Edge](_index.md#레이아웃)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0A80`). FIELD folgt, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [VERB](0x0A9L-verb.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A80/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A8000000000
BODY
#1 DECLARE 0x0A80
#2 BIND #1 "VERB-SHORT"
```
