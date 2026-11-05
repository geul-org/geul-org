---
title: "CONST (0x0E8L)"
weight: 232
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CONST ist der Codec der Gruppe Ausdruck unter den Ausführungs-Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CONST ist der Codec der Gruppe Ausdruck unter den Ausführungs-Edge. Bedeutung: Konstantenausdruck.

| Eintrag | Wert |
|---|---|
| Name | `CONST` (Spezifikationsdokument BIND `CONST`) |
| TAG ID | `0x0E8L` |
| Codec ID | `0x00000E80` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000E80/` (DECLARE-Ziel `0E80`) |
| Abschnitt | 7 `0111` (Edge-Ausführung), Offset im Abschnitt C = 8 |
| Kind | Edge · Familie: Ausführung, Gruppe: Ausdruck |
| TAG WORD | `0000 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Konstantenausdruck. Ein eingebetteter Value |
| Hugo-Seite | `edge/_index.md` |

## Komponenten {#구성요소}

Ein eingebetteter Value.

- Komponenten werden über die LOCAL ID (REF) dieses Dokuments referenziert. REF `0` bedeutet nicht vorhanden. An Ausdrucksstellen steht ein Ausdrucks-Edge oder ein Symbol ([Edge](_index.md#실행-edge)).
- Operatorcodes, Typdarstellung und Payload-Layout sind noch nicht festgelegt (offene Probleme in [Edge](_index.md#실행-edge)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0E80`). FIELD kommen hinzu, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [Edge — Ausführungs-Edge](_index.md#실행-edge), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000E80/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E8000000000
BODY
#1 DECLARE 0x0E80
#2 BIND #1 "CONST"
```
