---
title: "CONSTRUCT (0x0EEL)"
weight: 238
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CONSTRUCT es el Codec del grupo de expresión de los Edge de ejecución."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CONSTRUCT es el Codec del grupo de expresión de los Edge de ejecución. Significado: construcción de valor compuesto (lista, registro).

| Elemento | Valor |
|---|---|
| Nombre | `CONSTRUCT` (BIND del documento de especificación `CONSTRUCT`) |
| TAG ID | `0x0EEL` |
| Codec ID | `0x00000EE0` |
| Documento de especificación | `0x00000000/codecs/0x00000EE0/` (objetivo de DECLARE `0EE0`) |
| Sección | 7 `0111` (ejecución de Edge), desplazamiento C dentro de la sección = 14 |
| Kind | Edge · familia: ejecución, grupo: expresión |
| TAG WORD | `0000 1110 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Construcción de valor compuesto (lista, registro). Tipo, número de elementos, elemento × número de elementos |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Tipo, número de elementos, elemento × número de elementos.

- Los componentes se señalan con el LOCAL ID (REF) de este documento. REF `0` significa ausente. En una posición de expresión se coloca un Edge de expresión o un símbolo ([Edge](_index.md#실행-edge)).
- Los códigos de operador, la representación de tipos y el layout del Payload aún no están definidos (problemas abiertos de [Edge](_index.md#실행-edge)).

## Documento de Codec {#코덱-문서}

El layout aún no está definido. El documento de Codec solo contiene DECLARE (objetivo `0EE0`). Los FIELD se añaden cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de ejecución](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONDITIONAL](0x0EFL-conditional.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00000EE0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EE000000000
BODY
#1 DECLARE 0x0EE0
#2 BIND #1 "CONSTRUCT"
```
