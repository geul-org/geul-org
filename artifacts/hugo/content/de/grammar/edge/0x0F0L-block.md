---
title: "BLOCK (0x0F0L)"
weight: 240
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "BLOCK ist der Codec der Gruppe Anweisung unter den Ausführungs-Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLOCK ist der Codec der Gruppe Anweisung unter den Ausführungs-Edge. Bedeutung: geordnete Gruppe von Anweisungen.

| Eintrag | Wert |
|---|---|
| Name | `BLOCK` (Spezifikationsdokument BIND `BLOCK`) |
| TAG ID | `0x0F0L` |
| Codec ID | `0x00000F00` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000F00/` (DECLARE-Ziel `0F00`) |
| Abschnitt | 7 `0111` (Edge-Ausführung), Offset im Abschnitt C = 16 |
| Kind | Edge · Familie: Ausführung, Gruppe: Anweisung |
| TAG WORD | `0000 1111 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Geordnete Gruppe von Anweisungen. Anzahl der Anweisungen, Anweisung × Anzahl der Anweisungen |
| Hugo-Seite | `edge/_index.md` |

## Komponenten {#구성요소}

Anzahl der Anweisungen, Anweisung × Anzahl der Anweisungen.

- Komponenten werden über die LOCAL ID (REF) dieses Dokuments referenziert. REF `0` bedeutet nicht vorhanden. An Ausdrucksstellen steht ein Ausdrucks-Edge oder ein Symbol ([Edge](_index.md#실행-edge)).
- Operatorcodes, Typdarstellung und Payload-Layout sind noch nicht festgelegt (offene Probleme in [Edge](_index.md#실행-edge)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0F00`). FIELD kommen hinzu, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [Edge — Ausführungs-Edge](_index.md#실행-edge), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000F00/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F0000000000
BODY
#1 DECLARE 0x0F00
#2 BIND #1 "BLOCK"
```
