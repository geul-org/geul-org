---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH es un Value que contiene un punto de la Tierra (WGS 84) con latitud y longitud binary64, una incertidumbre binary32 y el Reference de la unidad de la incertidumbre."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
COORDINATE-EARTH es un Value de coordenadas que representa un punto de la Tierra con latitud, longitud e incertidumbre. Es el código directo de Value `0x04`, familia NUMERIC. Su sentido es el mismo que el de `geo:latitud,longitud;u=incertidumbre` (sistema de coordenadas WGS 84) de [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI), y se contiene como un número de ancho fijo y no como cadena. La incertidumbre se anota junto con su unidad. Las coordenadas de cuerpos celestes fuera de la Tierra se escriben con [COORDINATE-GEO](/es/grammar/value/numeric/coordinate-geo/) (`0x05`).

## Layout

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD en bruto, IEEE 754 binary64 (grados)
Longitude         4 WORD en bruto, IEEE 754 binary64 (grados)
Uncertainty       2 WORD en bruto, IEEE 754 binary32 (en la unidad de Unit)
Unit              1 registro Reference, o marcador de posición 0x0000 ABSENT
```

## Interpretación y validez

- El Payload es 4 WORD de Latitude, 4 WORD de Longitude y 2 WORD de Uncertainty, seguidos de exactamente un registro Unit. El cursor tras leer Unit debe coincidir con el final del registro.
- El sistema de coordenadas es WGS 84 (el `crs=wgs84` por defecto de RFC 5870).
- Latitude y Longitude son IEEE 754 binary64 formado concatenando los WORD del Payload en orden big-endian (la misma disposición de bits que binary64 de [BINARY-FLOAT](/es/grammar/value/numeric/binary-float/)). La unidad son los grados (°).
  - Deben ser valores finitos. NaN y ±Infinity son invalid.
  - Latitude cumple `-90 ≤ φ ≤ 90` (el norte es positivo) y Longitude cumple `-180 ≤ λ ≤ 180` (el este es positivo).
  - El orden de los ejes es latitud, longitud (igual que RFC 5870 e ISO 6709). No es el orden x (longitud), y (latitud) de WKB y GeoJSON.
- Uncertainty es un IEEE 754 binary32 formado concatenando 2 WORD en big-endian (la misma disposición de bits que binary32 de BINARY-FLOAT). Significa que la posición real está dentro de este radio, y el valor se lee en la unidad de Unit.
  - Debe ser finito y `+0` o mayor. Los negativos, `-0` (`8000 0000`), NaN y ±Infinity son invalid.
  - `0` (cuando hay Unit): coordenada exacta. Es igual en cualquier unidad.
- Unit es un Reference que apunta a la unidad de Uncertainty. No acepta Value. El Quantifier es Identified (`000`).
  - Se recomienda usar un elemento de unidad de Wikidata, [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/): grado Q28390, minuto de arco Q209426, segundo de arco Q829073, metro Q11573, milímetro Q174789, etc. Una unidad sin QID se señala con otro Reference (LOCAL, GEUL, etc.). Si hay varios Reference que apuntan a la misma unidad, la forma canónica es el QID.
  - Si Unit es metro (Q11573), Uncertainty es igual al `u` de RFC 5870.
- **Desconocido**: en la posición de Unit se escribe [ABSENT](/es/grammar/reference/slot-marker/) (`0x0000`) y Uncertainty se deja en `+0` (`0000 0000`). Es igual que cuando se omite `u` en RFC 5870. Si es ABSENT y Uncertainty no es `+0`, es invalid (se fija una única representación).
- No contiene la altitud. Si hace falta, se fijará con otro formato. La altitude de Wikidata no se usó en las muestras (0/23.066), y si hay un valor no se convierte y se conserva el original como UTF8-TEXT.
- Para las coordenadas de la Tierra se recomienda usar este formato. Una coordenada que ponga la Tierra (Q2) en COORDINATE-GEO tampoco es invalid, y quien compara las equipara como la misma coordenada.
- El documento de especificación de geul.org `0x0000/0x0000000000000804` pone en los campos de valor en bruto Latitude, Longitude y Uncertainty el [CODEC](/es/grammar/edge/codec/) BINARY-FLOAT (`0803`) (4 WORD = binary64, 2 WORD = binary32), y en el campo de registro Unit los CODEC `0780` (cualquier Reference) y `0000` (ABSENT).

## Longitud

- El total es TAG 1 WORD + 10 WORD + el registro Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| Si el QID cabe en 1 WORD (2 WORD, ejemplo: grado Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| Si el QID es de 2 WORD (3 WORD, ejemplo: minuto de arco Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| Registro Unit de 4 WORD o más | 15 WORD o más | Longitud extendida ([Registro y TAG WORD](/es/grammar/record/)) |

- No hay pares de Codec par/impar.

## Correspondencia con Wikidata

globecoordinate de Wikidata: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | Este formato (Tierra). Los demás cuerpos celestes, COORDINATE-GEO |
| latitude, longitude | binary64 tal cual (el valor de Wikidata ya es binary64 y no hay pérdida) |
| precision (grados) | Uncertainty y Unit. Véase "Precisión" abajo |
| precision null o ausente | Unit = ABSENT, Uncertainty = `+0` (desconocido) |
| altitude | Se descarta (siempre null) |

- La precision de Wikidata no es un error de medición sino una **resolución de registro** (en qué unidades de grado, minuto o segundo se anotó la coordenada). Uncertainty de GEUL traslada ese valor sin cambiarlo. No es un radio al que se hayan sumado el error de medición ni el del sistema de coordenadas.

### Precisión

La precision se traslada sin conversión. Se elige la primera unidad entre grado, minuto de arco y segundo de arco que recupere la notación original.

| precision original (ejemplo) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k grados) | grado Q28390 | el binary32 de ese valor |
| Notación decimal corta como `0.0166667` | grado Q28390 | el binary32 de ese valor |
| `0.016666666666667` (1/60°) | minuto de arco Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | segundo de arco Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | segundo de arco Q829073 | `0.1` |

- Conversión directa: en el orden grado, minuto de arco (×60), segundo de arco (×3600), se toma como Uncertainty el binary32 más cercano al valor de la precision multiplicado por el número de unidades, y se usa la primera unidad cuya conversión inversa de abajo devuelva tal cual la notación original de la precision.
- Conversión inversa: la notación decimal más corta de Uncertainty (el número más corto que se vuelve a leer como ese binary32) se divide por el número de unidades para pasarlo a grados, y se escribe como lo hace Wikibase en el volcado (14 cifras significativas; por debajo de `1e-4`, notación exponencial `1.0e-6`, `2.7777777777778e-5`). La base de datos cargada (jsonb) lo guarda en notación decimal `0.0000010`, `0.000027777777777778`.
- Si ninguna unidad recupera el original (notación de 17 cifras significativas `0.0002777777777777778`, valores atípicos que parecen calculados, etc.), no se convierte toda la coordenada y se conserva el original como UTF8-TEXT. Lo mismo ocurre con una precision negativa y con un cuerpo celeste vacío.
- Muestra Q1–Q10000 de Wikidata (7.026 declaraciones de coordenadas, 6.824 con precision): 5.933 recuperaron el original (86,9%; grado 4.104, segundo de arco 1.370, minuto de arco 459). De las 891 que no, 753 son de la serie 1/3600 y 1/60 con notación de 17 cifras significativas.

## Ejemplo

Berlín 52.516666666667, 13.383333333333, precision 1/60° (1 minuto de arco):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0120 0003 3212` (WIKIDATA-QID Q209426, minuto de arco).
- Notación de texto: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

El mismo punto con incertidumbre desconocida: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Base estándar

- Significado: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — orden latitud, longitud, incertidumbre `u` (metros), sistema de coordenadas por defecto WGS 84. Si Unit es metro, Uncertainty = `u`.
- Numérico: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitud y longitud), binary32 (incertidumbre).
- Orden de ejes y rango: ISO 6709 (Standard representation of geographic point location by coordinates).
- Unidad: elemento de unidad de Wikidata (QID). La disposición de ancho fijo, el campo Unit y la expresión de desconocido son reglas de GEUL.

## Problemas abiertos

1. Altitud.
2. El formato que conserva la cadena original de ISO 6709 (COORDINATE-ISO6709) se fijará cuando haya usos.
3. Cómo trasladar sin pérdida la notación de 17 cifras significativas de la precision de Wikidata (alrededor del 11% de la muestra).

## Páginas relacionadas

- [Value](/es/grammar/value/), [COORDINATE-GEO](/es/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/es/grammar/value/numeric/binary-float/), [Marcador de posición](/es/grammar/reference/slot-marker/)
- El formato Issuer [POINT2-BINARY64](/es/grammar/value/vector/point2-binary64/) es un punto bidimensional general que deja al contexto externo el sistema de coordenadas, la unidad y el sentido de los ejes, mientras que este formato es una coordenada geográfica sobre la Tierra.
