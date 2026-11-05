---
title: "SQUASHED-FROM (0x1D8L)"
weight: 472
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica los hashes de contenido de las versiones originales fusionadas en una sola (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SQUASHED-FROM` (BIND del documento de especificación `SQUASHED-FROM`) |
| TAG ID | `0x1D8L` |
| Codec ID | `0x00001D80` |
| Documento de especificación | `0x00000000/codecs/0x00001D80/` (destino de DECLARE `1D80`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 24 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Hashes de contenido de las versiones originales fusionadas en una sola (git squash) |
| Lado Hugo | `meta/lineage/squashed-from.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | registro | `07C0` SHA-256-DIGEST |  |

Indica los hashes de contenido de las versiones originales fusionadas en una sola (git squash).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1000 LLLL      Codec 0x1D8L
[TAG de extensión de Length]
Payload           un Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x1D8L`, clase de linaje
- Payload: Value incorporado ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Cantidad: varios posibles (uno por versión original)

## Interpretación y validez {#해석과-유효성}

- El formato del resumen se incorpora como Value para dejar margen de cambiar el algoritmo de hash. Por ahora el hash de contenido es solo SHA-256.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D80/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D8000000000
BODY
#1 DECLARE 0x1D80
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "SQUASHED-FROM"
#4 BIND #2 "digest"
```
