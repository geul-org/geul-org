---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara el idioma por defecto de los textos del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DEFAULT-LANGUAGE` (BIND del documento de especificación `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| Documento de especificación | `0x00000000/codecs/0x00001CA0/` (destino de DECLARE `1CA0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 10 |
| Kind | Meta · clase: definición |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Idioma por defecto |
| Lado Hugo | `meta/declaration/default-language.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | registro | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

Declara el idioma por defecto de los textos del documento. Los textos cuyo idioma no se indica aparte están en este idioma.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[TAG de extensión de Length]
Payload           un Value de idioma
```

- Codec: Meta `0x1CAL`, clase de definición
- Payload: Value incorporado ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) o [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Los documentos TANGEUL indican la configuración regional de redacción (por ejemplo, `en`, `ko`).

## Ejemplo {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001CA0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
