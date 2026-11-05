---
title: "FOREACH (0x0F5L)"
weight: 245
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FOREACH ist der Codec der Gruppe Anweisung unter den Ausführungs-Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FOREACH ist der Codec der Gruppe Anweisung unter den Ausführungs-Edge. Bedeutung: Iterationsschleife.

| Eintrag | Wert |
|---|---|
| Name | `FOREACH` (Spezifikationsdokument BIND `FOREACH`) |
| TAG ID | `0x0F5L` |
| Codec ID | `0x00000F50` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000F50/` (DECLARE-Ziel `0F50`) |
| Abschnitt | 7 `0111` (Edge-Ausführung), Offset im Abschnitt C = 21 |
| Kind | Edge · Familie: Ausführung, Gruppe: Anweisung |
| TAG WORD | `0000 1111 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Iterationsschleife. Elementsymbol, Ziel, Rumpf-BLOCK |
| Hugo-Seite | `edge/_index.md` |

## Komponenten {#구성요소}

Elementsymbol, Ziel, Rumpf-BLOCK.

- Komponenten werden über die LOCAL ID (REF) dieses Dokuments referenziert. REF `0` bedeutet nicht vorhanden. An Ausdrucksstellen steht ein Ausdrucks-Edge oder ein Symbol ([Edge](_index.md#실행-edge)).
- Operatorcodes, Typdarstellung und Payload-Layout sind noch nicht festgelegt (offene Probleme in [Edge](_index.md#실행-edge)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0F50`). FIELD kommen hinzu, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [Edge — Ausführungs-Edge](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000F50/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F5000000000
BODY
#1 DECLARE 0x0F50
#2 BIND #1 "FOREACH"
```
