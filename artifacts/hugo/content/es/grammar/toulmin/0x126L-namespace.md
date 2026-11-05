---
title: "NAMESPACE (0x126L)"
weight: 294
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NAMESPACE es el Codec NODE que escribe un nodo del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NAMESPACE es el Codec NODE que escribe un nodo del grafo TOULMIN. Significado: `this document is`. Espacio de nombres del documento.

| Elemento | Valor |
|---|---|
| Nombre | `NAMESPACE` (BIND `NAMESPACE` del documento de especificación) |
| TAG ID | `0x126L` |
| Codec ID | `0x00001260` |
| Documento de especificación | `0x00000000/codecs/0x00001260/` (destino de DECLARE `1260`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 6 |
| Kind | Edge · familia: formato TOULMIN, layout: NODE |
| TAG WORD | `0001 0010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | `this document is`. Espacio de nombres del documento |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

El layout es [NODE](_index.md#node). Un WORD de encabezado fija el role, el level, la forma del Claim y los campos condicionales.

| Elemento | Valor |
|---|---|
| TANGEUL | this document is |
| Nodo | espacio de nombres del documento |

- El role debe ser 0.
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1260`). Los campos condicionales del layout NODE y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001260/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000126000000000
BODY
#1 DECLARE 0x1260
#2 BIND #1 "NAMESPACE"
```
