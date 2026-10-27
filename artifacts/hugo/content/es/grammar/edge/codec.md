---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC es un Edge de afirmación que designa el Kind y Codec que acepta un FIELD (Codec 0x1E). Los comodines y los marcadores de posición (0x0000 no declarado, 0x0001 desconocido, 0x0002 sin valor) también se declaran con él."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC es un Edge de afirmación que designa un Kind y Codec que acepta un [FIELD](/es/grammar/edge/field/). Codec `0x1E`.

Así como [ENUM](/es/grammar/edge/enum/) da significado a un valor de código de un campo de valor crudo, CODEC asigna un formato al campo. Como cada Edge designa uno solo, se pueden designar varios. El layout viene integrado en el decodificador ([Documento de especificación de Codec](/es/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1110
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Campo             registro Reference LOCAL que apunta a un Edge FIELD
Destino           1 WORD. 000K KLLL LCCC CCCC (LLLL = 0000 exacto, 1111 comodín)
```

## WORD de destino

- Conserva tal cual las posiciones de Kind (`KK`) y Codec (`CCCCCCC`) del TAG WORD. Los 3 bits superiores son 0. `LLLL` es `0000` (exacto) o `1111` (comodín); cualquier otro valor es inválido.
- Un destino exacto (`LLLL = 0000`) es igual al ID del documento de especificación del Codec (por ejemplo, LOCAL `0x0008`, COORDINATE-EARTH `0x0804`, UTF8-LANGUAGE-TEXT `0x084A`). Así, el destino apunta directamente al documento de especificación de ese Codec.
- Los pares de códigos par/impar (texto, secuencias de bytes) también se designan con el código exacto. Para aceptar tanto el par como el impar se ponen ambos. No hay una regla que interprete los pares como unidad (hay códigos adyacentes que no son pares, como NUMERIC `0x04`/`0x05`).

### Comodín (`LLLL = 1111`)

- El Kind debe coincidir, y **cualquier grupo de bits de Codec que sea 0 coincide con todo**. En Reference, `CCCC` (Codec) y `QQQ` (Quantifier) son grupos separados; en los demás Kind, los 7 bits enteros forman un solo grupo.

| Destino | Significado |
|---|---|
| `0780` | cualquier Reference |
| `07A0` | WIKIDATA-QID, sin importar el Quantifier |
| `0781` | cualquier Codec de Reference, Quantifier Generic (`001`) |
| `0F80` | cualquier Value |
| `1780`, `1F80` | cualquier Edge, cualquier Meta |

- Un comodín que no tiene nada que casar es inválido. En Value, Edge y Meta el Codec debe ser 0, y en Reference uno de `CCCC` o `QQQ` debe ser 0. El Codec de Reference `CCCC = 0000` (marcador de posición) es un Codec reservado, por lo que **no coincide con ningún comodín** (`0780` no acepta ABSENT, UNKNOWN-VALUE ni NO-VALUE). Por otro lado, en los Kind que tienen asignado el Codec 0, como Value `0x00` (BOOL) o Edge `0x00` (REFERENCE-NODE), el comodín también los incluye (para aceptar solo BOOL, `LLLL = 0000`).
- Un comodín no apunta a un documento de especificación.
- No existe una expresión que fije un solo grupo distinto de 0 y deje libre el grupo que es 0, como "cualquier Reference solo Identified". Tales listas enumeran destinos exactos.
- Los 7 bits de Codec de Reference incluyen el Quantifier (`QQQ`). El destino designa el Quantifier con exactitud. Para aceptar varios Quantifier se ponen varios CODEC.

### Marcadores de posición (destino `0000`~`0002`)

Un [marcador de posición](/es/grammar/reference/slot-marker/) es un grupo de registros de 1 WORD del Codec de Reference reservado `0000`. Los 3 bits inferiores son el número de marcador (no es un Quantifier).

| Destino | Marcador | Significado |
|---|---|---|
| `0000` | ABSENT | No declarado. Ese campo es un campo opcional |
| `0001` | UNKNOWN-VALUE | Desconocido. Acepta la aserción de que existe un valor |
| `0002` | NO-VALUE | Sin valor. Acepta la aserción de que no existe valor |
| `0003`~`0007` | reservado | |

- **Regla de aceptación:** un marcador es válido solo si el mismo WORD figura como destino exacto en la lista CODEC de ese campo. Los campos de registro con comodín o sin CODEC ("cualquier registro") no aceptan marcadores. Un marcador en la posición de un registro de HEAD o BODY, o en la posición de Edge Id, es inválido.
- Una lista con solo destinos de marcador (siempre marcador) es inválida (generalización de la regla de la lista con solo `0000`). Se usa junto con un comodín o con un destino exacto (`0780` + `0000` = cualquier Reference u omitido).
- En un campo de valor crudo no se puede poner un destino de marcador. El valor crudo no tiene TAG y su ancho está fijado, por lo que no hay lugar para un marcador de 1 WORD.
- El significado del marcador lo fija la especificación del Codec que lo recibe.

### Campo opcional (destino `0000`)

- Si en la lista CODEC de un campo de registro se pone el destino `0000`, ese campo es un **campo opcional**. Al omitirlo se escribe en esa posición 1 WORD con el valor `0x0000`. Ese registro de 1 WORD es el marcador de posición ABSENT (no declarado).
- `0x0000` es el Codec de Reference `0000` (reservado), número de marcador `000`, `LLLL = 0000` (1 WORD en total). No se solapa con otros registros, y un decodificador que no conoce la especificación también lo salta como registro de 1 WORD.
- Un campo opcional también ocupa siempre su posición. Si se omite, hay que escribir `0x0000` sin dejar la posición vacía (también si es un campo del final). Así, un registro tiene una única notación y su descomposición queda determinada solo por la posición. No hay restricciones sobre la posición y el número de campos opcionales, ni sobre si sus listas se solapan con las de otros campos.
- ABSENT es válido solo en la posición de un campo opcional. Un `0x0000` en la posición de un registro de HEAD o BODY, de un campo obligatorio o del Edge Id es inválido.
- Omitir no significa "sin valor" sino "no declarado". No se afirma nada sobre el mundo. "No hay valor" se escribe con NO-VALUE (`0002`). Qué significa omitir (por ejemplo, si no hay destino en TAG, esta versión) lo fija la especificación de cada formato.

## Interpretación y validez

- El campo es un Edge FIELD del mismo documento. No se pone el mismo destino dos veces en un campo.
- **Campo de registro (ancho 0)**: si no hay CODEC, acepta cualquier registro excepto los marcadores de posición. Si hay uno o más, es una lista cerrada. El registro de ese campo debe tener un Kind y Codec (en Reference, incluido el Quantifier) que figure en la lista; si no, ese registro no cumple la especificación. A diferencia de ENUM, que es una lista abierta.
- **Campo de valor crudo (ancho n ≥ 1, o el resto `0xFFFF`)**: CODEC pone un solo destino exacto (sin comodín). Ese valor crudo es el Payload de ese Value sin el TAG. El Kind y el Codec los da CODEC, y la Length la da el ancho de FIELD. En los códigos par/impar, el código designado fija la paridad del número de bytes. Si el valor crudo no sigue las reglas de ese Value (incluida la longitud), ese registro no cumple la especificación.
- Los marcadores de posición se contrastan solo con los destinos exactos de la lista. Si en la posición de un campo opcional (destino `0000`) aparece `0x0000`, es una omisión. Los demás registros se contrastan con la lista sin los destinos de marcador.
- En un campo de valor crudo se pueden poner juntos CODEC y ENUM. CODEC es el formato y ENUM es el nombre de los valores de código (por ejemplo, rank como UNSIGNED-INTEGER y 0, 1, 2 como ENUM).
- Al Edge Id de CODEC se le puede dar nombre con BIND, pero no es obligatorio.
- Un campo "Reference o Value" se escribe con 2 CODEC (`0780`, `0F80`).

## Longitud

```
total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD si Edge Id y campo son IDs LOCAL de 1 WORD)
```

## Ejemplo

En el documento de especificación de LABEL `geul.org/label`, el campo Object (FIELD #3) acepta UTF8-LANGUAGE-TEXT (par e impar) y LOCAL. Edge Id 7~9.

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E` (Edge, Codec `0x1E`, `LLLL = 0101`, 6 WORD), Edge Id `0088 0007`, campo `0088 0003`, destino `084A`.

## Páginas relacionadas

- [FIELD](/es/grammar/edge/field/), [ENUM](/es/grammar/edge/enum/), [DECLARE](/es/grammar/edge/declare/), [BIND](/es/grammar/edge/bind/)
- [Documento de especificación de Codec](/es/grammar/codec-spec/), [LABEL](/es/grammar/edge/label/)
