---
title: "Estructura del registro"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Los datos GEUL son una sucesión de registros."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Los datos GEUL son una sucesión de registros. Todo registro empieza con un TAG WORD.

## Layout del registro {#레코드-레이아웃}

```
TAG WORD (16 bits)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[TAG de extensión de Length]
[TAG de extensión de Codec]
[TAG propio del Codec]
Payload
```

- El TAG WORD es `000K KKKC CCCC LLLL`. Los 4 bits superiores `KKKK` son la sección `S = w >> 9`, y una sección tiene 32 casillas. `C` es el desplazamiento de 5 bits dentro de la sección, `(w >> 4) & 0x1F`.
- El TAG ID se escribe `0x000L`. Los tres primeros dígitos son la posición de Codec de 9 bits (`w >> 4`) que reúne la sección y `C`, y `L` es la posición de Length. El valor real del WORD escribe un número en la posición L (por ejemplo, TRIPLE es `0x0AAL` y el TAG WORD de un TRIPLE de 10 WORD es `0x0AA9`).
- Los TAG de extensión se ponen solo en el orden indicado. El TAG de extensión de Length va siempre justo después del TAG WORD.
- La composición del TAG propio del Codec y del Payload la fija la especificación de cada Codec. La longitud del TAG propio del Codec no se anota en el TAG WORD, porque para interpretar el Payload hace falta el codebook de todos modos.
- Un Codec con subformatos indica el subformato con 1 WORD de TAG propio del Codec (Edge WORLD, etc.).

## Orden de bytes {#바이트-순서}

- La serialización canónica es big endian.
- Los campos de bits se disponen empezando por el bit más significativo.
- Dentro de un WORD se escribe primero el byte superior, y en un valor de varios WORD se escribe primero el WORD superior.
- La representación en memoria la decide libremente la implementación.

## Kind (rango de secciones) {#kind-섹션-구간}

| Sección | Kind | TAG ID | Definición |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | Señala un objeto. Identifica el objeto con el Codec y el ID del objeto |
| 3·4 | Value | `0x060L~0x09FL` | Contiene el propio valor. El Codec determina la interpretación del Payload |
| 5~13 | Edge | `0x0A0L~0x1BFL` | Une otros registros como componentes. El Codec determina el papel y el orden de los componentes |
| 14·15 | Meta | `0x1C0L~0x1FFL` | Habla sobre el documento y los registros |

- El Kind se determina con un solo rango de sección: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, el resto Meta. No hay excepciones.

- El Kind es una propiedad inmutable del Codec. Un Codec ya asignado no cambia de Kind.
- Value y Edge tienen el mismo formato «Codec + Payload». Solo Edge tiene otros registros como componentes.
- Reference reparte en tablas de códigos los marcadores, los punteros, el sistema 5Q y REFERENCE-ISSUER. La cuantificación está en el código del sistema. La cuantificación de REFERENCE-ISSUER la fija el documento del Issuer ([Reference](reference/_index.md)).

## Length (4 bits) {#length-4비트}

Length es el **número total de WORD** que ocupa el registro. Incluye el TAG WORD, los TAG de extensión, el Payload y el relleno del último WORD.

| Valor | Significado |
|---|---|
| `0000`~`1101` | 1~14 WORD (valor + 1) |
| `1110` | Longitud extendida 1: el siguiente 1 WORD contiene el número total de WORD (15~65.535) |
| `1111` | Longitud extendida 2: los siguientes 2 WORD contienen el número total de WORD (65.536~2³²−1) |

- De 1 a 14 WORD se escribe obligatoriamente con longitud directa. Una notación más ancha no es forma canónica.
- El número total de WORD de la longitud extendida incluye el propio TAG de extensión de Length.
- No hay registros de más de 2³²−1 WORD.
- Un registro de 1 WORD es un solo TAG WORD sin Payload. Solo se usa cuando la especificación del Codec lo permite (por ejemplo, Meta `BODY`, `END`, cadena de bytes vacía, marcador de posición).
- Aunque no haya codebook, se puede saltar un registro con `posición del siguiente registro = inicio del registro actual + Length`.

## Codec (sección y C, 9 bits) {#codec-섹션과-c-9비트}

| TAG ID | Nombre | Significado |
|---|---|---|
| Parte inicial de cada zona de Kind | Código directo | El Codec queda determinado solo por el TAG WORD |
| `0x05DL`, `0x09DL`, `0x1BDL` | REFERENCE-ISSUER-2WORD, VALUE-ISSUER-2WORD, EDGE-ISSUER-2WORD | En el TAG de extensión de Codec, Issuer de 2 WORD y número de Codec de 2 WORD |
| `0x05EL`, `0x09EL`, `0x1BEL` | REFERENCE-ISSUER-4WORD, VALUE-ISSUER-4WORD, EDGE-ISSUER-4WORD | En el TAG de extensión de Codec, Issuer de 4 WORD y número de Codec de 2 WORD |
| `0x05FL`, `0x09FL`, `0x1BFL` | REFERENCE-ISSUER-16WORD, VALUE-ISSUER-16WORD, EDGE-ISSUER-16WORD | En el TAG de extensión de Codec, Issuer de 16 WORD y número de Codec de 2 WORD |

- **Las tres últimas casillas de cada zona de Kind son ISSUER.** El ancho del Issuer son los 2 bits inferiores de C (`01` 2 WORD, `10` 4 WORD, `11` 16 WORD). Meta no tiene formato de Issuer.
- La `C` de un código directo es propia de cada sección. Aunque el valor de `C` sea el mismo, si la sección es distinta, el Codec es distinto. El Codec ID de un código directo es todo el TAG WORD (L=0), por lo que lleva el Kind.
- El número de Codec de Issuer es un único espacio por Issuer, independientemente del Kind. El Issuer lo asigna sin solapamientos dentro de su `codecs/` ([direcciones de publicación y lista de versiones](publishing.md#id-표기)).
- Un Codec que no es código directo es un par `(Issuer, número de Codec)`. El número de Codec lo define ese Issuer ([Issuer y publicación](issuer.md)). Un formato de extensión se coloca bajo el Issuer del organismo que lo estableció.
- Un Codec que tiene código directo no se registra aparte como formato de Issuer.
- Los formatos de Issuer existen en Reference, Value y Edge. Meta es una especificación común que solo define GEUL.
- La sección del código directo de Edge (`w >> 9`) es la familia. Los códigos directos de Value y Meta no expresan familia ni clase con bits. El significado del número de Codec lo fija el Issuer.
- Los códigos directos no se pueden recuperar. En el código directo solo se ponen los formatos cuya frecuencia está confirmada.

## Registro de formato Issuer {#issuer-형식-레코드}

```
TAG WORD          código ISSUER (las tres últimas casillas de cada zona de Kind)
[TAG de extensión de Length]
Issuer            2/4/16 WORD (el Codec determina el ancho)
número de Codec   2 WORD. Lo define el Issuer
Payload           lo determina el documento de Codec emitido por el Issuer
```

- El layout de los tres Kind es igual. Si faltan números, se solicita otro Issuer.
- El Payload de un Edge (EDGE-ISSUER) empieza con el Edge Id, como los demás Edge. Por eso el orden es TAG, Issuer, número de Codec, Edge Id, resto del Payload.
- Un decodificador que no conoce el formato llega hasta el Issuer y el número de Codec y salta con Length.

## Cadenas de bytes de longitud variable {#가변-길이-바이트열}

Para los valores cuya longitud es en bytes, como texto, URI, etiquetas de idioma o cadenas de bytes desconocidas, el Codec (o número de Codec) se asigna en **pares par/impar**.

- Si el bit menos significativo del Codec (en un código directo, el bit menos significativo de C) es `0`, el número de bytes es par; si es `1`, impar.
- Número de bytes = `2 × número de WORD del Payload − bit menos significativo`. No hay campo Byte Count.
- Si es impar, el byte inferior del último WORD es un relleno `0x00`. Si no es `0x00`, se rechaza.
- Una cadena de bytes vacía es un registro de 1 WORD (solo el TAG WORD) del Codec par.
- Los valores de tamaño fijo, como UUID, digest o direcciones, no tienen par.

## Ejemplo: leer un TAG WORD {#예-tag-word-읽기}

Leamos `0AA9`.

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, sección 0101 (5, Edge), C 01010, Codec 0x0AAL (TRIPLE), Length 1001 (10 WORD)
```

Este registro es un Edge de 10 WORD y su Codec es TRIPLE. Aunque no haya codebook, se sabe que el siguiente registro está 10 WORD más adelante.

## Marcadores de posición {#자리-표지}

Los TAG WORD `0x0000`, `0x0010` y `0x0020` son registros de 1 WORD de marcadores de posición Reference. No señalan un objeto, sino que ocupan la posición de un campo de registro ([marcadores de posición](slot-marker.md)).

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, sección 0 (Reference), C 0~2, LLLL 0000 (1 WORD)
```

| WORD | Nombre | Significado | Sobre qué habla | Lógica | Supuesto de mundo | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | No escrito | Documento: esta posición no se ha rellenado | Sin aserción | Mundo abierto | sin snak |
| `0x0010` | UNKNOWN-VALUE | Desconocido | Mundo: hay un valor. No se sabe cuál | `∃x. P(s, x)` | La existencia está cerrada, la identidad abierta | `somevalue` |
| `0x0020` | NO-VALUE | Sin valor | Mundo: no hay valor | `¬∃x. P(s, x)` | Cerrado respecto a (s, P, condición de restricción) | `novalue` |

- Ejemplo: si los hijos (P40) son ABSENT, no se sabe cuántos son; si son UNKNOWN-VALUE, uno o más; si son NO-VALUE, cero. Si el instante de finalización (P582) es ABSENT, no se sabe si sigue vigente; si es UNKNOWN-VALUE, terminó pero no se sabe cuándo; si es NO-VALUE, no ha terminado.
- Un marcador solo es válido si la lista de CODEC del campo tiene ese WORD como destino exacto. Con comodines, en campos sin CODEC, en las posiciones de registro de HEAD y BODY y en la posición de Edge Id es invalid ([CODEC](edge/0x0BEL-codec.md)).
- Obligaciones de quien lee:
  1. UNKNOWN-VALUE no es un valor, sino una aserción de existencia. No es igual ni distinto a ningún valor, y dos UNKNOWN-VALUE tampoco se consideran el mismo valor. Los TRIPLE que contienen UNKNOWN-VALUE no se fusionan como duplicados.
  2. NO-VALUE se cierra dentro de la condición de restricción de esa proposición. Si convive con un TRIPLE de valor cuya condición de restricción no se distingue, con el mismo Subject·Predicate·rank, es una contradicción, y el verificador avisa (no rechaza).
  3. El rank se aplica igual. Al elegir el valor representativo (truthy), también los TRIPLE de los dos marcadores son candidatos.
  4. Cuando se usa como valor de QUALIFIER, cambia el sentido de esa restricción (`P582 = UNKNOWN`: terminó, instante desconocido. `P582 = NONE`: no ha terminado).
  5. ABSENT no dice nada sobre el mundo. Un valor que no se pudo trasladar no se escribe como UNKNOWN-VALUE.

## Forma canónica {#정규형}

El mismo contenido debe dar los mismos bytes. Solo así el hash de contenido y la firma quedan determinados de forma única.

- La longitud usa la notación más corta (de 1 a 14 WORD, longitud directa).
- Los enteros se escriben con el ancho más corto. Se sigue la forma canónica que fija la especificación de cada Codec.
- Un registro que no está en forma canónica se rechaza.
- Excepción: en el WORD de destino de [CODEC](edge/0x0BEL-codec.md), `L=1111` mira solo la sección `KKKK`, independientemente del valor de `C`. Se recomienda la primera casilla de la sección (`C = 0`), y no se rechaza otra `C` de la misma sección.
