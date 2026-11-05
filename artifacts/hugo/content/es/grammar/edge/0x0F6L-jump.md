---
title: "JUMP (0x0F6L)"
weight: 246
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "JUMP es el Codec del grupo de sentencia de los Edge de ejecución."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

JUMP es el Codec del grupo de sentencia de los Edge de ejecución. Significado: control de repetición.

| Elemento | Valor |
|---|---|
| Nombre | `JUMP` (BIND del documento de especificación `JUMP`) |
| TAG ID | `0x0F6L` |
| Codec ID | `0x00000F60` |
| Documento de especificación | `0x00000000/codecs/0x00000F60/` (objetivo de DECLARE `0F60`) |
| Sección | 7 `0111` (ejecución de Edge), desplazamiento C dentro de la sección = 22 |
| Kind | Edge · familia: ejecución, grupo: sentencia |
| TAG WORD | `0000 1111 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Control de repetición. Tipo de 1 WORD (break, continue), repetición objetivo |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Tipo de 1 WORD (break, continue), repetición objetivo.

- Los componentes se señalan con el LOCAL ID (REF) de este documento. REF `0` significa ausente. En una posición de expresión se coloca un Edge de expresión o un símbolo ([Edge](_index.md#실행-edge)).
- Los códigos de operador, la representación de tipos y el layout del Payload aún no están definidos (problemas abiertos de [Edge](_index.md#실행-edge)).

## Documento de Codec {#코덱-문서}

El layout aún no está definido. El documento de Codec solo contiene DECLARE (objetivo `0F60`). Los FIELD se añaden cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de ejecución](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [RETURN](0x0F7L-return.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00000F60/latest.geul`leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F6000000000
BODY
#1 DECLARE 0x0F60
#2 BIND #1 "JUMP"
```
