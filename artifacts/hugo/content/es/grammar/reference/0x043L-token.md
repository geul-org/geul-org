---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN es un Reference de 2 WORD que señala una entrada del vocabulario de tokens de GEUL. Al unir los bytes de los registros TOKEN consecutivos se obtiene el texto original."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | TOKEN-0 | TOKEN-1 |
|---|---|---|
| Nombre | `TOKEN-0` (BIND `TOKEN-0` del documento de especificación) | `TOKEN-1` (BIND `TOKEN-1` del documento de especificación) |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| Documento de especificación | `0x00000000/codecs/0x00000430/` (destino de DECLARE `0430`) | `0x00000000/codecs/0x00000440/` (destino de DECLARE `0440`) |
| Sección | 2 `0010` (Reference otros), desplazamiento dentro de la sección C = 3 | 2 `0010`, C = 4 |
| Kind | Reference · clasificación: declaración | Reference · clasificación: declaración |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| ID de token | `0`~`65.535` | `65.536`~`131.071` |
| Lado Hugo | `reference/token.md` | `reference/token.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valor en bruto de 1 WORD |  | Uno por token. Se rellena al publicar la edición 1 del vocabulario |

TOKEN es un Reference que señala una entrada del vocabulario de tokens de GEUL. El vocabulario es un vocabulario BPE (Byte Pair Encoding) entrenado con coreano e inglés, y una entrada es una secuencia de bytes. Si se unen en orden las secuencias de bytes de los registros TOKEN consecutivos, se obtienen los bytes del texto original.

- Si el vocabulario cabe en 65.536 entradas, solo se usa TOKEN-0. Si crece más allá, las entradas sobrantes van en TOKEN-1. Aunque no se use TOKEN-1, el nombre del primer Codec es TOKEN-0.
- Cada token se escribe como un registro. Como el tamaño está fijado en 2 WORD, el k-ésimo registro de una secuencia de tokens está a 4k bytes del inicio.

## Layout {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, 2 WORD en total
Payload WORD 1st (16 bits)           ID de token (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, 2 WORD en total
Payload WORD 1st (16 bits)           ID de token − 65.536 (uint16)
```

- Código: códigos directos de Reference `0x043L`·`0x044L` (sección 2).
- El Payload es el ID de destino. Según el [layout común de Reference](_index.md), es un entero sin signo big-endian escrito con el ancho más corto, y como el ID de destino es siempre `0`~`65.535`, el Payload es siempre 1 WORD (`0` es `0x0000`).
- No hay cuantificación (la cuantificación solo se lee en el sistema 5Q).

## Interpretación y validez {#해석과-유효성}

- El ID de destino de cada Codec es el valor del Payload. El ID de token dentro de todo el vocabulario es el ID de destino en TOKEN-0, y 65.536 + el ID de destino en TOKEN-1.
- La representación oficial de un token es el documento de especificación de su Codec. Para cada ID de token hay un [ENUM](../edge/0x0BDL-enum.md) en el FIELD `code`, y el nombre ligado por [BIND](../edge/0x0A3L-bind.md) a ese Edge Id del ENUM es la secuencia de bytes del token. El valor de código ENUM de TOKEN-1 es el valor del Payload (ID de token − 65.536).
- El vocabulario es una lista cerrada. Un ID de token sin ENUM en el documento de especificación es invalid. Esta regla del Codec prevalece sobre la regla general de ENUM («un valor de código no declarado no es un error»).
- **Tokens de byte:** Los ID de token `0`~`255` son un solo byte. El ID de token es el propio valor del byte. Para un carácter que no está en el vocabulario, como los ajenos al coreano y al inglés, sus bytes UTF-8 se escriben como tokens de byte. El nombre BIND de un token de byte es el nombre de máquina `<0x00>`~`<0xFF>`, y su significado lo fija esta regla.
- **Otros tokens:** La secuencia de bytes es UTF-8 válido, y el nombre BIND es esa secuencia de bytes tal cual.
- **Decodificación:** Se lee la secuencia de registros TOKEN desde el principio y se unen las secuencias de bytes de cada token. Los caracteres UTF-8 formados por tokens de byte consecutivos también se restauran con esta unión. El resultado es idéntico, byte a byte, al texto antes de codificar.
- **Codificación:** El modo de dividir el texto en una secuencia de tokens (la regla de división y el orden de fusión) depende de la edición del vocabulario. El mismo texto puede dar una secuencia de tokens distinta con otra edición del vocabulario. El resultado de la decodificación es el mismo con independencia de la edición.
- **Edición:** La edición del vocabulario es la versión del documento de especificación. Cada edición anota los hashes del archivo del vocabulario y del registro de entrenamiento como [SOURCE](../edge/0x0C0L-source.md) del HEAD del documento de especificación. Cuando haya que indicar la edición que generó una secuencia de tokens, se deja junto con ella esa versión ([CODEC-POINTER](0x042L-codec-pointer.md) (`0x00000000`, `0x00000430`, ID de versión `n`)).
- **Solo por adición:** Una edición nueva solo añade ENUM y BIND al final. La secuencia de bytes de un ID de token ya asignado no se cambia, ni se borra ni se reescribe. Por eso toda edición es un superconjunto de la anterior, y una secuencia de tokens hecha con una edición anterior se decodifica igual con una posterior. Si el vocabulario se reentrena desde cero y cambian los significados, no se usa este Codec, sino que se recibe un número de Codec nuevo.
- Como un token es un Reference, puede ser sujeto de [BIND](../edge/0x0A3L-bind.md), [LABEL](../edge/0x0A4L-label.md) y [TRIPLE](../edge/0x0AAL-triple.md) (por ejemplo, la frecuencia de aparición de un token, su idioma).

## Longitud {#길이}

- El total son exactamente 2 WORD, la suma de 1 WORD de TAG y 1 WORD de Payload, y usa la longitud directa `LLLL=0001`. No hay TAG de extensión de Length, TAG de extensión de Codec ni TAG específico del Codec.
- Si el Payload no es exactamente 1 WORD, se rechaza.

## Ejemplo {#예시}

Antes de publicar la edición 1 del vocabulario, los tokens ordinarios aún no tienen número. Los tokens de byte tienen número fijado por la regla.

| Token | ID de token | WORD completos |
|---|---|---|
| byte `0xE3` | `227` | `0431 00E3` |
| byte `0x80` | `128` | `0431 0080` |

## Problemas abiertos {#열린-문제}

- Publicación de la edición 1 del vocabulario. Tras terminar el entrenamiento y la verificación, se rellenan ENUM y BIND en el documento de especificación.
- Formato para llevar una secuencia de tokens en un documento. No se ha decidido qué campo de Edge o de Value recibe una secuencia de registros TOKEN.
- Forma canónica de la codificación. Cómo escribir en el documento de especificación la regla de división y el orden de fusión, y si se fija una única secuencia de tokens para el mismo texto.
- Interpretación entre ediciones. Cuando el lector encuentra un ID de token más nuevo que la edición que tiene, si lo descarta como invalid o conserva el valor original y lo trata como «token desconocido».

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Documento de especificación de Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- Registro de la misma forma: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## Texto original del documento de especificación {#규격-문서-원문}

El documento de especificación `0x00000000/codecs/0x00000430/` se publicará junto con la edición 1 del vocabulario. Todavía no está publicado. Su forma es la siguiente (a modo de explicación).

```
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "code"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
…
```
