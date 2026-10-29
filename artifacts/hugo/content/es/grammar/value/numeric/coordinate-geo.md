---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO es un Value que contiene un punto sobre un cuerpo celeste, como un planeta o un satélite, con el Reference del cuerpo celeste, latitud y longitud binary64, una incertidumbre binary32 y el Reference de su unidad."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
COORDINATE-GEO es un Value de coordenadas que representa un punto sobre un cuerpo celeste indicado (planeta, satélite, asteroide, etc.) con latitud, longitud e incertidumbre. Es el código directo de Value `0x05`, familia NUMERIC. Es el formato de [COORDINATE-EARTH](/es/grammar/value/numeric/coordinate-earth/) (`0x04`) con un Reference del cuerpo celeste (Globe) delante, y las reglas de latitud, longitud, incertidumbre y unidad son las mismas que en COORDINATE-EARTH.

## Layout

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[TAG de extensión de Length] si el total es de 15 WORD o más
Globe             1 registro Reference (Reference que apunta al cuerpo celeste, Quantifier Identified)
Latitude          4 WORD en bruto, IEEE 754 binary64 (grados)
Longitude         4 WORD en bruto, IEEE 754 binary64 (grados)
Uncertainty       2 WORD en bruto, IEEE 754 binary32 (en la unidad de Unit)
Unit              1 registro Reference, o marcador de posición 0x0000 ABSENT
```

## Interpretación y validez

- El Payload empieza con el registro Globe. Globe es exactamente un registro Reference completo y su Quantifier es Identified (`000`). Sirve cualquier Reference que apunte a un cuerpo celeste: [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/) (cuerpos celestes con nombre), [GEUL](/es/grammar/reference/geul/), un [LOCAL](/es/grammar/reference/local/) del mismo documento (un cuerpo celeste definido dentro del documento), un cuerpo celeste de otro documento ([EXTERNAL-POINTER](/es/grammar/reference/external-pointer/)·[EXTERNAL-ISSUER](/es/grammar/reference/external-issuer/)), etc. Los cuerpos celestes son innumerables y los que tienen QID son solo una parte.
- Tras Globe vienen 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) y un registro Unit. El cursor tras leer Unit debe coincidir con el final del registro.
- Latitude cumple `-90 ≤ φ ≤ 90` y Longitude cumple `-360 ≤ λ ≤ 360`. El rango es más amplio que en la Tierra para contener sin cambios los valores de los sistemas de coordenadas de cuerpos celestes que cuentan la longitud de 0 a 360° (este u oeste) y los valores negativos escritos en el sentido opuesto. El rango es el mismo que el del modelo de datos globecoordinate de Wikidata (Wikibase `LatLongValue`). `λ` y `λ ± 360` son el mismo meridiano y GEUL no los normaliza. Las demás reglas (binary64, valores finitos, orden de ejes, significado de Uncertainty y Unit, expresión de desconocido) son las mismas que en COORDINATE-EARTH.
- El sistema de coordenadas sigue, para cada cuerpo celeste, las convenciones de ese cuerpo (latitud planetocéntrica, longitud este u oeste de 0 a 360°, etc.). El sistema de coordenadas de cada cuerpo se fija en un documento GEUL aparte.
- Una Uncertainty en unidades de distancia (metros, etc.) es una distancia sobre la superficie del cuerpo celeste. Las unidades angulares (grado, minuto de arco, segundo de arco) son el radio angular de latitud y longitud, con independencia del tamaño del cuerpo celeste.
- Para las coordenadas de la Tierra (Q2) se recomienda usar COORDINATE-EARTH. Poner la Tierra en este formato tampoco es invalid, y quien compara las equipara como la misma coordenada.
- El documento de especificación de geul.org `0x0000/0x0000000000000805` pone en los campos de valor en bruto Latitude, Longitude y Uncertainty el [CODEC](/es/grammar/edge/codec/) BINARY-FLOAT (`0803`), y en el campo de registro Unit los CODEC `0780` (cualquier Reference) y `0000` (ABSENT).

## Longitud

- El total es TAG 1 WORD + (TAG de extensión de Length) + registro Globe + 10 WORD + registro Unit.
- Si Globe es de 2 WORD (cuando el QID cabe en 1 WORD) y Unit es ABSENT, son 14 WORD, `LLLL=1101`, TAG `0E85`. Si Unit es un Reference (2 WORD o más), supera los 15 WORD y se usa longitud extendida: TAG `0F05`, y en el WORD siguiente el número total de WORD ([Registro y TAG WORD](/es/grammar/record/)).

## Correspondencia con Wikidata

- Una globecoordinate cuyo globe no es la Tierra (Q2) se escribe con este formato. Globe = WIKIDATA-QID (elemento globe). La correspondencia de latitud, longitud y precision → Uncertainty·Unit es la misma que en COORDINATE-EARTH (la precision es una resolución de registro en grados, así que se traslada tal cual con independencia del tamaño del cuerpo celeste).
- Cuerpos celestes fuera de la Tierra en la muestra de Wikidata (unas 24.000 declaraciones de coordenadas): 23 casos como Marte (Q111), Ceres (Q596), la Luna (Q405), Mercurio (Q308) y Venus (Q313). Los 41 casos con el globe vacío no se convierten y se conserva el original como UTF8-TEXT.

## Ejemplo

Marte (Q111) 4.5, 137.4, incertidumbre desconocida:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, desconocido).
- Notación de texto: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

El mismo punto, con precision 0.1° (Unit grado Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, longitud extendida), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## Base estándar

- Significado: la latitud, la longitud y `u` (cuando Unit es metro) de [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). El único sistema de coordenadas registrado en el `crs` de RFC 5870 es `wgs84`, por lo que los cuerpos celestes fuera de la Tierra se designan con el Reference Globe de GEUL.
- Numérico: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitud y longitud), binary32 (incertidumbre).
- Rango de longitud: `-360 ≤ λ ≤ 360` del modelo de datos globecoordinate de Wikidata, [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## Problemas abiertos

1. Documentos de sistema de coordenadas por cuerpo celeste: la definición de latitud (planetocéntrica o planetográfica) y la dirección y el rango de la longitud de cada cuerpo celeste.

## Páginas relacionadas

- [Value](/es/grammar/value/), [COORDINATE-EARTH](/es/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/), [GEUL](/es/grammar/reference/geul/), [LOCAL](/es/grammar/reference/local/)
