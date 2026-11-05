---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING es el Codec LINK que escribe una relación del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING es el Codec LINK que escribe una relación del grafo TOULMIN. Significado: conexión que solo emite el veredicto, sin efectos secundarios.

| Elemento | Valor |
|---|---|
| Nombre | `CHECKING` (BIND `CHECKING` del documento de especificación) |
| TAG ID | `0x114L` |
| Codec ID | `0x00001140` |
| Documento de especificación | `0x00000000/codecs/0x00001140/` (destino de DECLARE `1140`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 20 |
| Kind | Edge · familia: TOULMIN, grupo: ejecución, layout: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | conexión que solo emite el veredicto, sin efectos secundarios |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

El layout es [LINK](_index.md#link) (ID, src, dst, flags, campos condicionales, SPAN).

| Elemento | Valor |
|---|---|
| TANGEUL | `checking c` |
| src → dst | regla → caso. Veredicto sin efectos secundarios |

- dst es el REF de un nodo.
- F_FORCE no se usa (si está activado, se rechaza).
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1140`). Los campos condicionales del layout LINK y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001140/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
