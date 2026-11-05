---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY es el Value que representa una cantidad mediante un número, una unidad y un límite inferior y otro superior."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `QUANTITY` (documento de especificación BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| Documento de especificación | `0x00000000/codecs/0x00000660/` (destino de DECLARE `0660`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 6 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | amount como Value numérico (entero, BINARY-FLOAT, decimal, fracción), Reference de unidad, límites inferior y superior. La unidad y los límites se pueden omitir (ABSENT `0x0000`) |
| Lado Hugo | `value/numeric/quantity.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | registro | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `0000` ABSENT (campo opcional) |  |
| 3 | `lower` | #4 | registro | `0680` SIGNED-DECIMAL, `0000` ABSENT (campo opcional), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | registro | `0680` SIGNED-DECIMAL, `0000` ABSENT (campo opcional), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY es el Value que representa una cantidad mediante un número, una unidad y un límite inferior y otro superior. Su código directo de Value es `0x066L` y su familia es NUMERIC. Cada una de las cuatro partes es un registro completo. La unidad y los límites son [campos opcionales](../codec-spec.md), por lo que si se omiten se escribe ABSENT (`0x0000`).

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
amount            registro de Value numérico (entero, BINARY-FLOAT, decimal, fracción)
unit              registro Reference (elemento de unidad), 0x0000 si no tiene unidad
lower             registro de Value numérico, 0x0000 ABSENT si se omite
upper             registro de Value numérico, 0x0000 ABSENT si se omite
```

## Interpretación y validez {#해석과-유효성}

- amount es exactamente un registro de Value numérico completo. Los Codec que admite son seis: [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`), [FRACTION](0x067L-fraction.md) (`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`) y [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). Es una lista cerrada, no un comodín. No admite BOOL, COORDINATE-EARTH·COORDINATE-GEO, el propio QUANTITY (se prohíbe el anidamiento, la profundidad es fija) ni ningún otro Value. En amount no se puede usar un marcador de posición (`0x0000`, etc.).
- Los registros internos también siguen la forma canónica de cada Codec (los enteros y el coefficient con el mínimo de WORD, BINARY-FLOAT de 1/2/4/8 WORD, FRACTION con sus reglas). Si hay un registro interno no canónico, todo el QUANTITY es invalid.
- Si amount, lower o upper son BINARY-FLOAT, deben ser valores finitos. NaN y ±Infinity son invalid (la misma regla que para la latitud y la longitud de [COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- El formato del número sigue tal cual la notación original. Una notación entera se guarda como INTEGER, una decimal como DECIMAL, una fraccionaria como FRACTION y un valor binario IEEE 754 como BINARY-FLOAT; el codificador no cambia el formato para normalizar. C y E de DECIMAL guardan tal cual el número de cifras de la notación original: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Los dos valores son el mismo número, pero sus cifras significativas son distintas, por lo que son Value distintos. No hay límite en el número de cifras del entero ni del coefficient (mínimo de WORD, longitud variable).
- unit es exactamente un registro Reference completo o `0x0000`. Se puede usar cualquier Reference que señale un elemento de unidad (las unidades de Wikidata son WIKIDATA-QID). `0x0000` significa sin unidad (conteo, proporción, población, etc.).
- lower y upper son, cada uno, un registro de uno de los mismos seis Codec que amount, o `0x0000` ABSENT. Como marcador de posición solo se admite la omisión ABSENT. Basta con que exista uno de los dos. No es necesario que los Codec de los tres números sean iguales.
- lower ≤ amount ≤ upper se compara por valor numérico, no por bytes ni por Codec. Se compara como números aunque los tipos sean distintos (p. ej., SIGNED-INTEGER `652` y SIGNED-DECIMAL `651.5`). FRACTION se compara como número racional exacto. Un rango simétrico (`652 ± 1`) también se escribe con los dos límites (`651`, `653`). Como existen rangos asimétricos y de todos modos hacen falta dos valores, no se define un formato que lo reduzca a un único ±.
- La unidad forma parte del valor. No se separa la unidad con un QUALIFIER ni similar (si se separa, no se sabe si `652` son km o m).
- Un registro amount extraído es, tal cual, un registro de Value independiente. Si se necesita el número sin la unidad, se usa ese registro sin volver a codificar.
- No se guarda el valor convertido a unidades del SI. Es un valor derivado que se puede calcular a partir de la unidad y de una tabla de conversión.
- El cursor tras leer los cuatro registros debe coincidir exactamente con el final del Payload. Cualquier otra forma es invalid.
- El documento de especificación de geul.org lo describe con cuatro campos de registro: amount (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`), unit (`000F`·`020F`·`040F`·`0000`) y lower·upper (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`·`0000`) ([documento de especificación de Codec](../codec-spec.md)).

## Longitud {#길이}

- El total es 1 WORD de TAG + (TAG de extensión de Length) + los cuatro registros. Un registro entero es 1 WORD de TAG + 1 WORD de Payload o más, un registro BINARY-FLOAT es de 2·3·5·9 WORD, un registro decimal es 1 WORD de TAG + 2 de exponente + 1 WORD de coefficient o más, y un registro FRACTION es de 5 WORD o más.
- Un entero pequeño sin unidad ni límites son 6 WORD, y un decimal pequeño, 8 WORD. A partir de 15 WORD se usa la longitud extendida ([registro y TAG WORD](../record.md)).

## Ejemplo {#예시}

`1.20` sin unidad:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078` (E = -2, C = 120), unit·lower·upper `0000`.

El entero `42` sin unidad:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD), amount `0611 002A` (SIGNED-INTEGER 42), unit·lower·upper `0000`.

La fracción `2/3` sin unidad (dos tercios del derecho de voto de los presentes):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD), amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3), unit·lower·upper `0000`.

`652 km`, rango `[651, 653]` (km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- Son 17 WORD en total, por lo que `LLLL=1110`, TAG de extensión `0011`.

## Correspondencia con Wikidata {#위키데이터-대응}

- El datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper. El amount y las cadenas de los límites (`+1.20`, incluida la notación exponencial) se trasladan a C y E conservando el número de cifras.
- Como el amount y los límites de Wikidata son cadenas decimales, aunque tengan forma de entero (`+652`) se trasladan como SIGNED-DECIMAL. La conversión de Wikidata no usa otros Codec numéricos.
- La unit `"1"` es sin unidad (`0x0000`) y `http://www.wikidata.org/entity/Qn` es WIKIDATA-QID. Las demás unidades y los números o límites con formato inadecuado no se convierten y se conserva el texto original en UTF8-TEXT.
- Muestra de Wikidata (unas 42 mil quantity al comienzo del volcado): 61% sin unidad, 13% con límites (de ellos 93% simétricos), el amount más largo tiene 31 caracteres.

## Fundamento normativo {#표준-근거}

- Notación decimal y conservación del número de cifras: los conceptos de coefficient, exponent y quantum del decimal de [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL de GEUL).
- Modelo de cantidad de Wikidata: `QuantityValue` de Wikibase DataModel.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000660/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
