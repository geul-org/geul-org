---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH es el Value de coordenadas que representa un punto de la Tierra mediante latitud, longitud e incertidumbre."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `COORDINATE-EARTH` (documento de especificación BIND `COORDINATE-EARTH`) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| Documento de especificación | `0x00000000/codecs/0x00000640/` (destino de DECLARE `0640`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 4 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | latitud y longitud terrestres (WGS 84) en binary64, incertidumbre en binary32 y el Reference de su unidad (ABSENT = desconocida) |
| Lado Hugo | `value/numeric/coordinate-earth.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | valor en bruto, 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | valor en bruto, 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | valor en bruto, 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `0000` ABSENT (campo opcional) |  |

COORDINATE-EARTH es el Value de coordenadas que representa un punto de la Tierra mediante latitud, longitud e incertidumbre. Su código directo de Value es `0x064L` y su familia es NUMERIC. Su significado es el mismo que el de `geo:latitud,longitud;u=incertidumbre` del [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI; sistema de coordenadas WGS 84), y se guarda como valores numéricos de ancho fijo, no como cadena. La incertidumbre se escribe junto con su unidad. Las coordenadas de cuerpos celestes fuera de la Tierra se escriben con [COORDINATE-GEO](0x065L-coordinate-geo.md) (`0x065L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD en bruto, IEEE 754 binary64 (grados)
Longitude         4 WORD en bruto, IEEE 754 binary64 (grados)
Uncertainty       2 WORD en bruto, IEEE 754 binary32 (en unidades de Unit)
Unit              1 registro Reference, o el marcador de posición 0x0000 ABSENT
```

## Interpretación y validez {#해석과-유효성}

- El Payload es Latitude de 4 WORD, Longitude de 4 WORD y Uncertainty de 2 WORD, seguidos de exactamente un registro Unit. El cursor tras leer Unit debe coincidir con el final del registro.
- El sistema de coordenadas es WGS 84 (el `crs=wgs84` predeterminado del RFC 5870).
- Latitude y Longitude son IEEE 754 binary64 formados al concatenar los WORD del Payload en orden big-endian (la misma disposición de bits que binary64 de [BINARY-FLOAT](0x063L-binary-float.md)). La unidad es el grado (°).
  - Deben ser valores finitos. NaN y ±Infinity son invalid.
  - Latitude cumple `-90 ≤ φ ≤ 90` (el norte es positivo) y Longitude cumple `-180 ≤ λ ≤ 180` (el este es positivo).
  - El orden de los ejes es latitud, longitud (igual que en RFC 5870 e ISO 6709). No es el orden x (longitud), y (latitud) de WKB y GeoJSON.
- Uncertainty es un IEEE 754 binary32 formado al concatenar 2 WORD en big-endian (la misma disposición de bits que binary32 de BINARY-FLOAT). Significa que la posición real está dentro de este radio, y el valor se lee en unidades de Unit.
  - Debe ser finito y mayor o igual que `+0`. Un negativo, `-0` (`8000 0000`), NaN y ±Infinity son invalid.
  - `0` (cuando hay Unit): coordenada exacta. Es igual en cualquier unidad.
- Unit es un Reference que señala la unidad de Uncertainty. No admite Value. Su Quantifier es Identified.
  - Se recomienda usar un elemento de unidad de Wikidata, [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md): grado Q28390, minuto de arco Q209426, segundo de arco Q829073, metro Q11573, milímetro Q174789, etc. Una unidad sin QID se señala con otro Reference (LOCAL, GEUL, etc.). Si varios Reference señalan la misma unidad, la forma canónica es el QID.
  - Si Unit es el metro (Q11573), Uncertainty es igual a la `u` del RFC 5870.
- **Desconocida**: se escribe [ABSENT](../slot-marker.md) (`0x0000`) en la posición de Unit y Uncertainty se deja en `+0` (`0000 0000`). Es lo mismo que omitir `u` en RFC 5870. Si es ABSENT pero Uncertainty no es `+0`, es invalid (se fija una única representación).
- No se guarda la altitud. Si hace falta, se definirá en un formato aparte. La altitude de Wikidata no se usó en la muestra (0/23,066), y si tiene valor no se convierte y se conserva el texto original en UTF8-TEXT.
- Se recomienda usar este formato para las coordenadas terrestres. Una coordenada que indique la Tierra (Q2) en COORDINATE-GEO tampoco es invalid; quien compara la trata como la misma coordenada.
- El documento de especificación de geul.org `0x00000000/codecs/0x00000640` coloca [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) en los campos en bruto Latitude, Longitude y Uncertainty (4 WORD = binary64, 2 WORD = binary32), y coloca CODEC `000F`, `020F`, `040F` (cualquier Reference) y `0000` (ABSENT) en el campo de registro Unit.

## Longitud {#길이}

- El total es 1 WORD de TAG + 10 WORD + el registro Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| El QID cabe en 1 WORD (2 WORD, p. ej. grado Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| El QID ocupa 2 WORD (3 WORD, p. ej. minuto de arco Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| Registro Unit de 4 WORD o más | 15 WORD o más | longitud extendida ([registro y TAG WORD](../record.md)) |

- No se define un par de Codec par/impar.

## Correspondencia con Wikidata {#위키데이터-대응}

globecoordinate de Wikidata: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | este formato (la Tierra). Para otros cuerpos celestes, COORDINATE-GEO |
| latitude, longitude | binary64 tal cual (el valor de Wikidata ya es binary64, por lo que no hay pérdida) |
| precision (grados) | Uncertainty y Unit. Véase «Precisión» más abajo |
| precision null o ausente | Unit = ABSENT, Uncertainty = `+0` (desconocida) |
| altitude | se descarta (siempre null) |

- La precision de Wikidata no es un error de medición, sino la **resolución del registro** (en qué unidad de grados, minutos o segundos se anotó la coordenada). Uncertainty de GEUL traslada ese valor sin modificarlo. No es un radio al que se hayan sumado errores de medición o del sistema de coordenadas.

### Precisión {#정밀도}

La precision se traslada sin conversión. Se elige la primera unidad, entre grado, minuto de arco y segundo de arco, que permita recuperar la notación original.

| Texto original de precision (ejemplo) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k grados) | grado Q28390 | el binary32 de ese valor |
| notación decimal corta como `0.0166667` | grado Q28390 | el binary32 de ese valor |
| `0.016666666666667` (1/60°) | minuto de arco Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | segundo de arco Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | segundo de arco Q829073 | `0.1` |

- Conversión directa: en el orden grado, minuto de arco (×60), segundo de arco (×3600), se toma como Uncertainty el binary32 más cercano al valor de precision multiplicado por el número de unidades, y se usa la primera unidad para la cual la conversión inversa de abajo devuelve exactamente el texto original de precision.
- Conversión inversa: se divide la notación decimal más corta de Uncertainty (el número más corto que se vuelve a leer como ese binary32) por el número de unidades para pasarla a grados, y se escribe como lo hace Wikibase en el volcado (14 cifras significativas; por debajo de `1e-4`, notación exponencial `1.0e-6`, `2.7777777777778e-5`). La base de datos de carga (jsonb) lo guarda en notación decimal `0.0000010`, `0.000027777777777778`.
- Si ninguna unidad recupera el texto original (notación de 17 cifras significativas `0.0002777777777777778`, valores atípicos que parecen calculados, etc.), no se convierte la coordenada entera y se conserva el texto original en UTF8-TEXT. Lo mismo ocurre con una precision negativa y con un cuerpo celeste vacío.
- Muestra de Wikidata Q1–Q10000 (7,026 declaraciones de coordenadas, 6,824 con precision): 5,933 recuperaron el texto original (86.9%; grado 4,104, segundo de arco 1,370, minuto de arco 459). De las 891 que no lo recuperaron, 753 pertenecen a la serie 1/3600 y 1/60 con notación de 17 cifras significativas.

## Ejemplo {#예시}

Berlín 52.516666666667, 13.383333333333, precision 1/60° (1 minuto de arco):

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0142 0003 3212` (WIKIDATA-QID Q209426, minuto de arco).
- Notación de texto: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

El mismo punto con incertidumbre desconocida: `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Fundamento normativo {#표준-근거}

- Significado: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — orden latitud, longitud; incertidumbre `u` (metros); sistema de coordenadas predeterminado WGS 84. Si Unit es el metro, Uncertainty = `u`.
- Numérico: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitud, longitud), binary32 (incertidumbre).
- Orden y rango de los ejes: ISO 6709 (Standard representation of geographic point location by coordinates).
- Unidad: elementos de unidad de Wikidata (QID). La disposición de ancho fijo, el campo Unit y la representación de desconocida son reglas de GEUL.

## Problemas abiertos {#열린-문제}

1. La altitud.
2. El formato que conserve el texto original en cadena ISO 6709 (COORDINATE-ISO6709) se definirá cuando aparezca un uso.
3. Una forma de trasladar sin pérdida la notación de 17 cifras significativas de la precision de Wikidata (cerca del 11% de la muestra).

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [marcador de posición](../slot-marker.md)
- El formato de Issuer [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) es un punto bidimensional general que deja el sistema de coordenadas, la unidad y el significado de los ejes al contexto externo; este formato es una coordenada geográfica sobre la Tierra.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000640/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
