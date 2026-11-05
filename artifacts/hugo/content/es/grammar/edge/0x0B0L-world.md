---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD es un Edge de enunciado que escribe la cosmovisión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD es un Edge de enunciado que escribe la cosmovisión. Sentido: estructura para expresar una cosmovisión.

| Elemento | Valor |
|---|---|
| Nombre | `WORLD` (BIND del documento de especificación `WORLD`) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| Documento de especificación | `0x00000000/codecs/0x00000B00/` (destino de DECLARE `0B00`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 16 |
| Kind | Edge · familia: enunciado, grupo: estructura |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Estructura para expresar una cosmovisión |
| Lado Hugo | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[TAG de extensión de Length]
TAG propio del Codec  1 WORD. subformato
Edge Id           registro Reference LOCAL
componentes       los fija el subformato
```

- Es un Codec con subformatos. 1 TAG WORD propio del Codec especifica el subformato ([registro y TAG WORD](../record.md#레코드-레이아웃)).
- Los subformatos y los componentes aún no están fijados.

## Documento de codec {#코덱-문서}

El layout aún no está fijado. El documento de codec solo contiene DECLARE (destino `0B00`). Los FIELD se añadirán cuando se fije el layout.

## Páginas relacionadas {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (cómo declarar un Codec con subformatos)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000B00/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
