---
title: "TRY (0x0F9L)"
weight: 249
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TRY es el Codec del grupo de error de los Edge de ejecución."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRY es el Codec del grupo de error de los Edge de ejecución. Significado: manejo de errores.

| Elemento | Valor |
|---|---|
| Nombre | `TRY` (BIND del documento de especificación `TRY`) |
| TAG ID | `0x0F9L` |
| Codec ID | `0x00000F90` |
| Documento de especificación | `0x00000000/codecs/0x00000F90/` (objetivo de DECLARE `0F90`) |
| Sección | 7 `0111` (ejecución de Edge), desplazamiento C dentro de la sección = 25 |
| Kind | Edge · familia: ejecución, grupo: error |
| TAG WORD | `0000 1111 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Manejo de errores. BLOCK del cuerpo, símbolo de error, BLOCK de manejo, BLOCK de cierre (0 si no hay) |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

BLOCK del cuerpo, símbolo de error, BLOCK de manejo, BLOCK de cierre (0 si no hay).

- Los componentes se señalan con el LOCAL ID (REF) de este documento. REF `0` significa ausente. En una posición de expresión se coloca un Edge de expresión o un símbolo ([Edge](_index.md#실행-edge)).
- Los códigos de operador, la representación de tipos y el layout del Payload aún no están definidos (problemas abiertos de [Edge](_index.md#실행-edge)).

## Documento de Codec {#코덱-문서}

El layout aún no está definido. El documento de Codec solo contiene DECLARE (objetivo `0F90`). Los FIELD se añaden cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de ejecución](_index.md#실행-edge), [RAISE](0x0F8L-raise.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00000F90/latest.geul`leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F9000000000
BODY
#1 DECLARE 0x0F90
#2 BIND #1 "TRY"
```
