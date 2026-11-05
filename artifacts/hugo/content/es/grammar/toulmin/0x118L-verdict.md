---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT es un Codec Edge de TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT es un Codec Edge de TOULMIN. Significado: resultado del veredicto de un nodo o registro. Resultado (Pass, Review, Fail), valor del veredicto, Activated, Excluded, Level.

| Elemento | Valor |
|---|---|
| Nombre | `VERDICT` (BIND `VERDICT` del documento de especificación) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| Documento de especificación | `0x00000000/codecs/0x00001180/` (destino de DECLARE `1180`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 24 |
| Kind | Edge · familia: TOULMIN, grupo: resultado |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | resultado del veredicto de un nodo o registro. Resultado (Pass, Review, Fail), valor del veredicto, Activated, Excluded, Level. Layout sin definir |
| Lado Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Solo se ha asignado el código; el layout aún no existe ([TOULMIN](_index.md#열린-문제)).

- El veredicto del documento completo corresponde al Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). Son dos Codecs distintos, de Kind diferente.
- El resultado del veredicto se coloca en un documento distinto del que contiene el objeto juzgado ([TOULMIN](_index.md#판정-결과)).

## Documento del Codec {#코덱-문서}

El layout no está definido. El documento del Codec contiene solo DECLARE (destino `1180`). FIELD se añadirá cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001180/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
