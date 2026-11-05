---
title: "CHERRY-PICKED-FROM (0x1D5L)"
weight: 469
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica el hash de contenido de la versión original de la que se tomó un cambio de otro linaje (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `CHERRY-PICKED-FROM` (BIND del documento de especificación `CHERRY-PICKED-FROM`) |
| TAG ID | `0x1D5L` |
| Codec ID | `0x00001D50` |
| Documento de especificación | `0x00000000/codecs/0x00001D50/` (destino de DECLARE `1D50`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 21 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Hash de contenido de la versión original de la que se tomó un cambio de otro linaje (git cherry-pick `-x`) |
| Lado Hugo | `meta/lineage/cherry-picked-from.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | registro | `07C0` SHA-256-DIGEST |  |

Indica el hash de contenido de la versión original de la que se tomó un cambio de otro linaje (git cherry-pick `-x`).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0101 LLLL      Codec 0x1D5L
[TAG de extensión de Length]
Payload           un Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x1D5L`, clase de linaje
- Payload: Value incorporado ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Cantidad: varios posibles

## Interpretación y validez {#해석과-유효성}

- El formato del resumen se incorpora como Value para dejar margen de cambiar el algoritmo de hash. Por ahora el hash de contenido es solo SHA-256.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D50/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D5000000000
BODY
#1 DECLARE 0x1D50
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "CHERRY-PICKED-FROM"
#4 BIND #2 "digest"
```
