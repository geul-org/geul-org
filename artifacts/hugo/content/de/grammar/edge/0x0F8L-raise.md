---
title: "RAISE (0x0F8L)"
weight: 248
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "RAISE ist der Codec der Gruppe Fehler unter den Ausführungs-Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RAISE ist der Codec der Gruppe Fehler unter den Ausführungs-Edge. Bedeutung: Fehler auslösen.

| Eintrag | Wert |
|---|---|
| Name | `RAISE` (Spezifikationsdokument BIND `RAISE`) |
| TAG ID | `0x0F8L` |
| Codec ID | `0x00000F80` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000F80/` (DECLARE-Ziel `0F80`) |
| Abschnitt | 7 `0111` (Edge-Ausführung), Offset im Abschnitt C = 24 |
| Kind | Edge · Familie: Ausführung, Gruppe: Fehler |
| TAG WORD | `0000 1111 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Fehler auslösen. Fehlerwert |
| Hugo-Seite | `edge/_index.md` |

## Komponenten {#구성요소}

Fehlerwert.

- Komponenten werden über die LOCAL ID (REF) dieses Dokuments referenziert. REF `0` bedeutet nicht vorhanden. An Ausdrucksstellen steht ein Ausdrucks-Edge oder ein Symbol ([Edge](_index.md#실행-edge)).
- Operatorcodes, Typdarstellung und Payload-Layout sind noch nicht festgelegt (offene Probleme in [Edge](_index.md#실행-edge)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0F80`). FIELD kommen hinzu, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [Edge — Ausführungs-Edge](_index.md#실행-edge), [TRY](0x0F9L-try.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000F80/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F8000000000
BODY
#1 DECLARE 0x0F80
#2 BIND #1 "RAISE"
```
