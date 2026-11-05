---
title: "CONST (0x0E8L)"
weight: 232
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CONST es el Codec del grupo de expresión de los Edge de ejecución."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CONST es el Codec del grupo de expresión de los Edge de ejecución. Significado: expresión constante.

| Elemento | Valor |
|---|---|
| Nombre | `CONST` (BIND del documento de especificación `CONST`) |
| TAG ID | `0x0E8L` |
| Codec ID | `0x00000E80` |
| Documento de especificación | `0x00000000/codecs/0x00000E80/` (objetivo de DECLARE `0E80`) |
| Sección | 7 `0111` (ejecución de Edge), desplazamiento C dentro de la sección = 8 |
| Kind | Edge · familia: ejecución, grupo: expresión |
| TAG WORD | `0000 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Expresión constante. Un Value integrado |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Un Value integrado.

- Los componentes se señalan con el LOCAL ID (REF) de este documento. REF `0` significa ausente. En una posición de expresión se coloca un Edge de expresión o un símbolo ([Edge](_index.md#실행-edge)).
- Los códigos de operador, la representación de tipos y el layout del Payload aún no están definidos (problemas abiertos de [Edge](_index.md#실행-edge)).

## Documento de Codec {#코덱-문서}

El layout aún no está definido. El documento de Codec solo contiene DECLARE (objetivo `0E80`). Los FIELD se añaden cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de ejecución](_index.md#실행-edge), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00000E80/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E8000000000
BODY
#1 DECLARE 0x0E80
#2 BIND #1 "CONST"
```
