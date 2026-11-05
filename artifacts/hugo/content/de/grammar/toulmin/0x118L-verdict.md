---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT ist ein TOULMIN-Edge-Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT ist ein TOULMIN-Edge-Codec. Bedeutung: Beurteilungsergebnis eines Knotens oder Records. Ergebnis (Pass, Review, Fail), Beurteilungswert, Activated, Excluded, Level.

| Eigenschaft | Wert |
|---|---|
| Name | `VERDICT` (BIND `VERDICT` des Spezifikationsdokuments) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001180/` (DECLARE-Ziel `1180`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 24 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Ergebnis |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Beurteilungsergebnis eines Knotens oder Records. Ergebnis (Pass, Review, Fail), Beurteilungswert, Activated, Excluded, Level. Layout noch offen |
| Hugo-Seite | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Nur der Code ist vergeben; ein Layout gibt es noch nicht ([TOULMIN](_index.md#열린-문제)).

- Die Beurteilung des gesamten Dokuments übernimmt das Meta-[VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). Beide sind getrennte Codecs mit unterschiedlichem Kind.
- Das Beurteilungsergebnis steht in einem anderen Dokument als das Beurteilungsobjekt ([TOULMIN](_index.md#판정-결과)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `1180`). FIELD kommt hinzu, sobald das Layout festgelegt ist.

## Verwandte Seiten {#관련-페이지}

- [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001180/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
