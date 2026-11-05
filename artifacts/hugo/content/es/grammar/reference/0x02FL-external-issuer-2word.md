---
title: "EXTERNAL-ISSUER-2WORD (0x02FL~0x033L)"
weight: 47
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER es un Reference de designación y declaración que cita en un solo registro, sin IMPORT, el LOCAL ID de un documento publicado por un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER es un Reference de designación y declaración que cita en un solo registro, sin IMPORT, el LOCAL ID de un documento publicado por un Issuer.

| Elemento | Valor |
|---|---|
| Nombre | `EXTERNAL-ISSUER-2WORD` (grupo 5Q. Los nombres por código están en la tabla de miembros más abajo) |
| TAG ID | `0x02FL~0x033L` |
| Sección | 1 `0001` (Reference EXTERNAL), desplazamiento dentro de la sección C = 15~19 |
| Kind | Reference · clasificación: designación y declaración |
| Lado Hugo | `reference/external-issuer.md` (esa página trata también [EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md) y [EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)) |

## Miembros {#구성원}

Esta página trata un conjunto del sistema 5Q, cinco códigos a la vez. La cuantificación es el desplazamiento dentro de la sección `C % 5` ([Reference](_index.md#quantifier)). Hay un documento de Codec por código. Los campos de los cinco documentos de Codec son iguales; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Cuantificación | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x02FL` | `EXTERNAL-ISSUER-2WORD-IDENTIFIED` | Identified | `0x000002F0` | `0x00000000/codecs/0x000002F0/` | `0000 0010 1111 LLLL` |
| `0x030L` | `EXTERNAL-ISSUER-2WORD-GENERIC` | Generic | `0x00000300` | `0x00000000/codecs/0x00000300/` | `0000 0011 0000 LLLL` |
| `0x031L` | `EXTERNAL-ISSUER-2WORD-FREE-CHOICE` | Free-choice | `0x00000310` | `0x00000000/codecs/0x00000310/` | `0000 0011 0001 LLLL` |
| `0x032L` | `EXTERNAL-ISSUER-2WORD-UNIVERSAL` | Universal | `0x00000320` | `0x00000000/codecs/0x00000320/` | `0000 0011 0010 LLLL` |
| `0x033L` | `EXTERNAL-ISSUER-2WORD-VARIABLE` | Variable | `0x00000330` | `0x00000000/codecs/0x00000330/` | `0000 0011 0011 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor en bruto de 2 WORD |  |  |
| 2 | `doc` | #3 | valor en bruto de 4 WORD |  |  |
| 3 | `target-id` | #4 | resto en valor en bruto (`0xFFFF`) |  |  |

EXTERNAL-ISSUER es un Reference de designación y declaración que cita, sin IMPORT, el LOCAL ID de un documento publicado por un Issuer. Un solo registro completa el sentido y sigue la versión más reciente.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (sección 1)
[TAG de extensión de Length]
Issuer            ancho fijado por el Codec (2/4/16 WORD)
ID de documento   4 WORD
ID de destino     todo el resto. LOCAL ID de ese documento, en el ancho más corto
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nombre | Ancho del Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (registrado en geul.org, dominio verificado) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (registrado en geul.org, sin verificación) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (calculado a partir de la clave pública) |

- El ancho lo fija el número de sistema: si sistema − 9 (`C / 5 − 3`, con `C` el desplazamiento dentro de la sección) es 0, 1 o 2, el ancho es 2, 4 o 16 WORD. La cuantificación es `C % 5`.
- El Issuer ID es un valor entero. Si el valor es igual, es el mismo Issuer. El Issuer se escribe con el ancho más corto en que quepa el valor, y se elige el Codec de ese ancho (4 WORD solo a partir de `2^32`, 16 WORD solo a partir de `2^64`). Una notación de ancho mayor es invalid ([Issuer](../issuer.md)).
- El registro y la administración de Issuer los lleva geul.org.
- No se escribe la versión; se sigue la más reciente. Para fijar la versión se usan [IMPORT-DOC](../meta/0x1E4L-import-doc.md) y [EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- La ubicación se encuentra con la regla de direcciones de publicación ([Direcciones de publicación y lista de versiones](../publishing.md)).
- Si es el mismo LOCAL ID de ese documento, es el mismo objeto tanto si dentro de ese documento se usa como LOCAL como si en otro documento se usa como EXTERNAL-ISSUER (o como EXTERNAL-POINTER tras un IMPORT).
- Solo señala LOCAL de documentos. El propio documento se señala con [DOC-POINTER](0x041L-doc-pointer.md) y el propio Issuer con [ISSUER-POINTER](0x040L-issuer-pointer.md). Por eso el ID de destino no es `0`. El ID de documento `0` es el documento índice de definición de términos del Issuer.

## Validez {#유효성}

- Es invalid si el ancho del Issuer no concuerda con el Codec, o si el valor cabe en un ancho más estrecho.
- Es invalid si el ID de destino es `0`. El ID de destino `0` (el propio documento) corresponde a DOC-POINTER.
- Se prohíbe un WORD `0x0000` inicial en el ID de destino.

## Ejemplo {#예시}

| Destino | WORD sequence |
|---|---|
| Issuer `0x00000002`, documento `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, documento `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer y publicación](../issuer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x000002F0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002F000000000
BODY
#1 DECLARE 0x02F0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-2WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

Lo anterior es el documento de Codec de `EXTERNAL-ISSUER-2WORD-IDENTIFIED` (`0x02FL`). En los documentos de Codec de los demás miembros (`EXTERNAL-ISSUER-2WORD-GENERIC`, `EXTERNAL-ISSUER-2WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-2WORD-UNIVERSAL`, `EXTERNAL-ISSUER-2WORD-VARIABLE`) solo difieren el Codec ID del DOC-ID, el destino de DECLARE y el nombre asociado en `#1` (BIND).
