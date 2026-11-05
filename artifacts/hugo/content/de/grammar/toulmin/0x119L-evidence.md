---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE ist ein TOULMIN-Edge-Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE ist ein TOULMIN-Edge-Codec. Bedeutung: Beleg der Beurteilung. Position, Erwartungswert, Istwert (Fact).

| Eigenschaft | Wert |
|---|---|
| Name | `EVIDENCE` (BIND `EVIDENCE` des Spezifikationsdokuments) |
| TAG ID | `0x119L` |
| Codec ID | `0x00001190` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001190/` (DECLARE-Ziel `1190`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 25 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Ergebnis |
| TAG WORD | `0001 0001 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Beleg der Beurteilung. Position, Erwartungswert, Istwert (Fact). Layout noch offen |
| Hugo-Seite | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Nur der Code ist vergeben; ein Layout gibt es noch nicht ([TOULMIN](_index.md#열린-문제)).

- Das Beurteilungsergebnis steht in einem anderen Dokument als das Beurteilungsobjekt ([TOULMIN](_index.md#판정-결과)).

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `1190`). FIELD kommt hinzu, sobald das Layout festgelegt ist.

## Verwandte Seiten {#관련-페이지}

- [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001190/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
