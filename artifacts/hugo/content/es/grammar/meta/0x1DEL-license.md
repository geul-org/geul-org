---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indica la licencia de este documento y de las obras contenidas en la secuencia de bytes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `LICENSE` (BIND del documento de especificación `LICENSE`) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| Documento de especificación | `0x00000000/codecs/0x00001DE0/` (destino de DECLARE `1DE0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 30 |
| Kind | Meta · clase: política |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Licencia. Reference |
| Lado Hugo | `meta/policy/license.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

Indica la licencia de este documento y de las obras contenidas en la secuencia de bytes.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[TAG de extensión de Length]
Payload           Reference que señala la licencia, o identificador SPDX UTF8-TEXT, o Value URI
```

- Codec: Meta `0x1DEL`, clase de política
- Payload: Reference o Value incorporado ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Los documentos publicados en geul.org son CC0. En las publicaciones privadas lo fija el Issuer ([Issuer](../issuer.md)).
- Se registra la licencia original de la obra de origen.

## Problemas abiertos {#열린-문제}

- Si el identificador SPDX se pone como texto o como Reference a una entidad GEUL.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001DE0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
