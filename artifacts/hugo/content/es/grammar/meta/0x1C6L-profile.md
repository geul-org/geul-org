---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara el perfil aplicado al documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `PROFILE` (BIND del documento de especificación `PROFILE`) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| Documento de especificación | `0x00000000/codecs/0x00001C60/` (destino de DECLARE `1C60`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 6 |
| Kind | Meta · clase: definición |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Perfil aplicado |
| Lado Hugo | `meta/declaration/profile.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

Declara el perfil aplicado al documento. Los mismos registros se interpretan con los documentos de Codec que fija el perfil (por ejemplo, con `tangeul-1.0`, [TOULMIN](../toulmin/_index.md)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[TAG de extensión de Length]
Payload           Value UTF8-TEXT "<nombre>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`, clase de definición
- Payload: Value incorporado ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Se rechazan los perfiles con otro major. Se admite una diferencia de minor (solo cambios aditivos).
- Sin perfil, se lee solo con la gramática básica de GEUL y las especificaciones de código directo.

## Ejemplo {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## Problemas abiertos {#열린-문제}

- Registro de nombres de perfil (geul.org) y reglas de nombres.
- Si el perfil se señala con un ID de documento (IMPORT) o se pone como texto.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C60/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
