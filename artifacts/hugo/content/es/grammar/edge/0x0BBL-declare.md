---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE es un Edge de enunciado que declara la composición del Payload de un Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DECLARE` (BIND del documento de especificación `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| Documento de especificación | `0x00000000/codecs/0x00000BB0/` (destino de DECLARE `0BB0`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 27 |
| Kind | Edge · familia: enunciado, grupo: otros |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Declaración de la composición del Payload de un Codec. Kind·Codec de destino |
| Lado Hugo | `edge/declare.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | valor en bruto 1 WORD |  |  |
| 2 | `issuer` | #3 | resto de valor en bruto (`0xFFFF`) |  |  |

DECLARE es un Edge de enunciado que declara la composición del Payload de un Codec. Codec `0x0BBL`.

Junto con [FIELD](0x0BCL-field.md) (`0x0BCL`), [ENUM](0x0BDL-enum.md) (`0x0BDL`) y [CODEC](0x0BEL-codec.md) (`0x0BEL`), es el vocabulario para escribir especificaciones de Codec ([documento de especificación de Codec](../codec-spec.md)). El layout de estos cuatro Edge se integra en el decodificador. Cada documento de especificación de Codec escrito con este vocabulario es un documento ordinario. Una sola especificación sirve para verificar, descomponer y mostrar (visor). El visor no tiene código por cada Codec, sino que dibuja según la especificación.

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
destino           1 WORD. Del TAG WORD del Codec declarado solo se usa la posición del Codec (sección y C) (LLLL = 0)
[Issuer·número de Codec] Al declarar un codec de Issuer. 2 WORD con el Issuer y el número de Codec. Mismo layout que el TAG de extensión de Codec, y los tres Kind son iguales
                  El documento de especificación del propio código ISSUER (Issuer GEUL) solo lleva el destino
```

- La lista de campos no se pone en DECLARE. Cada [FIELD](0x0BCL-field.md) señala su propio DECLARE, y el orden de esos FIELD dentro del documento es el orden de los campos del Payload.

## Reglas de interpretación {#해석-규칙}

Son las reglas para leer y mostrar un registro con la especificación de Codec.

- Un campo de valor en bruto se lee con el número fijo de WORD que declara el FIELD. Un campo puede ser de resto de valor en bruto (ancho `0xFFFF`), y se lee tomando de los WORD restantes los que quedan tras restar los anchos de los campos fijos posteriores. Después de un campo de resto solo se ponen valores en bruto de ancho fijo.
- Un campo de registro empieza con un TAG WORD y se lee tantos WORD como indica el Length de ese TAG.
- Un campo de valor en bruto es un entero sin signo big-endian de n WORD. La notación es `0x` + hex de ancho×4 dígitos, y si existe un ENUM con el mismo valor, se escribe también su nombre BIND.
- El significado de un campo de registro lo fija la especificación del Codec de ese registro. Los valores que requieren interpretación, como signo, decimales o fechas, no se ponen como valor en bruto sino como registro Value.

No hay otras reglas de límite. Un Codec con dos o más valores en bruto variables, con un registro o un campo variable tras un valor en bruto variable, o cuyo ancho de valor en bruto cambia según otro valor de campo o el estado del documento, no puede declararse con este vocabulario. Un layout así deja solo una parte variable envolviéndola en un registro (por ejemplo, el firmante de SIGNATURE es un registro Reference).

## Validez {#유효성}

- El Kind del destino es uno de Reference, Value, Edge o Meta. El documento de especificación de un código directo de GEUL es uno por código. El sistema 5Q de Reference también se declara aparte por cada código de cuantificación (LOCAL Identified `0050`, Generic `0060`, …). Los punteros (`0x040L`, `0x041L`, `0x042L`), los marcadores de posición y el código ISSUER son tal cual ese código. Un codec de Issuer, determinado por el Issuer y el número de Codec tras el código ISSUER, lo define el documento de ese Issuer.
- Los [marcadores de posición](../slot-marker.md) (Reference `0x000L~0x002L`) también son destino de DECLARE. Como no tienen Payload, solo llevan DECLARE sin FIELD. El significado del marcador y las reglas de aceptación se integran en el decodificador (capa 0). Los Codec cuyo layout aún no está fijado (SUPERSEDE-CHAIN, VERDICT, EVIDENCE, etc.) también llevan solo DECLARE.
- El Edge Id de un Edge no se declara con FIELD. Es implícito por ser el primer elemento de todo Edge ([Edge](_index.md)). En EDGE-ISSUER es el primer elemento tras el Issuer y el número de Codec ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- Los campos de un DECLARE son los FIELD que lo señalan, y pueden ser 0. Un FIELD pertenece a un solo DECLARE. Aunque los campos tengan la misma forma, cada DECLARE lleva sus propios FIELD.
- DECLARE no contiene nada más que el destino (y el Issuer·número de Codec de un destino de formato Issuer).
- El cursor tras leer los campos en orden debe coincidir exactamente con el final del registro. Si sobra o falta, ese registro viola la especificación.
- En un documento no se declara dos veces el mismo destino.
- Las variantes con distinto campo final no se usan como ramas. Se pone un DECLARE aparte por cada Codec.

## Documento de especificación {#규격-문서}

- El documento de especificación de un código directo es el documento de codec del Issuer GEUL `0x00000000`. El Codec ID es el TAG WORD de destino (L=0) escrito en 32 bits (`0x0B80` → `0x00000B80`), y se publica en `<Issuer>/codecs/<Codec ID>/` con ID de versión y `versions.geul` ([documento de especificación de Codec](../codec-spec.md)).
- El documento de codec de un codec de Issuer se coloca en `<Issuer>/codecs/<número de Codec>/` de ese Issuer. El número de Codec no se repite dentro de ese Issuer, sin importar el Kind. El intérprete lo trata como error si el Kind del registro y el Kind del destino de DECLARE son distintos ([dirección de publicación y lista de versiones](../publishing.md#id-표기)).
- Un documento de especificación tiene un solo DECLARE, y su destino debe ser igual al TAG WORD del Codec ID. El `DOC-ID` es el [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, ese Codec ID, `0`).

## Nombres {#이름}

- El nombre del Codec se liga al Edge Id de DECLARE con [BIND](0x0A3L-bind.md) (por ejemplo, `PUBLICATION`). Todo UTF8-TEXT que se pone en DECLARE, FIELD, ENUM y CODEC se hace con BIND, y no se pone con otros Edge como LABEL.
- El nombre de un campo y el nombre de un enum también se ligan a FIELD y ENUM de la misma manera.

## Ejemplo {#예시}

El documento de especificación `0x00000000/codecs/0x00000B80/` de PUBLICATION (Edge `0x0B8L`): tras el Edge Id, un registro DOC-POINTER y 16 WORD de hash de contenido.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, registro      (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (lista de versiones de codec)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, valor en bruto 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + destino 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + ancho 1 = 6 WORD (`LLLL = 0101`). El Kind·Codec que acepta se pone aparte con [CODEC](0x0BEL-codec.md) (`0410` = DOC-POINTER, `0420` = CODEC-POINTER).
- Un campo opcional se declara con el destino CODEC `0000`. En el lugar omitido se escribe ABSENT (`0x0000`) ([CODEC](0x0BEL-codec.md), campo opcional).
- El orden de los campos es el orden en que FIELD #2 y #4 están colocados en el documento. Los Edge Id no tienen que ser consecutivos (LOCAL AUTO INCREMENT es una recomendación).

## Problemas abiertos {#열린-문제}

- Repetición. Composiciones en que un valor en bruto anterior fija la cantidad, como «argumentos × número de argumentos» de `CALL`. Por ahora no se puede declarar.
- Cómo declarar un Codec con subformatos (TAG propio del Codec), como WORLD.
- A qué conjunto de versiones de los documentos de especificación de códigos directos se refiere `SPEC-VERSION`.

## Páginas relacionadas {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [documento de especificación de Codec](../codec-spec.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000BB0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
