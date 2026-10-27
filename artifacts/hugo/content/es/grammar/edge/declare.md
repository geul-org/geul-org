---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE es un Edge de afirmación que declara la composición del Payload de un Codec (Codec 0x1B). Junto con FIELD, ENUM y CODEC forma el vocabulario con el que se escriben los documentos de especificación de Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE es un Edge de afirmación que declara la composición del Payload de un Codec. Codec `0x1B`.

Junto con [FIELD](/es/grammar/edge/field/) (`0x1C`), [ENUM](/es/grammar/edge/enum/) (`0x1D`) y [CODEC](/es/grammar/edge/codec/) (`0x1E`), es el vocabulario con el que se escriben las especificaciones de Codec ([Documento de especificación de Codec](/es/grammar/codec-spec/)). El layout de los cuatro Edge viene integrado en el decodificador. Cada documento de especificación de Codec escrito con este vocabulario es un documento ordinario. Con una sola especificación se hacen a la vez la validación, la descomposición y la visualización (visor). El visor no tiene código para cada Codec, sino que dibuja según la especificación.

## Layout

```
TAG WORD          0001 0LLL L001 1011
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Destino           1 WORD. Del TAG WORD del Codec declarado solo se usan las posiciones de Kind y Codec (LLLL = 0)
[Issuer y número de formato] cuando el destino es un formato Issuer. Mismo layout que el TAG de extensión de Codec
```

- La lista de campos no se pone en DECLARE. Cada [FIELD](/es/grammar/edge/field/) apunta a su DECLARE, y el orden de esos FIELD dentro del documento es el orden de los campos del Payload.

## Reglas de interpretación

Son las reglas para leer y notar un registro según la especificación del Codec.

- Un campo de valor crudo se lee con el número fijo de WORD que declara su FIELD. Un campo puede ser de valor crudo restante (ancho `0xFFFF`); se lee lo que queda de WORD menos los anchos de los campos fijos que lo siguen. Detrás del campo restante solo se ponen valores crudos de ancho fijo.
- Un campo de registro empieza con un TAG WORD y se lee tanto como indique la Length de ese TAG.
- Un campo de valor crudo es un entero sin signo big-endian de n WORD. Se nota como `0x` + hex de ancho×4 dígitos, y si hay un ENUM con el mismo valor, se anota también su nombre BIND.
- El significado de un campo de registro lo fija la especificación de Codec de ese registro. Los valores que necesitan interpretación, como signo, decimales o fechas, se ponen como registros Value y no como valores crudos.

No hay otras reglas de frontera. Un Codec con dos o más valores crudos variables, con un registro o campo variable después de un valor crudo variable, o cuyo ancho de valor crudo cambie según otro campo o según el estado del documento, no se puede declarar con este vocabulario. En esos layouts se envuelve la parte variable en un registro para que quede una sola (por ejemplo, el firmante de SIGNATURE es un registro Reference).

## Validez

- El Kind del destino es uno de Reference, Value, Edge o Meta. El Codec de Reference ocupa la posición `CCCC` y el Quantifier se deja en 0.
- Un [marcador de posición](/es/grammar/reference/slot-marker/) (Codec de Reference `0000`) no puede ser destino de DECLARE. Viene integrado en el decodificador (capa 0).
- El Edge Id de un Edge no se declara con FIELD. Es implícito, por ser el primer elemento de todo Edge ([Edge](/es/grammar/edge/)).
- Los campos de un DECLARE son los FIELD que apuntan a él, y pueden ser 0. Un FIELD pertenece a un solo DECLARE. Aunque dos campos tengan la misma forma, cada DECLARE tiene sus propios FIELD.
- DECLARE no tiene nada más que el destino (y, si el destino es un formato Issuer, el Issuer y el número de formato).
- El cursor tras leer los campos en orden debe coincidir exactamente con el final del registro. Si sobra o falta, ese registro viola la especificación.
- En un documento no se declara dos veces el mismo destino.
- Las variantes con campos finales distintos no se usan como ramas. Cada Codec tiene su propio DECLARE.

## Documento de especificación

- El documento de especificación de un código directo es un documento ordinario del Issuer de GEUL `0x0000`. El ID del documento es el TAG WORD del destino ampliado a 4 WORD (`0x1018` → `0x0000000000001018`), y se publica igual que los documentos de otros Issuer (ID de versión, `versions.geul`) ([Documento de especificación de Codec](/es/grammar/codec-spec/)).
- Un documento de especificación tiene un DECLARE, y su destino debe ser igual al TAG WORD del ID del documento. `DOC-ID` es un DOC-POINTER (`0x0000`, el ID de ese documento, `0`).

## Nombres

- El nombre del Codec se liga al Edge Id de DECLARE con [BIND](/es/grammar/edge/bind/) (por ejemplo, `PUBLICATION`). Todo UTF8-TEXT que se pone a DECLARE, FIELD, ENUM y CODEC se hace con BIND, y no se pone con otros Edge como LABEL.
- Los nombres de campos y de enum se ligan igualmente a FIELD y ENUM.

## Ejemplo

Documento de especificación de PUBLICATION (Edge `0x18`) `geul.org/publication`: tras el Edge Id, un registro DOC-POINTER y un hash de contenido de 16 WORD.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, registro      (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, valor crudo 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + destino 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + ancho 1 = 6 WORD (`LLLL = 0101`). El Kind y Codec que acepta se ponen aparte con [CODEC](/es/grammar/edge/codec/) (`0038` = DOC-POINTER).
- Un campo opcional se declara con el destino CODEC `0000`. En la posición omitida se escribe ABSENT (`0x0000`) (campo opcional de [CODEC](/es/grammar/edge/codec/)).
- El orden de los campos es el orden en que FIELD #2 y #4 aparecen en el documento. Los Edge Id no tienen que ser consecutivos (LOCAL AUTO INCREMENT es una recomendación).

## Problemas abiertos

- Repetición. Una composición en la que un valor crudo anterior fija la cantidad, como "argumentos × número de argumentos" de `CALL`. Por ahora no se puede declarar.
- Cómo declarar un Codec con subformato (TAG propio del Codec), como WORLD.
- Cómo encontrar el documento de especificación de un formato Issuer (Issuer y número de formato → dirección del documento de especificación).
- A qué conjunto de versiones de los documentos de especificación de códigos directos se refiere `SPEC-VERSION`.

## Páginas relacionadas

- [FIELD](/es/grammar/edge/field/), [ENUM](/es/grammar/edge/enum/), [CODEC](/es/grammar/edge/codec/), [BIND](/es/grammar/edge/bind/)
- [Edge](/es/grammar/edge/), [Documento de especificación de Codec](/es/grammar/codec-spec/)
