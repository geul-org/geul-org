---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO es el Value de coordenadas que representa un punto de un cuerpo celeste indicado (planeta, satélite, asteroide, etc.) mediante latitud, longitud e incertidumbre."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `COORDINATE-GEO` (documento de especificación BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| Documento de especificación | `0x00000000/codecs/0x00000650/` (destino de DECLARE `0650`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 5 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Reference del cuerpo celeste, latitud y longitud en binary64, incertidumbre en binary32 y el Reference de su unidad |
| Lado Hugo | `value/numeric/coordinate-geo.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | registro | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | valor en bruto, 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | valor en bruto, 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | valor en bruto, 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `0000` ABSENT (campo opcional) |  |

COORDINATE-GEO es el Value de coordenadas que representa un punto de un cuerpo celeste indicado (planeta, satélite, asteroide, etc.) mediante latitud, longitud e incertidumbre. Su código directo de Value es `0x065L` y su familia es NUMERIC. Es el formato [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) precedido por un Reference de cuerpo celeste (Globe); las reglas de latitud, longitud, incertidumbre y unidad son las mismas que en COORDINATE-EARTH.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Globe             1 registro Reference (Reference que señala el cuerpo celeste, Quantifier Identified)
Latitude          4 WORD en bruto, IEEE 754 binary64 (grados)
Longitude         4 WORD en bruto, IEEE 754 binary64 (grados)
Uncertainty       2 WORD en bruto, IEEE 754 binary32 (en unidades de Unit)
Unit              1 registro Reference, o el marcador de posición 0x0000 ABSENT
```

## Interpretación y validez {#해석과-유효성}

- El Payload empieza con el registro Globe. Globe es exactamente un registro Reference completo y su Quantifier es Identified. Se puede usar cualquier Reference que señale un cuerpo celeste: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (cuerpos celestes con nombre), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) del mismo documento (un cuerpo celeste definido dentro del documento), un cuerpo celeste de otro documento ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)), etc. Los cuerpos celestes son innumerables y los que tienen QID son solo una parte.
- Tras Globe vienen 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) y un registro Unit. El cursor tras leer Unit debe coincidir con el final del registro.
- Latitude cumple `-90 ≤ φ ≤ 90` y Longitude cumple `-360 ≤ λ ≤ 360`. Se permite un rango más amplio que el de la Tierra para poder guardar sin modificar tanto los valores de los sistemas de coordenadas celestes que cuentan la longitud de 0 a 360° (este y oeste) como los valores negativos escritos en la dirección contraria. El rango es el mismo que el del modelo de datos globecoordinate de Wikidata (`LatLongValue` de Wikibase). `λ` y `λ ± 360` son el mismo meridiano y GEUL no los normaliza. Las demás reglas (binary64, valores finitos, orden de los ejes, significado de Uncertainty y Unit, representación de desconocida) son las mismas que en COORDINATE-EARTH.
- El sistema de coordenadas sigue, para cada cuerpo celeste, la convención de ese cuerpo (latitud planetocéntrica, longitud este u oeste de 0 a 360°, etc.). El sistema de coordenadas de cada cuerpo celeste se define en un documento GEUL aparte.
- La Uncertainty en una unidad de distancia (metros, etc.) es una distancia sobre la superficie del cuerpo celeste. Una unidad angular (grado, minuto de arco, segundo de arco) es un radio angular de latitud y longitud, independiente del tamaño del cuerpo celeste.
- Para las coordenadas de la Tierra (Q2) se recomienda usar COORDINATE-EARTH. Escribir la Tierra en este formato tampoco es invalid; quien compara la trata como la misma coordenada.
- El documento de especificación de geul.org `0x00000000/codecs/0x00000650` coloca [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) en los campos en bruto Latitude, Longitude y Uncertainty, y CODEC `000F`, `020F`, `040F` (cualquier Reference) y `0000` (ABSENT) en el campo de registro Unit.

## Longitud {#길이}

- El total es 1 WORD de TAG + (TAG de extensión de Length) + registro Globe + 10 WORD + registro Unit.
- Si Globe es de 2 WORD (cuando el QID cabe en 1 WORD) y Unit es ABSENT, son 14 WORD, `LLLL=1101`, TAG `065D`. Si Unit es un Reference (2 WORD o más), se superan los 15 WORD y se usa la longitud extendida: TAG `065E`, y en el WORD siguiente el número total de WORD ([registro y TAG WORD](../record.md)).

## Correspondencia con Wikidata {#위키데이터-대응}

- Un globecoordinate cuyo globe no es la Tierra (Q2) se escribe en este formato. Globe = WIKIDATA-QID (el elemento globe). La correspondencia de latitud, longitud y precision → Uncertainty·Unit es la misma que en COORDINATE-EARTH (la precision es una resolución de registro en grados, por lo que se traslada tal cual, independientemente del tamaño del cuerpo celeste).
- Cuerpos celestes fuera de la Tierra en la muestra de Wikidata (unas 24 mil declaraciones de coordenadas): Marte (Q111), Ceres (Q596), la Luna (Q405), Mercurio (Q308), Venus (Q313), etc., 23 casos. Los 41 casos con globe vacío no se convierten y se conserva el texto original en UTF8-TEXT.

## Ejemplo {#예시}

Marte (Q111) 4.5, 137.4, incertidumbre desconocida:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, desconocida).
- Notación de texto: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

El mismo punto, con precision 0.1° (Unit grado Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, longitud extendida), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## Fundamento normativo {#표준-근거}

- Significado: latitud, longitud y `u` (cuando Unit es el metro) de [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). El único sistema de coordenadas registrado para `crs` en RFC 5870 es `wgs84`, por lo que los cuerpos celestes fuera de la Tierra se indican con el Reference Globe de GEUL.
- Numérico: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitud, longitud), binary32 (incertidumbre).
- Rango de longitud: `-360 ≤ λ ≤ 360` de [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo), el modelo de datos globecoordinate de Wikidata.

## Problemas abiertos {#열린-문제}

1. Documentos de sistema de coordenadas por cuerpo celeste: la definición de latitud (planetocéntrica o planetográfica) y la dirección y el rango de la longitud para cada cuerpo celeste.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000650/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
