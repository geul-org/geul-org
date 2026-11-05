---
title: "SWITCH (0x0F3L)"
weight: 243
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "SWITCH es el Codec del grupo de sentencia de los Edge de ejecución."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SWITCH es el Codec del grupo de sentencia de los Edge de ejecución. Significado: bifurcación múltiple.

| Elemento | Valor |
|---|---|
| Nombre | `SWITCH` (BIND del documento de especificación `SWITCH`) |
| TAG ID | `0x0F3L` |
| Codec ID | `0x00000F30` |
| Documento de especificación | `0x00000000/codecs/0x00000F30/` (objetivo de DECLARE `0F30`) |
| Sección | 7 `0111` (ejecución de Edge), desplazamiento C dentro de la sección = 19 |
| Kind | Edge · familia: ejecución, grupo: sentencia |
| TAG WORD | `0000 1111 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Bifurcación múltiple. Objetivo, número de ramas, (valor, BLOCK) × número de ramas, BLOCK por defecto (0 si no hay) |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Objetivo, número de ramas, (valor, BLOCK) × número de ramas, BLOCK por defecto (0 si no hay).

- Los componentes se señalan con el LOCAL ID (REF) de este documento. REF `0` significa ausente. En una posición de expresión se coloca un Edge de expresión o un símbolo ([Edge](_index.md#실행-edge)).
- Los códigos de operador, la representación de tipos y el layout del Payload aún no están definidos (problemas abiertos de [Edge](_index.md#실행-edge)).

## Documento de Codec {#코덱-문서}

El layout aún no está definido. El documento de Codec solo contiene DECLARE (objetivo `0F30`). Los FIELD se añaden cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de ejecución](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00000F30/latest.geul`leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F3000000000
BODY
#1 DECLARE 0x0F30
#2 BIND #1 "SWITCH"
```
