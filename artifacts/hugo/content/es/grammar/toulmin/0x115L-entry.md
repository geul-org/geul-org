---
title: "ENTRY (0x115L)"
weight: 277
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ENTRY es el Codec NODE que escribe un nodo del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENTRY es el Codec NODE que escribe un nodo del grafo TOULMIN. Significado: punto de entrada externo. Ejecuta o juzga un caso.

| Elemento | Valor |
|---|---|
| Nombre | `ENTRY` (BIND `ENTRY` del documento de especificación) |
| TAG ID | `0x115L` |
| Codec ID | `0x00001150` |
| Documento de especificación | `0x00000000/codecs/0x00001150/` (destino de DECLARE `1150`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 21 |
| Kind | Edge · familia: TOULMIN, grupo: ejecución, layout: NODE |
| TAG WORD | `0001 0001 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | punto de entrada externo. Ejecuta o juzga un caso |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

El layout es [NODE](_index.md#node). Un WORD de encabezado fija el role, el level, la forma del Claim y los campos condicionales.

| Elemento | Valor |
|---|---|
| TANGEUL | provides x |
| Nodo | punto de entrada externo |

- El role debe ser 0.
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1150`). Los campos condicionales del layout NODE y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001150/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000115000000000
BODY
#1 DECLARE 0x1150
#2 BIND #1 "ENTRY"
```
