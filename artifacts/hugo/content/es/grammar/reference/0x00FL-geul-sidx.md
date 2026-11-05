---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX es un Reference de declaración que señala un objeto mediante un GEUL SIDX (Semantic-aligned Index)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `GEUL-SIDX` (grupo 5Q. Los nombres por código están en la tabla de miembros más abajo) |
| TAG ID | `0x00FL~0x013L` |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 15~19 |
| Kind | Reference · clasificación: declaración |
| Lado Hugo | `reference/geul-sidx.md` |

## Miembros {#구성원}

Esta página trata un conjunto del sistema 5Q, cinco códigos a la vez. La cuantificación es el desplazamiento dentro de la sección `C % 5` ([Reference](_index.md#quantifier)). Hay un documento de Codec por código. Los campos de los cinco documentos de Codec son iguales; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Cuantificación | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |

GEUL-SIDX es un Reference de declaración que señala un objeto mediante un GEUL SIDX (Semantic-aligned Index). El SIDX es un identificador que lleva significado (tipo, atributo) en los propios bits.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[TAG de extensión de Length]
SIDX              todo el resto
```

- El Quantifier es igual que en los demás Codec de declaración. Si es Variable, es una variable anónima de ese tipo (Variable en [Reference](_index.md)). La cuantificación se hace solo con el código 5Q (`0x00FL~0x013L`, `C % 5`). No se introduce cuantificación en el valor SIDX.
- El documento de especificación declara el SIDX como un único campo de valor en bruto de ancho restante. Se cambiará cuando se fije la regla de ancho.

## Ejemplo {#예시}

| SIDX | WORD sequence |
|---|---|
| (no normativo) 64 bits `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## Criterio de asignación {#배정-방침}

- Su función es distinta de la de [GEUL](0x00AL-geul.md). GEUL es un ID de identidad que se asigna por lo general en orden (auto increment), y GEUL-SIDX es una dirección semántica que da valores cercanos a objetos de significado cercano.
- El grado de cercanía se fija con estadísticas a partir de los datos de uso acumulados. Antes de que se reúnan las estadísticas se usa el GEUL ID y, tras asignar el SIDX, se unen el GEUL y el GEUL-SIDX del mismo objeto con [SAME-NODE](../edge/0x0A1L-same-node.md).

## Problemas abiertos {#열린-문제}

- **Ancho.** Se fijará viendo las estadísticas. Se estudian 4 WORD (64 bits), 16 WORD, etc. En el SIDX el significado está en los bits altos, así que no se puede usar tal cual la regla del «ancho más corto» de los demás Codec de declaración (sin `0x0000` inicial). Por eso será un ancho fijo (o un ancho fijo por subformato). Hasta que se fije, el documento de especificación declara el SIDX como valor en bruto de ancho restante.
- **Estabilidad de la asignación.** En Reference, si el valor entero es igual es el mismo objeto, y un ID asignado no se reutiliza. Para no mover un SIDX ya asignado aunque cambien las estadísticas, hace falta una asignación append-only (asignación dispersa que deja libres posiciones cercanas en significado). Si hubiera que mover con frecuencia, se decide si definir el SIDX no como identificador permanente sino como un índice atado a una edición del registro.
- **Unicidad.** Si el SIDX se genera por significado en bits y puede colisionar, no concuerda con la premisa de que «si el valor entero es igual, es el mismo objeto». Al asignar se resuelven las colisiones para garantizar la unicidad.
- Formato de publicación del libro de códigos y del registro.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x000000F0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

Lo anterior es el documento de Codec de `GEUL-SIDX-IDENTIFIED` (`0x00FL`). En los documentos de Codec de los demás miembros (`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`) solo difieren el Codec ID del DOC-ID, el destino de DECLARE y el nombre asociado en `#1` (BIND).
