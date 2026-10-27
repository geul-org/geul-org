---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY es un Value que expresa una cantidad con cuatro registros: una cantidad que es un registro Value numérico (entero, BINARY-FLOAT, decimal, fracción), una Reference de unidad y un límite inferior y uno superior."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY es un Value que expresa una cantidad con un número, una unidad y un límite inferior y uno superior. Es el código directo de Value `0x06`, de la familia NUMERIC. Cada una de las cuatro partes es un registro completo. La unidad y los límites son [campos opcionales](/es/grammar/codec-spec/); si se omiten, se escribe ABSENT (`0x0000`).

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[TAG de extensión de Length] si el total es de 15 WORD o más
amount            registro Value numérico (entero, BINARY-FLOAT, decimal, fracción)
unit              registro Reference (elemento de unidad); 0x0000 si no tiene unidad
lower             registro Value numérico; 0x0000 ABSENT si se omite
upper             registro Value numérico; 0x0000 ABSENT si se omite
```

## Interpretación y validez

- amount es exactamente un registro Value numérico completo. Admite seis Codecs: [SIGNED-INTEGER](/es/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/es/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/es/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/es/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/) (`0x10`) y [UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/) (`0x11`). Es una lista cerrada, no un comodín. No se admiten BOOL, COORDINATE-EARTH ni COORDINATE-GEO, la propia QUANTITY (sin anidamiento, profundidad fija) ni otros Values. En amount no se puede escribir un marcador de posición (`0x0000`, etc.).
- Los registros internos también siguen la forma canónica de su Codec (mínimo de WORD para enteros y coefficient, 1/2/4/8 WORD para BINARY-FLOAT, FRACTION según sus propias reglas). Si un registro interno no es canónico, toda la QUANTITY es invalid.
- Si amount, lower o upper es BINARY-FLOAT, debe ser un valor finito. NaN y ±Infinity son invalid (la misma regla que la latitud y la longitud de [COORDINATE-EARTH](/es/grammar/value/numeric/coordinate-earth/)).
- El formato numérico sigue tal cual la notación original. Un original entero se guarda como INTEGER, uno con decimales como DECIMAL, una fracción como FRACTION y un valor binario IEEE 754 como BINARY-FLOAT; el codificador no normaliza cambiando el formato. C y E de un DECIMAL conservan tal cual los dígitos de la notación original: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Son el mismo número, pero tienen distintas cifras significativas, así que son Values distintos. Los enteros y el coefficient no tienen límite de dígitos (mínimo de WORD, longitud variable).
- unit es exactamente un registro Reference completo o `0x0000`. Sirve cualquier Reference que apunte a un elemento de unidad (las unidades de Wikidata son WIKIDATA-QID). `0x0000` significa sin unidad (conteos, razones, población, etc.).
- lower y upper son cada uno un registro de uno de los mismos seis Codecs que amount, o `0x0000` ABSENT. El único marcador de posición admitido es la omisión ABSENT. Basta con que haya uno de los dos. Los tres números no necesitan el mismo Codec. Un rango simétrico (`652 ± 1`) también se escribe con límite inferior y superior (`651`, `653`). Como los rangos asimétricos exigen de todos modos dos valores, no hay un formato que lo reduzca a un único ±.
- lower ≤ amount ≤ upper se compara por valor numérico, no por bytes ni por Codec. Aunque los tipos difieran, se comparan como números (p. ej., SIGNED-INTEGER `652` y SIGNED-DECIMAL `651.5`). FRACTION se compara como número racional exacto.
- La unidad es parte del valor. No se separa la unidad en un QUALIFIER ni similar (si se separa, no se sabe si `652` son km o m).
- Al extraer el registro amount, es tal cual un registro Value independiente. Si se necesita el número sin unidad, se usa ese registro sin volver a codificar.
- No se guarda el valor convertido a unidades SI. Es un valor derivado que se puede calcular a partir de la unidad y de una tabla de conversión.
- El cursor, tras leer los cuatro registros, debe coincidir exactamente con el final del Payload. Cualquier otra forma es invalid.
- El documento de especificación de geul.org lo escribe con cuatro campos de registro: amount (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`), unit (`0780`·`0000`), lower y upper (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`·`0000`) ([Documento de especificación de Codec](/es/grammar/codec-spec/)).

## Longitud

- El total es 1 WORD de TAG + (TAG de extensión de Length) + los cuatro registros. Un registro entero tiene 1 WORD de TAG + al menos 1 WORD de Payload, un registro BINARY-FLOAT tiene 2, 3, 5 o 9 WORD y un registro decimal tiene 1 WORD de TAG + 2 de exponente + al menos 1 WORD de coefficient. Un registro FRACTION tiene 5 WORD o más.
- Un entero pequeño sin unidad ni límites ocupa 6 WORD, y un decimal pequeño, 8 WORD. Desde 15 WORD se usa la longitud extendida ([Registros y TAG WORD](/es/grammar/record/)).

## Ejemplo

`1.20` sin unidad:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower y upper `0000`.

Entero `42` sin unidad:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit, lower y upper `0000`.

Fracción `2/3` sin unidad (dos tercios de los votos presentes):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/es/grammar/value/numeric/fraction/) 2/3), unit, lower y upper `0000`.

`652 km`, rango `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- Son 17 WORD en total, por lo que `LLLL=1110`, y el TAG de extensión es `0011`.

## Correspondencia con Wikidata

- El datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` pasa a amount, unit, lower y upper. El amount y las cadenas de los límites (`+1.20`, incluida la notación exponencial) se pasan a C y E conservando los dígitos.
- El amount y los límites de Wikidata son cadenas decimales, así que, aunque tengan forma de entero (`+652`), se pasan a SIGNED-DECIMAL. La conversión de Wikidata no usa otros Codecs numéricos.
- La unit `"1"` es sin unidad (`0x0000`) y `http://www.wikidata.org/entity/Qn` es un WIKIDATA-QID. Las demás unidades, y los números o límites con formato incorrecto, no se convierten: se conserva el texto original como UTF8-TEXT.
- Muestra de Wikidata (unos 42 000 quantity del comienzo del dump): 61 % sin unidad, 13 % con límites (de ellos, 93 % simétricos), el amount más largo tiene 31 caracteres.

## Fundamento en estándares

- Notación decimal y conservación de dígitos: los conceptos de coefficient, exponent y quantum del decimal de [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL de GEUL).
- Modelo de cantidad de Wikidata: `QuantityValue` de Wikibase DataModel.

## Páginas relacionadas

- [Value](/es/grammar/value/), [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/es/grammar/value/numeric/coordinate-geo/), [CODEC](/es/grammar/edge/codec/), [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/)
