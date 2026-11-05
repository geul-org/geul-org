---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica que este documento deriva de documentos o materiales de otro linaje."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DERIVED-FROM` (BIND del documento de especificación `DERIVED-FROM`) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| Documento de especificación | `0x00000000/codecs/0x00001D20/` (destino de DECLARE `1D20`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 18 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Derivado de registros o materiales de otro linaje. Para fijar una versión concreta de un material externo, se añade al [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) del HEAD el QUALIFIER de hash del original (P4092) (git submodule). |
| Lado Hugo | `meta/lineage/derived-from.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

Indica que este documento deriva de documentos o materiales de otro linaje.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[TAG de extensión de Length]
Payload           Reference, o SHA-256-DIGEST (hash de contenido), o Value URI
```

- Codec: Meta `0x1D2L`, clase de linaje
- Payload: Reference o Value incorporado
- Cantidad: varios posibles

## Interpretación y validez {#해석과-유효성}

- Si deriva de un documento GEUL, se pone su hash de contenido ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)); si es un material externo, el [URI](../value/0x074L-uri.md). Para fijar por hash la edición de un material externo, se añade al [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) del HEAD el QUALIFIER de hash del original (P4092).
- El origen a nivel de registro lo asume el Edge de fundamento [SOURCE](../edge/0x0C0L-source.md); el registro antiguo anterior a un traslado, división o fusión lo asume el QUALIFIER P1365 del Edge objetivo (su valor es el Id del Edge antiguo).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D20/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
