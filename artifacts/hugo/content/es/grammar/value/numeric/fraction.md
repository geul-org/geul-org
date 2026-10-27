---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION es un Value de fracción que guarda el numerador (entero o decimal) y el denominador (entero o decimal sin signo) tal como están escritos en el original, sin simplificar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION es un Value que expresa una fracción escrita en un texto original conservando su notación. Es el código directo de Value `0x07`, de la familia NUMERIC. El numerador y el denominador son cada uno un registro Value completo. No se simplifica. Guarda fracciones cuya forma escrita es en sí el registro, como "dos tercios" o "cinco por ciento" en las leyes y la cuota decimal `23.45/1256.1` en un registro de la propiedad.

## Layout

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[TAG de extensión de Length] si el total es de 15 WORD o más
numerator         un registro Value: SIGNED-INTEGER o SIGNED-DECIMAL
denominator       un registro Value: UNSIGNED-INTEGER o UNSIGNED-DECIMAL
```

## Interpretación y validez

- numerator es exactamente un registro [SIGNED-INTEGER](/es/grammar/value/numeric/signed-integer/) (`0x01`) o [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/) (`0x10`).
- denominator es exactamente un registro [UNSIGNED-INTEGER](/es/grammar/value/numeric/unsigned-integer/) (`0x02`) o [UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/) (`0x11`).
- Es una lista cerrada. No se admiten otros Values, la propia FRACTION (sin anidamiento) ni marcadores de posición (`0x0000`, etc.).
- Cada uno de los dos registros lleva su propia longitud, así que no se escribe un límite aparte. El cursor tras leer los dos registros debe coincidir exactamente con el final del Payload.
- Los registros internos también siguen la forma canónica de su Codec (mínimo de WORD para enteros y coefficient). Si un registro interno no es canónico, toda la FRACTION es invalid.
- El valor es `numerator / denominator`.

### Conservación de la notación

- **Entero y decimal**: si un componente del original es entero (sin punto decimal), se usa un registro INTEGER; si tiene punto decimal, un registro DECIMAL. Escribir un componente como DECIMAL con exponente `E = 0` es invalid. Así, una misma notación tiene una sola secuencia de bytes.
- C y E de un componente DECIMAL conservan tal cual los dígitos del original. `23.450` es `23450×10^-3`, un Value distinto de `23.45`.
- **No se simplifica.** `2/4` y "cinco por ciento" (`5/100`) se escriben tal cual. Si los bytes son iguales, la notación original es la misma.
- Una fracción con denominador 1 (`3/1`) también se escribe tal cual si el original la escribió así. Si el original es un entero, se usa un Codec entero en lugar de FRACTION. Si el original es un decimal (`0.5`, `5%`), se usa DECIMAL.
- El signo va solo en el numerador. El denominador es un Codec sin signo.
- Un denominador de valor 0 es invalid (tanto `0` como `0.0`).

### Comparación

- La capa de comparación calcula una FRACTION como el número racional exacto `(C1 × 10^E1) / (C2 × 10^E2)` (`E = 0` para un componente INTEGER). No aproxima con punto flotante.
- La comparación, la ordenación y la detección de duplicados usan este valor; el almacenamiento, las firmas y los hashes de contenido usan la notación (bytes). `2/4`, `1/2` y `0.5` tienen el mismo valor y bytes distintos.
- Una comprobación de quórum ("al menos dos tercios de los votos de los accionistas presentes") se compara con este valor exacto.

## Longitud

- El total es 1 WORD de TAG + (TAG de extensión de Length) + los dos registros. Un registro entero tiene 1 WORD de TAG + al menos 1 WORD de Payload, y un registro decimal tiene 1 WORD de TAG + 2 de exponente + al menos 1 WORD de coefficient.
- Una fracción entera pequeña ocupa 5 WORD, y una fracción decimal pequeña, 9 WORD. Desde 15 WORD se usa la longitud extendida ([Registros y TAG WORD](/es/grammar/record/)).

| Original | Componentes | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Ejemplo

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`, 5 WORD), numerator `0881 0002` (SIGNED-INTEGER 2), denominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD), numerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relación con otros formatos

- amount, lower y upper de [QUANTITY](/es/grammar/value/numeric/quantity/) admiten FRACTION. "Dos tercios de los votos presentes" puede escribirse como una QUANTITY sin unidad con amount `2/3`.
- El documento de especificación de geul.org `0x0000/0x0000000000000807` lo escribe con dos campos de registro: numerator (`0801`, `0810`) y denominator (`0802`, `0811`) ([documento de especificación de Codec](/es/grammar/codec-spec/)).
- Si se necesita una fracción int64 fija con simplificación obligatoria, se usa el formato Issuer [RATIONAL-I64](/es/grammar/value/etc/rational-i64/).

## Problemas abiertos

1. La conservación de la notación de los números mixtos (`1 y 2/3`).
2. Un formato que guarde como dos QUANTITY una fracción cuyos componentes tienen unidad (superficie/superficie). FRACTION no guarda unidades.
3. El criterio de notación para porcentajes y por miles (`5%`, `5‰`): DECIMAL con unidad o FRACTION (`5/100`).
4. Las fracciones compuestas (FRACTION en el numerador o el denominador). Por ahora están prohibidas.

## Páginas relacionadas

- [Value](/es/grammar/value/), [QUANTITY](/es/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/es/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/es/grammar/value/etc/rational-i64/)
