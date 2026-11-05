---
title: "CODEC (0x0BEL)"
weight: 190
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC es un Edge de enunciado que especifica un Kind·Codec que acepta un FIELD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `CODEC` (BIND del documento de especificación `CODEC`) |
| TAG ID | `0x0BEL` |
| Codec ID | `0x00000BE0` |
| Documento de especificación | `0x00000000/codecs/0x00000BE0/` (destino de DECLARE `0BE0`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 30 |
| Kind | Edge · familia: enunciado, grupo: otros |
| TAG WORD | `0000 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Un Kind·Codec que acepta un campo. Campo, WORD de destino (`000K KKKC CCCC LLLL`, LLLL 0000 exacto·1111 comodín (las 32 casillas de esa sección); los marcadores de posición solo como destino exacto `0000`·`0010`·`0020`). Un campo de registro admite varios (lista cerrada), un campo de valor en bruto uno (ese Value sin TAG) |
| Lado Hugo | `edge/codec.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | registro | `0050` LOCAL |  |
| 2 | `target` | #4 | valor en bruto 1 WORD |  |  |

CODEC es un Edge de enunciado que especifica un Kind·Codec que acepta un [FIELD](0x0BCL-field.md). Codec `0x0BEL`.

Así como [ENUM](0x0BDL-enum.md) da significado a un código de un campo de valor en bruto, CODEC asigna un formato a un campo. Como es uno por Edge, se pueden especificar varios. El layout se integra en el decodificador ([documento de especificación de Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1110 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
campo             registro Reference LOCAL que señala el Edge FIELD
destino           1 WORD. 000K KKKC CCCC LLLL (LLLL = 0000 exacto, 1111 comodín)
```

## WORD de destino {#대상-word}

- Se deja tal cual la posición del Codec del TAG WORD (sección `KKKK` y `CCCCC`). Los 3 bits superiores son 0. `LLLL` es `0000` (exacto) o `1111` (comodín), y cualquier otro valor es invalid.
- El valor de un destino exacto (`LLLL = 0000`) escrito en 32 bits es el Codec ID de ese Codec (por ejemplo, LOCAL `0x0050` → `0x00000050`, COORDINATE-EARTH `0x0640`, UTF8-LANGUAGE-TEXT `0x0780`). Por eso el destino señala directamente el documento de especificación de ese Codec ([documento de especificación de Codec](../codec-spec.md)).
- Los pares de códigos par/impar (texto, secuencia de bytes) también se especifican con el código exacto. Para aceptar par e impar, se ponen ambos. No hay regla que interprete el par como una unidad (hay códigos adyacentes que no son un par, como NUMERIC `0x064L`/`0x065L`).

### Comodín (`LLLL = 1111`) {#와일드카드-llll--1111}

- Si `LLLL = 1111`, se acepta toda la sección `KKKK` (32 casillas) del WORD de destino, sin importar el valor de `C`. Dentro de la misma sección, el sentido es el mismo sea cual sea `C`. Solo se mira si la sección del destino y la del registro son la misma. No se acepta fuera de la sección.
- Si `LLLL = 1111`, se recomienda la primera casilla de la sección (`C = 0`). Es una recomendación, no una obligación. Es válido también con otro `C` de la misma sección.
- Si un Kind abarca varias secciones, se enumera un CODEC por sección.

| Destino | Significado |
|---|---|
| `000F`·`020F`·`040F` | Cualquier Reference (secciones 0~2, incluido REFERENCE-ISSUER) |
| `060F`·`080F` | Cualquier Value (secciones 3·4, incluido VALUE-ISSUER) |
| `0A0F`·`0C0F`·`0E0F`·`100F`·`120F`·`140F`·`160F`·`180F`·`1A0F` | Cualquier Edge (secciones 5~13, incluido EDGE-ISSUER) |
| `1C0F`·`1E0F` | Cualquier Meta (secciones 14·15) |

- Los marcadores de posición de Reference (`0x000L~0x002L`) no concuerdan con `LLLL = 1111` (`000F` no acepta ABSENT·UNKNOWN-VALUE·NO-VALUE). En cambio, en una sección cuya primera casilla está asignada, como Value `0x060L` (BOOL) o Edge `0x0A0L` (REFERENCE-NODE), `LLLL = 1111` también la incluye (para aceptar solo BOOL, `LLLL = 0000` con `0600`).
- Un destino con `LLLL = 1111` no señala un documento de especificación.
- «Indiferente a la cuantificación» o los grupos se escriben solo enumerando CODEC (`LLLL = 0000`). Ejemplo: «indiferente a la cuantificación» de WIKIDATA-QID son cinco: `0140`, `0150`, `0160`, `0170`, `0180`.
- Los códigos del sistema 5Q de Reference incluyen la cuantificación. El destino especifica exactamente hasta la cuantificación. Para aceptar varios Quantifier se ponen varios CODEC. La cuantificación de REFERENCE-ISSUER la fija el documento del Issuer.

### Marcadores de posición (destino `0000`, `0010`, `0020`) {#자리-표지-대상-0000-0010-0020}

Los [marcadores de posición](../slot-marker.md) son el grupo de registros de 1 WORD asignado a las tres primeras casillas `0x000L~0x002L` de la sección 0 de Reference. No tienen cuantificación.

| Destino | Marcador | Significado |
|---|---|---|
| `0000` | ABSENT | No se escribe. Ese campo es un campo opcional |
| `0010` | UNKNOWN-VALUE | Desconocido. Acepta la aserción de que hay un valor |
| `0020` | NO-VALUE | Ausente. Acepta la aserción de que no hay valor |

- **Regla de aceptación:** un marcador solo es válido si en la lista CODEC de ese campo está el mismo WORD como destino exacto. Un comodín y un campo de registro sin CODEC («cualquier registro») no aceptan marcadores. Un marcador en el lugar de un registro de HEAD·BODY o en el lugar del Edge Id es invalid.
- Una lista que solo tiene destinos de marcador (siempre marcador) es invalid (generalización de la regla de la lista que solo tiene `0000`). Se usa junto con destinos `LLLL = 1111` o con destinos exactos (`000F`·`020F`·`040F` + `0000` = cualquier Reference o su omisión).
- En un campo de valor en bruto no se puede poner destino de marcador. Un valor en bruto no tiene TAG y su ancho está fijado, así que no hay lugar para un marcador de 1 WORD.
- El significado del marcador lo fija la especificación del Codec que lo recibe.

### Campo opcional (destino `0000`) {#선택-필드-대상-0000}

- Si en la lista CODEC de un campo de registro se pone el destino `0000`, ese campo es un **campo opcional**. Al omitirlo se escribe en su lugar el WORD `0x0000` (1 WORD). Ese registro de 1 WORD es el marcador de posición ABSENT (no se escribe).
- `0x0000` es Reference, Codec `0x000L` (Reserved), `LLLL = 0000` (1 WORD en total). No se solapa con otros registros, y un decodificador que no conoce la especificación también lo salta como registro de 1 WORD.
- Un campo opcional también ocupa siempre su lugar. Si se omite, se escribe obligatoriamente `0x0000` y no se deja el lugar vacío (igual aunque sea un campo posterior). Por eso un registro tiene una única notación y la descomposición queda fijada solo por la posición. No hay restricciones sobre la posición ni el número de campos opcionales, ni sobre si su lista se solapa con la de otros campos.
- ABSENT solo es válido en el lugar de un campo opcional. Un `0x0000` en el lugar de un registro de HEAD·BODY, de un campo obligatorio o del Edge Id es invalid.
- Omitir no es «no hay valor» sino «no se escribe». No se asevera nada sobre el mundo. «No hay valor» se escribe con NO-VALUE (`0020`). Qué significa omitir (por ejemplo, si no hay destino en TAG, esta versión) lo fija la especificación de cada formato.

## Interpretación y validez {#해석과-유효성}

- El campo es un Edge FIELD del mismo documento. En un campo no se pone dos veces el mismo destino.
- **Campo de registro (ancho 0)**: sin CODEC acepta cualquier registro salvo marcadores de posición. Si hay uno o más, es una lista cerrada. El registro de ese campo debe tener un Kind·Codec (incluido el Quantifier en Reference) que esté en la lista, y si no, ese registro no cumple la especificación. A diferencia de ENUM, que es una lista abierta.
- **Campo de valor en bruto (ancho n ≥ 1, o resto `0xFFFF`)**: CODEC lleva un único destino exacto (sin comodín). Ese valor en bruto es el Payload de ese Value sin el TAG. El Kind·Codec lo da CODEC y el Length lo da el ancho de FIELD. En los códigos par/impar, el código especificado fija la paridad del número de bytes. Si el valor en bruto no cumple las reglas de ese Value (incluida la longitud), ese registro no cumple la especificación.
- Los marcadores de posición solo se contrastan con los destinos exactos de la lista. Si en el lugar de un campo opcional (destino `0000`) aparece `0x0000`, es una omisión. Los demás registros se contrastan con la lista sin los destinos de marcador.
- A un campo de valor en bruto se le pueden poner a la vez CODEC y ENUM. CODEC es el formato y ENUM el nombre del código (por ejemplo, rank como UNSIGNED-INTEGER y 0·1·2 como ENUM).
- Se puede poner un nombre al Edge Id de CODEC con BIND, pero no es obligatorio.
- Un campo «Reference o Value» se escribe con 5 CODEC (`000F`, `020F`, `040F`, `060F`, `080F`).

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD si Edge Id y campo son un ID LOCAL de 1 WORD)
```

## Ejemplo {#예시}

En el documento de especificación de LABEL `0x00000000/codecs/0x00000A40/`, el campo Object (FIELD #3) acepta UTF8-LANGUAGE-TEXT (par e impar) y LOCAL. Edge Id 7~9.

```
0BE5 0051 0007 0051 0003 0780
0BE5 0051 0008 0051 0003 0790
0BE5 0051 0009 0051 0003 0050
```

- TAG `0BE5` (Edge, Codec `0x0BEL`, `LLLL = 0101`, 6 WORD), Edge Id `0051 0007`, campo `0051 0003`, destino `0780`.

## Páginas relacionadas {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [DECLARE](0x0BBL-declare.md), [BIND](0x0A3L-bind.md)
- [documento de especificación de Codec](../codec-spec.md), [LABEL](0x0A4L-label.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000BE0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BE000000000
BODY
#1 DECLARE 0x0BE0
#2 FIELD #1 record
#3 CODEC #2 0x0050
#4 FIELD #1 0x0001
#5 BIND #1 "CODEC"
#6 BIND #2 "field"
#7 BIND #4 "target"
```
