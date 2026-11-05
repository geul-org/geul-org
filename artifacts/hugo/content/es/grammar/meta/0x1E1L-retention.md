---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indica el plazo de conservación del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `RETENTION` (BIND del documento de especificación `RETENTION`) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| Documento de especificación | `0x00000000/codecs/0x00001E10/` (destino de DECLARE `1E10`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 1 |
| Kind | Meta · clase: política |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Plazo de conservación |
| Lado Hugo | `meta/policy/retention.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

Indica el plazo de conservación del documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[TAG de extensión de Length]
Payload           momento de expiración (GREGORIAN-DATE, etc.) o duración (DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`, clase de política
- Payload: Value incorporado (familia TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), etc., o [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Si es una duración, se cuenta desde [RECORDED-AT](0x1D0L-recorded-at.md).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E10/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
