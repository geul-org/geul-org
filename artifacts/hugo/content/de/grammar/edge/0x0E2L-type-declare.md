---
title: "TYPE-DECLARE (0x0E2L)"
weight: 226
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TYPE-DECLARE ist der Codec der Gruppe Deklaration unter den Ausführungs-Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TYPE-DECLARE ist der Codec der Gruppe Deklaration unter den Ausführungs-Edge. Bedeutung: Typdeklaration.

| Eintrag | Wert |
|---|---|
| Name | `TYPE-DECLARE` (Spezifikationsdokument BIND `TYPE-DECLARE`) |
| TAG ID | `0x0E2L` |
| Codec ID | `0x00000E20` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000E20/` (DECLARE-Ziel `0E20`) |
| Abschnitt | 7 `0111` (Edge-Ausführung), Offset im Abschnitt C = 2 |
| Kind | Edge · Familie: Ausführung, Gruppe: Deklaration |
| TAG WORD | `0000 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Typdeklaration. Symbol und Aufbau (Liste der Feldsymbole, Aufzählungswerte, Alias-Ziel) |
| Hugo-Seite | `edge/_index.md` |

## Komponenten {#구성요소}

Symbol und Aufbau (Liste der Feldsymbole, Aufzählungswerte, Alias-Ziel).

- Komponenten werden über die LOCAL ID (REF) dieses Dokuments referenziert. REF `0` bedeutet nicht vorhanden. An Ausdrucksstellen steht ein Ausdrucks-Edge oder ein Symbol ([Edge](_index.md#실행-edge)).
- Operatorcodes, Typdarstellung und Payload-Layout sind noch nicht festgelegt (offene Probleme in [Edge](_index.md#실행-edge)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0E20`). FIELD kommen hinzu, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [Edge — Ausführungs-Edge](_index.md#실행-edge), [FUNCTION-DECLARE](0x0E1L-function-declare.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000E20/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E2000000000
BODY
#1 DECLARE 0x0E20
#2 BIND #1 "TYPE-DECLARE"
```
