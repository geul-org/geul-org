---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN es un Codec Edge de TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN es un Codec Edge de TOULMIN. Significado: cadena de prioridad `A > B > C`. Abreviatura de los SUPERSEDES por pares.

| Elemento | Valor |
|---|---|
| Nombre | `SUPERSEDE-CHAIN` (BIND `SUPERSEDE-CHAIN` del documento de especificación) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| Documento de especificación | `0x00000000/codecs/0x000010A0/` (destino de DECLARE `10A0`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 10 |
| Kind | Edge · familia: TOULMIN, grupo: relación |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | cadena de prioridad `A > B > C`. Abreviatura de los SUPERSEDES por pares. Layout sin definir |
| Lado Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Solo se ha asignado el código; el layout aún no existe ([TOULMIN](_index.md#열린-문제)).

- Por ahora se escribe un [SUPERSEDES](0x109L-supersedes.md) por cada par. Si eso basta para las cadenas es un problema abierto.

## Documento del Codec {#코덱-문서}

El layout no está definido. El documento del Codec contiene solo DECLARE (destino `10A0`). FIELD se añadirá cuando se defina el layout.

## Páginas relacionadas {#관련-페이지}

- [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x000010A0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
