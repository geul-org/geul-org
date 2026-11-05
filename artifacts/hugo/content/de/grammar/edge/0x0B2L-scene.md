---
title: "SCENE (0x0B2L)"
weight: 178
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "SCENE ist ein Aussage-Edge zum Schreiben von Szenenstrukturen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SCENE ist ein Aussage-Edge zum Schreiben von Szenenstrukturen. Bedeutung: Szenenstruktur für Aussagen mit Szenario-Charakter.

| Eintrag | Wert |
|---|---|
| Name | `SCENE` (BIND des Spezifikationsdokuments `SCENE`) |
| TAG ID | `0x0B2L` |
| Codec ID | `0x00000B20` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000B20/` (DECLARE-Ziel `0B20`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 18 |
| Kind | Edge · Familie: Aussage, Gruppe: Struktur |
| TAG WORD | `0000 1011 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Szenenstruktur für Aussagen mit Szenario-Charakter |
| Hugo-Seite | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0010 LLLL      Codec 0x0B2L
[Length-Erweiterungs-TAG]
Codec-TAG         1 WORD. Unterformat
Edge Id           LOCAL Reference-Record
Komponenten       legt das Unterformat fest
```

- Dies ist ein Codec mit Unterformaten. 1 WORD Codec-spezifischer TAG bestimmt das Unterformat ([Record und TAG WORD](../record.md#레코드-레이아웃)).
- Unterformate und Komponenten sind noch nicht festgelegt.

## Codec-Dokument {#코덱-문서}

Das Layout ist noch nicht festgelegt. Das Codec-Dokument enthält nur DECLARE (Ziel `0B20`). FIELD folgt, sobald das Layout feststeht.

## Verwandte Seiten {#관련-페이지}

- [WORLD](0x0B0L-world.md), [TIMELINE](0x0B1L-timeline.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (Deklaration von Codecs mit Unterformaten)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000B20/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B2000000000
BODY
#1 DECLARE 0x0B20
#2 BIND #1 "SCENE"
```
