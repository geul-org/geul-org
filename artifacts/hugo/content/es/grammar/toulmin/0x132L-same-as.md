---
title: "SAME-AS (0x132L)"
weight: 306
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SAME-AS es el Codec LINK que escribe una relación del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-AS es el Codec LINK que escribe una relación del grafo TOULMIN. Significado: nodo → identificador global.

| Elemento | Valor |
|---|---|
| Nombre | `SAME-AS` (BIND `SAME-AS` del documento de especificación) |
| TAG ID | `0x132L` |
| Codec ID | `0x00001320` |
| Documento de especificación | `0x00000000/codecs/0x00001320/` (destino de DECLARE `1320`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 18 |
| Kind | Edge · familia: formato TOULMIN, layout: LINK |
| TAG WORD | `0001 0011 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | nodo → identificador global |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

El layout es [LINK](_index.md#link) (ID, src, dst, flags, campos condicionales, SPAN).

| Elemento | Valor |
|---|---|
| TANGEUL | — |
| src → dst | nodo → identificador global |

- dst es el REF de un nodo.
- F_FORCE no se usa (si está activado, se rechaza).
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1320`). Los campos condicionales del layout LINK y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001320/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000132000000000
BODY
#1 DECLARE 0x1320
#2 BIND #1 "SAME-AS"
```
