---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB es el Edge de enunciado verbal."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB es el Edge de enunciado verbal. Su forma abreviada es [VERB-SHORT](0x0A8L-verb-short.md) (`0x0A8L`) ([Edge](_index.md#서술-edge)).

| Elemento | Valor |
|---|---|
| Nombre | `VERB` (BIND del documento de especificación `VERB`) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| Documento de especificación | `0x00000000/codecs/0x00000A90/` (destino de DECLARE `0A90`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 9 |
| Kind | Edge · familia: enunciado, grupo: proposición |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Enunciado verbal |
| Lado Hugo | `edge/_index.md` |

## Layout {#레이아웃}

El layout aún no está fijado. Sigue el layout común de Edge (TAG, [TAG de extensión de Length], Edge Id, componentes) ([Edge](_index.md#레이아웃)).

## Documento de codec {#코덱-문서}

El layout aún no está fijado. El documento de codec solo contiene DECLARE (destino `0A90`). Los FIELD se añadirán cuando se fije el layout.

## Páginas relacionadas {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A90/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
