---
title: "SPEC-DECLARE (0x102L)"
weight: 258
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SPEC-DECLARE es el Codec NODE que escribe un nodo del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SPEC-DECLARE es el Codec NODE que escribe un nodo del grafo TOULMIN. Significado: declaración de criterio de juicio (Backing). Los bits de role indican el tipo de definición.

| Elemento | Valor |
|---|---|
| Nombre | `SPEC-DECLARE` (BIND `SPEC-DECLARE` del documento de especificación) |
| TAG ID | `0x102L` |
| Codec ID | `0x00001020` |
| Documento de especificación | `0x00000000/codecs/0x00001020/` (destino de DECLARE `1020`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 2 |
| Kind | Edge · familia: TOULMIN, grupo: declaración, layout: NODE |
| TAG WORD | `0001 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | declaración de criterio de juicio (Backing). Los bits de role indican el tipo de definición |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

El layout es [NODE](_index.md#node). Un WORD de encabezado fija el role, el level, la forma del Claim y los campos condicionales.

| Elemento | Valor |
|---|---|
| TANGEUL | elemento de Definitions (`means`, `has`) |
| Nodo | criterio de juicio (Backing). El role indica el tipo de definición |

- El role indica el tipo de definición.
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1020`). Los campos condicionales del layout NODE y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001020/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000102000000000
BODY
#1 DECLARE 0x1020
#2 BIND #1 "SPEC-DECLARE"
```
