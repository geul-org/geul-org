---
title: "COUNTER-DECLARE (0x104L)"
weight: 260
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "COUNTER-DECLARE es el Codec NODE que escribe un nodo del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COUNTER-DECLARE es el Codec NODE que escribe un nodo del grafo TOULMIN. Significado: declaración de refutación. Ataca con una conclusión propia. El Level por defecto es Fail.

| Elemento | Valor |
|---|---|
| Nombre | `COUNTER-DECLARE` (BIND `COUNTER-DECLARE` del documento de especificación) |
| TAG ID | `0x104L` |
| Codec ID | `0x00001040` |
| Documento de especificación | `0x00000000/codecs/0x00001040/` (destino de DECLARE `1040`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 4 |
| Kind | Edge · familia: TOULMIN, grupo: declaración, layout: NODE |
| TAG WORD | `0001 0000 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | declaración de refutación. Ataca con una conclusión propia. El Level por defecto es Fail |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

El layout es [NODE](_index.md#node). Un WORD de encabezado fija el role, el level, la forma del Claim y los campos condicionales.

| Elemento | Valor |
|---|---|
| TANGEUL | counter rule |
| Nodo | refutación (Rebuttal) |

- El role debe ser 1 (counter). Si el level es 0 (Unset), se usa el valor por defecto del motor, Fail.
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1040`). Los campos condicionales del layout NODE y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001040/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000104000000000
BODY
#1 DECLARE 0x1040
#2 BIND #1 "COUNTER-DECLARE"
```
