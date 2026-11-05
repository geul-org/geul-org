---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indica el nivel de datos personales del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `PRIVACY` (BIND del documento de especificación `PRIVACY`) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| Documento de especificación | `0x00000000/codecs/0x00001E00/` (destino de DECLARE `1E00`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 0 |
| Kind | Meta · clase: política |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Nivel de datos personales |
| Lado Hugo | `meta/policy/privacy.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | valor en bruto, 1 WORD |  |  |

Indica el nivel de datos personales del documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[TAG de extensión de Length]
Nivel             1 WORD
```

- Codec: Meta `0x1E0L`, clase de política
- Payload: valor en bruto (nivel de 1 WORD)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- No cambia la interpretación. Solo fija el tratamiento.

## Problemas abiertos {#열린-문제}

- Tabla de códigos de nivel (correspondencia con la clasificación de la ley de protección de datos personales).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E00/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
