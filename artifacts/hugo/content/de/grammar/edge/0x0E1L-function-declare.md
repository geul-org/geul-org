---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE ist der Codec der Gruppe Deklaration unter den Ausführungs-Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE ist der Codec der Gruppe Deklaration unter den Ausführungs-Edge. Bedeutung: Funktionsdeklaration.

| Eintrag | Wert |
|---|---|
| Name | `FUNCTION-DECLARE` (Spezifikationsdokument BIND `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000E10/` (DECLARE-Ziel `0E10`) |
| Abschnitt | 7 `0111` (Edge-Ausführung), Offset im Abschnitt C = 1 |
| Kind | Edge · Familie: Ausführung, Gruppe: Deklaration |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Funktionsdeklaration. Symbol, Liste der Parametersymbole, Rückgabetyp, Rumpf (BLOCK) |
| Hugo-Seite | `edge/_index.md` |

## Komponenten {#구성요소}

Symbol, Liste der Parametersymbole, Rückgabetyp, Rumpf (BLOCK).

- Komponenten werden über die LOCAL ID (REF) dieses Dokuments referenziert. REF `0` bedeutet nicht vorhanden. An Ausdrucksstellen steht ein Ausdrucks-Edge oder ein Symbol ([Edge](_index.md#실행-edge)).
- Operatorcodes, Typdarstellung und Payload-Layout sind noch nicht festgelegt (offene Probleme in [Edge](_index.md#실행-edge)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0E10`). FIELD kommen hinzu, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [Edge — Ausführungs-Edge](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000E10/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
