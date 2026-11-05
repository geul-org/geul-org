---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL es un Reference de declaración que señala un objeto mediante un ID emitido por este documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `LOCAL` (grupo 5Q. Los nombres por código están en la tabla de miembros más abajo) |
| TAG ID | `0x005L~0x009L` |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 5~9 |
| Kind | Reference · clasificación: declaración |
| Lado Hugo | `reference/local.md` |

## Miembros {#구성원}

Esta página trata un conjunto del sistema 5Q, cinco códigos a la vez. La cuantificación es el desplazamiento dentro de la sección `C % 5` ([Reference](_index.md#quantifier)). Hay un documento de Codec por código. Los campos de los cinco documentos de Codec son iguales; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Cuantificación | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |

LOCAL es un Reference de declaración que señala un objeto mediante un ID emitido por este documento. Referencia objetos dentro del documento sin Issuer externo. Para señalarlo desde fuera del documento, se pone en el documento el Meta [DOC-ID](../meta/0x1C7L-doc-id.md) y otro documento lo señala con un Reference de designación.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[TAG de extensión de Length]
LOCAL ID          unsigned big-endian del ancho más corto
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Los Codec son `0x005L` (Identified), `0x006L` (Generic), `0x007L` (Free-choice), `0x008L` (Universal) y `0x009L` (Variable). El TAG WORD de Identified es `0000 0000 0101 LLLL`.
- Sigue la regla común de Reference de escribir el ID de destino con el menor número de WORD posible.

## Edge Id {#edge-id}

- El LOCAL que es el primer elemento del Payload de un Edge es la declaración del Edge Id de ese Edge ([Edge](../edge/_index.md)). Para declarar un Edge Id solo se usa LOCAL Identified (`0x005L`).
- Un LOCAL en cualquier otra posición del Payload de un Edge es una mención. Los objetos de este documento se escriben como LOCAL en cada mención. No existe un código de designación aparte para señalar objetos de este documento.

## Asignación de identificadores {#식별자-할당}

- El ID es un entero y lo asigna el codificador. El tamaño del número y el orden de asignación no significan nada salvo la identidad.
- **UNIQUE (obligatorio).** En un documento, un LOCAL ID señala un solo objeto. Un Edge Id se declara una sola vez por documento (los Edge de HEAD y los de BODY comparten un único espacio de números). Si hay dos o más Edge que declaran el mismo Edge Id, es invalid.
- **AUTO INCREMENT (recomendado).** El nuevo ID se asigna como el máximo de los ID asignados hasta ahora en ese documento + 1, y crece en el orden del documento. Lo mismo vale a través de las versiones (se crea con un valor mayor que el de los ID eliminados). Es solo una recomendación, no una condición de validez; un documento que no crezca de ese modo también es valid. El decodificador no se apoya en el tamaño ni en la continuidad de los ID.
- El ID `0` no se asigna. No señala ningún objeto y tampoco se usa como Edge Id. Los ID de destino se asignan desde `1`.
- Un documento se señala, dentro o fuera de sí mismo, únicamente con un [DOC-POINTER](0x041L-doc-pointer.md) (a sí mismo, con el DOC-POINTER de su propio `DOC-ID`). También a un documento se le pueden añadir `BIND`, `LABEL` y Edge de veredicto.
- El propio Issuer se señala con [ISSUER-POINTER](0x040L-issuer-pointer.md). El ID de documento `0` es el documento índice de definición de términos del Issuer.
- Los Codec que dan significado al `0` de una posición de componente («ninguno» en REF y en los Edge de ejecución de [TOULMIN](../toulmin/_index.md), «documento completo» en el Target de [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) de HEAD) siguen las reglas de ese Codec. Es un convenio interno de ese Codec, distinto del [marcador de posición](../slot-marker.md).
- Un ID ya asignado no se reutiliza en el mismo documento.
- Siempre se usa el ancho mínimo capaz de representar el valor.

## Identidad y ámbito {#동일성과-범위}

- En un mismo documento, si el valor entero del LOCAL ID es igual, es el mismo objeto. El ancho de la codificación no forma parte de la identidad.
- Un LOCAL Identified representa un objeto identificado. No se usa con fines de anónimo, no especificado, null o sentinel. Decir que hay un valor pero se ignora cuál (UNKNOWN-VALUE) o que no hay valor (NO-VALUE) se escribe como [marcador de posición](../slot-marker.md) en el campo que acepta ese marcador.
- Dos LOCAL ID distintos son solo dos Reference distintos; no significa que los objetos de la realidad sean distintos.
- La identidad de LOCAL no se extiende fuera del documento. El mismo número en otro documento no tiene relación.
- El LOCAL Variable (`0x009L`) es una variable de discurso con nombre (Variable en [Reference](_index.md)).

## Fusión {#병합}

Al fusionar varios documentos en uno, se crea para cada documento original una tabla de correspondencia `old ID → new ID`, se reasignan todos los LOCAL ID con los ID del nuevo documento y se cambian todas las referencias.

- Los ID que eran iguales en el mismo documento original deben seguir siendo iguales tras la fusión.
- El mismo número en documentos originales distintos no tiene relación y no se unifica automáticamente en el mismo Reference.
- Si queda aunque sea un LOCAL que no se pudo cambiar, se rechaza la fusión.

## Validez {#유효성}

Las siguientes codificaciones o asignaciones son invalid.

- Codificación non-minimal con un WORD `0x0000` inicial (excepción: el `0x0000` de 1 WORD del valor 0)
- Que el Codec en la posición de declaración de Edge Id no sea Identified (`0x005L`) o que el ID sea `0`
- Asignar un mismo ID a objetos distintos en el mismo documento
- Declarar el mismo Edge Id dos o más veces en el mismo documento

## Ejemplo {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000050/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

Lo anterior es el documento de Codec de `LOCAL-IDENTIFIED` (`0x005L`). En los documentos de Codec de los demás miembros (`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`) solo difieren el Codec ID del DOC-ID, el destino de DECLARE y el nombre asociado en `#1` (BIND).
