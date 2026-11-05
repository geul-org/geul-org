---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE es el Codec del grupo de declaración de los Edge de ejecución."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE es el Codec del grupo de declaración de los Edge de ejecución. Significado: declaración de función.

| Elemento | Valor |
|---|---|
| Nombre | `FUNCTION-DECLARE` (BIND del documento de especificación `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| Documento de especificación | `0x00000000/codecs/0x00000E10/` (objetivo de DECLARE `0E10`) |
| Sección | 7 `0111` (ejecución de Edge), desplazamiento C dentro de la sección = 1 |
| Kind | Edge · familia: ejecución, grupo: declaración |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Declaración de función. Símbolo, lista de símbolos de parámetros, tipo de retorno, cuerpo (BLOCK) |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Símbolo, lista de símbolos de parámetros, tipo de retorno, cuerpo (BLOCK).

- Los componentes se señalan con el LOCAL ID (REF) de este documento. REF `0` significa ausente. En una posición de expresión se coloca un Edge de expresión o un símbolo ([Edge](_index.md#실행-edge)).
- Los códigos de operador, la representación de tipos y el layout del Payload aún no están definidos (problemas abiertos de [Edge](_index.md#실행-edge)).

## Documento de Codec {#코덱-문서}

El layout aún no está definido. El documento de Codec solo contiene DECLARE (objetivo `0E10`). Los FIELD se añaden cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de ejecución](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00000E10/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
