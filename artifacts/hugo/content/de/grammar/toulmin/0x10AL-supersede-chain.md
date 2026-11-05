---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN ist ein TOULMIN-Edge-Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN ist ein TOULMIN-Edge-Codec. Bedeutung: Prioritätskette `A > B > C`. Kurzform des paarweisen SUPERSEDES.

| Eigenschaft | Wert |
|---|---|
| Name | `SUPERSEDE-CHAIN` (BIND `SUPERSEDE-CHAIN` des Spezifikationsdokuments) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000010A0/` (DECLARE-Ziel `10A0`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 10 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Relation |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Prioritätskette `A > B > C`. Kurzform des paarweisen SUPERSEDES. Layout noch offen |
| Hugo-Seite | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Nur der Code ist vergeben; ein Layout gibt es noch nicht ([TOULMIN](_index.md#열린-문제)).

- Derzeit wird [SUPERSEDES](0x109L-supersedes.md) je Paar einmal geschrieben. Ob das für eine Kette genügt, ist ein offenes Problem.

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `10A0`). FIELD kommt hinzu, sobald das Layout festgelegt ist.

## Verwandte Seiten {#관련-페이지}

- [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000010A0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
