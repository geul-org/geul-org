---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD est un Edge d'énoncé qui écrit une vision du monde."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD est un Edge d'énoncé qui écrit une vision du monde. Sens : structure pour exprimer une vision du monde.

| Élément | Valeur |
|---|---|
| Nom | `WORLD` (BIND du document de spécification `WORLD`) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| Document de spécification | `0x00000000/codecs/0x00000B00/` (cible de DECLARE `0B00`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 16 |
| Kind | Edge · famille : énoncé, groupe : structure |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Structure pour exprimer une vision du monde |
| Côté Hugo | `edge/_index.md` |

## Disposition {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[TAG d'extension de Length]
TAG de Codec      1 WORD. sous-format
Edge Id           enregistrement Reference LOCAL
composants        fixés par le sous-format
```

- C'est un Codec ayant des sous-formats. 1 WORD de TAG propre au Codec indique le sous-format ([enregistrement et TAG WORD](../record.md#레코드-레이아웃)).
- Les sous-formats et les composants ne sont pas encore fixés.

## Document de codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de codec ne contient que DECLARE (cible `0B00`). Les FIELD seront ajoutés une fois la disposition fixée.

## Pages liées {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (comment déclarer un Codec ayant des sous-formats)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000B00/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
