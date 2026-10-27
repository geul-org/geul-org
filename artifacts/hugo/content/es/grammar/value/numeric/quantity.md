---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY es un Value que expresa una cantidad con cuatro registros: una cantidad decimal exacta, una Reference de unidad y un límite inferior y uno superior."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY es un Value que expresa una cantidad con un decimal exacto, una unidad y un límite inferior y uno superior. Es el código directo de Value `0x06`, de la familia NUMERIC. Cada una de las cuatro partes es un registro completo. La unidad y los límites son [campos opcionales](/es/grammar/codec-spec/); si se omiten, se escribe ABSENT (`0x0000`).

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[TAG de extensión de Length] si el total es de 15 WORD o más
amount            registro Value SIGNED-DECIMAL
unit              registro Reference (elemento de unidad); 0x0000 si no tiene unidad
lower             registro Value SIGNED-DECIMAL; 0x0000 ABSENT si se omite
upper             registro Value SIGNED-DECIMAL; 0x0000 ABSENT si se omite
```

## Interpretación y validez

- amount es un [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/) `C×10^E`. C y E conservan tal cual los dígitos de la notación original: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Son el mismo número, pero tienen distintas cifras significativas, así que son Values distintos. El coefficient no tiene límite de dígitos (complemento a dos en el mínimo de WORD, longitud variable).
- unit es exactamente un registro Reference completo o `0x0000`. Sirve cualquier Reference que apunte a un elemento de unidad (las unidades de Wikidata son WIKIDATA-QID). `0x0000` significa sin unidad (conteos, razones, población, etc.).
- lower y upper son cada uno un registro SIGNED-DECIMAL o `0x0000`. Basta con que haya uno de los dos. Un rango simétrico (`652 ± 1`) también se escribe con límite inferior y superior (`651`, `653`). Como los rangos asimétricos exigen de todos modos dos valores, no hay un formato que lo reduzca a un único ±.
- La unidad es parte del valor. No se separa la unidad en un QUALIFIER ni similar (si se separa, no se sabe si `652` son km o m).
- No se guarda el valor convertido a unidades SI. Es un valor derivado que se puede calcular a partir de la unidad y de una tabla de conversión.
- El cursor, tras leer los cuatro registros, debe coincidir exactamente con el final del Payload. Cualquier otra forma es invalid.
- El documento de especificación de geul.org lo escribe con cuatro campos de registro: amount (`0810`), unit (`0780`·`0000`), lower y upper (`0810`·`0000`) ([Documento de especificación de Codec](/es/grammar/codec-spec/)).

## Longitud

- El total es 1 WORD de TAG + (TAG de extensión de Length) + los cuatro registros. Un registro decimal tiene 1 WORD de TAG + 2 de exponente + al menos 1 WORD de coefficient.
- Un número pequeño sin unidad ni límites ocupa 8 WORD. Desde 15 WORD se usa la longitud extendida ([Registros y TAG WORD](/es/grammar/record/)).

## Ejemplo

`1.20` sin unidad:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower y upper `0000`.

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
- La unit `"1"` es sin unidad (`0x0000`) y `http://www.wikidata.org/entity/Qn` es un WIKIDATA-QID. Las demás unidades, y los números o límites con formato incorrecto, no se convierten: se conserva el texto original como UTF8-TEXT.
- Muestra de Wikidata (unos 42 000 quantity del comienzo del dump): 61 % sin unidad, 13 % con límites (de ellos, 93 % simétricos), el amount más largo tiene 31 caracteres.

## Fundamento en estándares

- Notación decimal y conservación de dígitos: los conceptos de coefficient, exponent y quantum del decimal de [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL de GEUL).
- Modelo de cantidad de Wikidata: `QuantityValue` de Wikibase DataModel.

## Páginas relacionadas

- [Value](/es/grammar/value/), [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/es/grammar/value/numeric/coordinate-geo/), [CODEC](/es/grammar/edge/codec/), [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/)
