---
title: "Registro y TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Todo registro empieza con un TAG WORD de 16 bits. Un Prefix de 3 bits, un Kind de 2 bits, un Length de 4 bits y un Codec de 7 bits fijan el tipo y la longitud del registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Los datos GEUL son una secuencia de registros. Todo registro empieza con un TAG WORD.

## Layout del registro

```
TAG WORD (16 bits)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[TAG de extensión de Length]
[TAG de extensión de Codec]
[TAG propio del Codec]
Payload
```

- El TAG WORD es `000K KLLL LCCC CCCC`.
- Los TAG de extensión se colocan solo en el orden indicado arriba. El TAG de extensión de Length va siempre justo después del TAG WORD.
- La composición del TAG propio del Codec y del Payload la fija la especificación de cada Codec. La longitud del TAG propio del Codec no se anota en el TAG WORD, porque para interpretar el Payload de todos modos hace falta el libro de códigos.
- Los Codec con subformato indican el subformato con 1 WORD de TAG propio del Codec (Edge WORLD, etc.).

## Orden de bytes

- La serialización canónica es big endian.
- Los campos de bits se disponen empezando por el bit más significativo.
- Dentro de un WORD se escribe primero el byte superior, y en un valor de varios WORD se escribe primero el WORD superior.
- La representación en memoria la decide libremente la implementación.

## Kind (2 bits)

| Valor | Kind | TAG WORD | Definición |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | Apunta a un objeto. El objeto se identifica con el Codec y el ID de destino |
| `01` | Value | `0000 1LLL LCCC CCCC` | Contiene un valor en sí. El Codec fija la interpretación del Payload |
| `10` | Edge | `0001 0LLL LCCC CCCC` | Enlaza otros registros como componentes. El Codec fija el rol y el orden de los componentes |
| `11` | Meta | `0001 1LLL LCCC CCCC` | Habla sobre el documento y sobre otros registros |

- El Kind es una propiedad inmutable del Codec. Un Codec ya asignado no cambia de Kind.
- Value y Edge tienen el mismo formato "Codec + Payload". Solo el Edge tiene otros registros como componentes.
- Reference divide los 7 bits de Codec en 4 bits de Codec y 3 bits de Quantifier ([Reference](/es/grammar/reference/)).

## Length (4 bits)

Length es el **número total de WORD** que ocupa el registro. Incluye el TAG WORD, los TAG de extensión, el Payload y el relleno del último WORD.

| Valor | Significado |
|---|---|
| `0000`~`1101` | 1~14 WORD (valor + 1) |
| `1110` | Longitud extendida 1: el número total de WORD en el siguiente 1 WORD (15~65.535) |
| `1111` | Longitud extendida 2: el número total de WORD en los siguientes 2 WORD (65.536~2³²−1) |

- De 1 a 14 WORD se debe escribir siempre con longitud directa. Una notación más ancha no es la forma canónica.
- El número total de WORD de la longitud extendida incluye el propio TAG de extensión de Length.
- No hay registros de más de 2³²−1 WORD.
- Un registro de 1 WORD es solo el TAG WORD, sin Payload. Se usa únicamente cuando la especificación del Codec lo permite (ejemplo: Meta `BODY`, `END`, bytes vacíos, marcador de posición).
- Aunque no haya libro de códigos, se puede saltar un registro con `posición del siguiente registro = inicio del registro actual + Length`.

## Codec (7 bits)

| Valor | Nombre | Significado |
|---|---|---|
| `0x00`~`0x7B` | Código directo | El TAG WORD por sí solo fija el Codec |
| `0x7C` | ISSUER-1WORD | El TAG de extensión de Codec lleva 1 WORD de Issuer y 1 WORD de número de formato |
| `0x7D` | ISSUER-2WORD | El TAG de extensión de Codec lleva 2 WORD de Issuer y 1 WORD de número de formato |
| `0x7E` | ISSUER-4WORD | El TAG de extensión de Codec lleva 4 WORD de Issuer y 1 WORD de número de formato |
| `0x7F` | ISSUER-16WORD | El TAG de extensión de Codec lleva 16 WORD de Issuer y 1 WORD de número de formato |

- El espacio de números de Codec es independiente para cada Kind. El mismo número con otro Kind es otro Codec.
- Un Codec que no es código directo es un par `(Issuer, número de formato)`. El número de formato lo define ese Issuer ([Issuer y publicación](/es/grammar/issuer/)). Los formatos de extensión se colocan bajo el Issuer de la organización que los promulgó.
- Un Codec que tiene código directo no se registra aparte como formato Issuer.
- El formato Issuer existe solo en Value y Edge. Reference usa 4 bits de Codec, y Meta es una especificación común que define solo GEUL.
- Los bits superiores del Codec y del número de formato indican la familia (Value·Edge) o la clase (Meta). La familia se conoce incluso sin libro de códigos.
- Los códigos directos no se pueden recuperar. Solo se ponen como código directo los formatos de frecuencia confirmada.

## Registro de formato Issuer

```
TAG WORD          Codec = 0x7C~0x7F
[TAG de extensión de Length]
Issuer            1/2/4/16 WORD (el Codec fija el ancho)
Número de formato 1 WORD. Los bits superiores son la familia
Payload           valor fijado por el formato
```

- Un decodificador que no conoce el formato solo sabe la familia por el número de formato y salta el Payload.

## Bytes de longitud variable

Los valores cuya longitud se mide en bytes, como texto, URI, etiquetas de idioma o bytes desconocidos, se asignan al Codec (o al número de formato) en **pares par/impar**.

- Si el bit menos significativo del Codec es `0`, el número de bytes es par; si es `1`, impar.
- Número de bytes = `2 × número de WORD del Payload − bit menos significativo`. No hay campo Byte Count.
- Si es impar, el byte inferior del último WORD es relleno `0x00`. Si no es `0x00`, se rechaza.
- Unos bytes vacíos son un registro de 1 WORD (solo el TAG WORD) con el Codec par.
- Los valores de tamaño fijo, como UUID, digests o direcciones, no tienen par.

## Ejemplo: leer un TAG WORD

Leamos `148A`.

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10(Edge), Length 1001(10 WORD), Codec 0x0A(TRIPLE)
```

Este registro es un Edge de 10 WORD y su Codec es TRIPLE. Aunque no haya libro de códigos, se sabe que el siguiente registro está 10 WORD más adelante.

## Marcador de posición

Los TAG WORD `0x0000`~`0x0007` son registros de 1 WORD del Codec de Reference reservado `0000`. No apuntan a ningún objeto y rellenan la posición de un campo del registro ([Marcador de posición](/es/grammar/reference/slot-marker/)).

```
0x0000~0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = número de marcador
```

| WORD | Nombre | Significado | Sobre qué habla | Lógica | Supuesto de mundo | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | No declarado | Documento: no se rellenó esta posición | Sin aserción | Mundo abierto | sin snak |
| `0x0001` | UNKNOWN-VALUE | Desconocido | Mundo: hay un valor. Se ignora cuál | `∃x. P(s, x)` | Existencia cerrada, identidad abierta | `somevalue` |
| `0x0002` | NO-VALUE | Sin valor | Mundo: no hay valor | `¬∃x. P(s, x)` | Cerrado para (s, P, condiciones que acotan) | `novalue` |
| `0x0003`~`0x0007` | Reservado | | | | | |

- Ejemplo: si hijos (P40) es ABSENT, no se sabe cuántos; si es UNKNOWN-VALUE, uno o más; si es NO-VALUE, cero. Si el momento de fin (P582) es ABSENT, no se sabe si sigue vigente; si es UNKNOWN-VALUE, terminó pero no se sabe cuándo; si es NO-VALUE, no terminó.
- Los 3 bits inferiores `MMM` no son un Quantifier sino el número de marcador (excepción de Quantifier en [Reference](/es/grammar/reference/)).
- Un marcador es válido solo cuando la lista CODEC del campo incluye exactamente ese WORD. Es invalid con comodines, en campos sin CODEC, en posiciones de registro de HEAD·BODY y en la posición de Edge Id ([CODEC](/es/grammar/edge/codec/)).
- Obligaciones de quien lee:
  1. UNKNOWN-VALUE no es un valor sino una aserción de existencia. No es igual ni distinto de ningún valor, y dos UNKNOWN-VALUE tampoco se consideran el mismo valor. Los TRIPLE que contienen UNKNOWN-VALUE no se fusionan como duplicados.
  2. NO-VALUE se cierra dentro de las condiciones que acotan esa proposición. Si coexiste, con el mismo Subject, Predicate y rank, con un TRIPLE de valor cuyas condiciones acotadoras no se distinguen, es una contradicción y el verificador avisa (no rechaza).
  3. El rank se aplica igual. Al elegir el valor representativo (truthy), los TRIPLE de ambos marcadores también son candidatos.
  4. Si se usa como valor de un QUALIFIER, cambia el sentido de esa acotación (`P582 = UNKNOWN`: terminó, momento desconocido. `P582 = NONE`: no terminó).
  5. ABSENT no dice nada sobre el mundo. Un valor que no se pudo trasladar no se escribe como UNKNOWN-VALUE.

## Forma canónica

El mismo contenido debe dar los mismos bytes. Solo así el hash de contenido y la firma quedan determinados de forma única.

- La longitud usa la notación más corta (de 1 a 14 WORD, longitud directa).
- Los enteros se escriben con el ancho más corto. Se sigue la forma canónica que fije la especificación de cada Codec.
- Un registro que no esté en forma canónica se rechaza.
