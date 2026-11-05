---
title: "VERB-SHORT (0x0A8L)"
weight: 168
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB-SHORT es la forma abreviada de VERB, el Edge de enunciado verbal."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB-SHORT es la forma abreviada de [VERB](0x0A9L-verb.md), el Edge de enunciado verbal. `-SHORT` y la forma general se colocan como pareja par/impar ([Edge](_index.md#서술-edge)).

| Elemento | Valor |
|---|---|
| Nombre | `VERB-SHORT` (BIND del documento de especificación `VERB-SHORT`) |
| TAG ID | `0x0A8L` |
| Codec ID | `0x00000A80` |
| Documento de especificación | `0x00000000/codecs/0x00000A80/` (destino de DECLARE `0A80`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 8 |
| Kind | Edge · familia: enunciado, grupo: proposición |
| TAG WORD | `0000 1010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Abreviatura del enunciado verbal |
| Lado Hugo | `edge/_index.md` |

## Layout {#레이아웃}

El layout aún no está fijado. Sigue el layout común de Edge (TAG, [TAG de extensión de Length], Edge Id, componentes) ([Edge](_index.md#레이아웃)).

## Documento de codec {#코덱-문서}

El layout aún no está fijado. El documento de codec solo contiene DECLARE (destino `0A80`). Los FIELD se añadirán cuando se fije el layout.

## Páginas relacionadas {#관련-페이지}

- [VERB](0x0A9L-verb.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A80/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A8000000000
BODY
#1 DECLARE 0x0A80
#2 BIND #1 "VERB-SHORT"
```
