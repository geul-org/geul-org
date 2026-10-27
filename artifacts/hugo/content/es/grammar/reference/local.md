---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL es un Reference de declaración que apunta a un objeto con un ID emitido por este documento. El Edge Id también es un LOCAL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL es un Reference de declaración que apunta a un objeto con un ID emitido por este documento. Hace referencia a objetos del documento sin un Issuer externo y no tiene sentido fuera del documento. Para apuntar a él desde fuera, el documento lleva el Meta [DOC-ID](/es/grammar/meta/declaration/doc-id/) y los demás documentos lo señalan con un Reference que señala.

## Layout

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[TAG de extensión de Length]
LOCAL ID          unsigned big-endian del ancho más corto
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- El TAG WORD es `0000 0 LLLL 0001 QQQ`. Con Identified (`000`), los 7 bits inferiores son `0x08`.
- Sigue la regla común de Reference de escribir el ID de destino con el menor número de WORD.

## Edge Id

- El LOCAL que es el primer elemento del Payload de un Edge es la declaración del Edge Id de ese Edge ([Edge](/es/grammar/edge/)). El LOCAL que declara un Edge Id usa solo el Quantifier `000`.
- Un LOCAL en las demás posiciones del Payload del Edge es una mención. Los objetos de este documento se escriben con LOCAL cada vez que se mencionan. No hay un código de señalamiento aparte para los objetos de este documento.

## Asignación de identificadores

- El ID es un entero y lo asigna el codificador. El tamaño del número y el orden de asignación no tienen más significado que la identidad.
- **UNIQUE (obligatorio).** En un documento, un LOCAL ID apunta a un solo objeto. Un Edge Id se declara una sola vez por documento (los Edge del HEAD y los del BODY comparten un espacio de numeración). Si hay dos o más Edge que declaran el mismo Edge Id, es invalid.
- **AUTO INCREMENT (recomendado).** El ID nuevo se asigna como el máximo de los ID asignados hasta ahora en ese documento + 1, y se deja que crezca en el orden del documento. Lo mismo a lo largo de las versiones (se crea con un valor mayor que el de los ID eliminados). Es solo una recomendación y no una condición de validez; un documento cuyos ID no crecen también es valid. El decodificador no se apoya en el tamaño ni en la continuidad de los ID.
- El ID `0` no se asigna. No apunta a ningún objeto ni se usa como Edge Id. Los ID de destino se asignan desde `1`.
- El documento en sí, tanto desde dentro como desde fuera del documento, se señala solo con un [DOC-POINTER](/es/grammar/reference/doc-pointer/) (uno mismo es el DOC-POINTER de su propio `DOC-ID`). A un documento también se le pueden añadir `BIND`, `LABEL` y Edge de juicio.
- El propio Issuer se señala con [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/). El ID de documento `0` es el documento índice de definición de términos del Issuer.
- Los Codec que dan sentido a `0` en la posición de un componente (el «ausente» de los REF de [TOULMIN](/es/grammar/edge/toulmin/) y de los Edge de ejecución, el «documento entero» del Target de un [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del HEAD) siguen la regla de ese Codec. Es un acuerdo dentro de ese Codec, distinto de los [marcadores de posición](/es/grammar/reference/slot-marker/).
- Un ID ya asignado no se reutiliza en el mismo documento.
- Siempre se usa el ancho mínimo que pueda representar el valor.

## Identidad y alcance

- Si el valor entero de un LOCAL ID es el mismo en un mismo documento, es el mismo objeto. El ancho de la codificación no forma parte de la identidad.
- Un LOCAL Identified representa un objeto identificado. No se usa como anónimo, sin especificar, null ni sentinel. Decir que hay un valor pero se ignora cuál (UNKNOWN-VALUE) o que no hay valor (NO-VALUE) se escribe con un [marcador de posición](/es/grammar/reference/slot-marker/) en un campo que lo acepte.
- LOCAL ID distintos son solo Reference distintos, y no significa que los objetos de la realidad sean distintos.
- La identidad de un LOCAL no se extiende fuera del documento. El mismo número en otro documento no guarda relación.
- Un LOCAL Variable (`100`) es una variable del discurso con nombre (Variable de [Reference](/es/grammar/reference/)).

## Fusión

Al fusionar varios documentos en uno, se crea para cada documento original una tabla de correspondencia `old ID → new ID`, se reasignan todos los LOCAL ID con los ID del documento nuevo y se cambian todas las referencias.

- Los ID que eran iguales en un mismo documento original deben seguir siéndolo tras la fusión.
- El mismo número en documentos originales distintos no guarda relación, y no se fusionan automáticamente como el mismo Reference.
- Si queda aunque sea un LOCAL sin cambiar, se rechaza la fusión.

## Validez

Las siguientes codificaciones o asignaciones son invalid.

- Codificación non-minimal con WORD `0x0000` iniciales (excepción: el 1 WORD `0x0000` del valor 0)
- Que el Quantifier de la posición de declaración del Edge Id no sea `000` o que el ID sea `0`
- Asignar un ID a objetos distintos en el mismo documento
- Declarar el mismo Edge Id dos o más veces en el mismo documento

## Ejemplo

| LOCAL ID | Secuencia de WORD |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1, Variable | `008C 0001` |

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [DOC-POINTER](/es/grammar/reference/doc-pointer/), [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/es/grammar/reference/external-pointer/)
- [Edge](/es/grammar/edge/)
