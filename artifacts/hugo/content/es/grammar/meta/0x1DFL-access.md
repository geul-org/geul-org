---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indica el alcance de divulgación del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `ACCESS` (BIND del documento de especificación `ACCESS`) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| Documento de especificación | `0x00000000/codecs/0x00001DF0/` (destino de DECLARE `1DF0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 31 |
| Kind | Meta · clase: política |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Alcance de divulgación |
| Lado Hugo | `meta/policy/access.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | valor en bruto, 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

Indica el alcance de divulgación del documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[TAG de extensión de Length]
Nivel             1 WORD (0 público, 1 interno, 2 confidencial, el resto Reserved)
```

- Codec: Meta `0x1DFL`, clase de política
- Payload: valor en bruto (nivel de 1 WORD)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Los documentos confidenciales no se publican ([Issuer](../issuer.md)).
- No cambia la interpretación. Solo fija el tratamiento.

## Problemas abiertos {#열린-문제}

- Tabla de códigos de nivel.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001DF0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
