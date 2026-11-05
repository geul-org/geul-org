---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica el hash de contenido de la versión inmediatamente anterior (git parent)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `PARENT` (BIND del documento de especificación `PARENT`) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| Documento de especificación | `0x00000000/codecs/0x00001D10/` (destino de DECLARE `1D10`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 17 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Hash de contenido de la versión inmediatamente anterior (git parent). Si falta, es la primera versión; si hay varios, es una fusión (git merge commit). |
| Lado Hugo | `meta/lineage/parent.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | registro | `07C0` SHA-256-DIGEST |  |

Indica el hash de contenido de la versión inmediatamente anterior (git parent).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[TAG de extensión de Length]
Payload           un Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x1D1L`, clase de linaje
- Payload: Value incorporado ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Cantidad: varios posibles (fusión)

## Interpretación y validez {#해석과-유효성}

- Si falta, es la primera versión; si hay varios, es una fusión (git merge commit).
- Entra en el [hash de contenido](../document.md#내용-해시), de modo que todo el historial forma una cadena de hashes.
- El documento de la lista de versiones señala la lista anterior ([PUBLICATION](../edge/0x0B8L-publication.md)).
- El formato del resumen se incorpora como Value para dejar margen de cambiar el algoritmo de hash. Por ahora el hash de contenido es solo SHA-256.

## Ejemplo {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta de 20 WORD = TAG + TAG de extensión de Length + Value incorporado de 18 WORD)

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D10/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
