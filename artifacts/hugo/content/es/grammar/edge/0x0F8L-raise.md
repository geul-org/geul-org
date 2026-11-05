---
title: "RAISE (0x0F8L)"
weight: 248
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "RAISE es el Codec del grupo de error de los Edge de ejecución."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RAISE es el Codec del grupo de error de los Edge de ejecución. Significado: lanzamiento de error.

| Elemento | Valor |
|---|---|
| Nombre | `RAISE` (BIND del documento de especificación `RAISE`) |
| TAG ID | `0x0F8L` |
| Codec ID | `0x00000F80` |
| Documento de especificación | `0x00000000/codecs/0x00000F80/` (objetivo de DECLARE `0F80`) |
| Sección | 7 `0111` (ejecución de Edge), desplazamiento C dentro de la sección = 24 |
| Kind | Edge · familia: ejecución, grupo: error |
| TAG WORD | `0000 1111 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Lanzamiento de error. Valor de error |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Valor de error.

- Los componentes se señalan con el LOCAL ID (REF) de este documento. REF `0` significa ausente. En una posición de expresión se coloca un Edge de expresión o un símbolo ([Edge](_index.md#실행-edge)).
- Los códigos de operador, la representación de tipos y el layout del Payload aún no están definidos (problemas abiertos de [Edge](_index.md#실행-edge)).

## Documento de Codec {#코덱-문서}

El layout aún no está definido. El documento de Codec solo contiene DECLARE (objetivo `0F80`). Los FIELD se añaden cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de ejecución](_index.md#실행-edge), [TRY](0x0F9L-try.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00000F80/latest.geul`leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F8000000000
BODY
#1 DECLARE 0x0F80
#2 BIND #1 "RAISE"
```
