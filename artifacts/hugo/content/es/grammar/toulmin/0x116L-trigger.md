---
title: "TRIGGER (0x116L)"
weight: 278
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TRIGGER es el Codec NODE que escribe un nodo del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIGGER es el Codec NODE que escribe un nodo del grafo TOULMIN. Significado: punto de entrada de evento o periódico, sin llamada externa.

| Elemento | Valor |
|---|---|
| Nombre | `TRIGGER` (BIND `TRIGGER` del documento de especificación) |
| TAG ID | `0x116L` |
| Codec ID | `0x00001160` |
| Documento de especificación | `0x00000000/codecs/0x00001160/` (destino de DECLARE `1160`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 22 |
| Kind | Edge · familia: TOULMIN, grupo: ejecución, layout: NODE |
| TAG WORD | `0001 0001 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | punto de entrada de evento o periódico, sin llamada externa |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

El layout es [NODE](_index.md#node). Un WORD de encabezado fija el role, el level, la forma del Claim y los campos condicionales.

| Elemento | Valor |
|---|---|
| TANGEUL | `on`, `every`, `until` |
| Nodo | punto de entrada de evento o periódico |

- El role debe ser 0.
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1160`). Los campos condicionales del layout NODE y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001160/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000116000000000
BODY
#1 DECLARE 0x1160
#2 BIND #1 "TRIGGER"
```
