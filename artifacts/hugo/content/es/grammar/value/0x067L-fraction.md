---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION es el Value que representa una fracción tal como está escrita en el texto original, con su notación intacta."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `FRACTION` (documento de especificación BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| Documento de especificación | `0x00000000/codecs/0x00000670/` (destino de DECLARE `0670`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 7 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | fracción que conserva la notación original: numerador entero o decimal, denominador entero o decimal sin signo. No se simplifica |
| Lado Hugo | `value/numeric/fraction.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | registro | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | registro | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION es el Value que representa una fracción tal como está escrita en el texto original, con su notación intacta. Su código directo de Value es `0x067L` y su familia es NUMERIC. El numerador y el denominador son, cada uno, un registro de Value completo. No se simplifica. Contiene fracciones cuyo registro es precisamente lo escrito, como «dos tercios» o «cinco centésimos» de una ley y la cuota decimal de un registro de la propiedad `23.45/1256.1`.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
numerator         1 registro Value: SIGNED-INTEGER o SIGNED-DECIMAL
denominator       1 registro Value: UNSIGNED-INTEGER o UNSIGNED-DECIMAL
```

## Interpretación y validez {#해석과-유효성}

- numerator es exactamente un registro [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`) o [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`).
- denominator es exactamente un registro [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`) o [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`).
- Es una lista cerrada. No admite otros Value, al propio FRACTION (se prohíbe el anidamiento) ni marcadores de posición (`0x0000`, etc.).
- Cada uno de los dos registros tiene su propia longitud, por lo que no se escribe el límite aparte. El cursor tras leer los dos registros debe coincidir exactamente con el final del Payload.
- Los registros internos también siguen la forma canónica de cada Codec (los enteros y el coefficient con el mínimo de WORD). Si hay un registro interno no canónico, todo el FRACTION es invalid.
- El valor es `numerator / denominator`.

### Conservación de la notación {#표기-보존}

- **Enteros y decimales**: si un componente del texto original es entero (sin punto decimal) se usa un registro INTEGER, y si tiene punto decimal, un registro DECIMAL. Escribir un componente como DECIMAL con exponente `E = 0` es invalid. Así, una misma notación tiene una única secuencia de bytes.
- C y E de un componente DECIMAL son el número de cifras del texto original tal cual. `23.450` es `23450×10^-3` y es un Value distinto de `23.45`.
- **No se simplifica.** `2/4` y «cinco centésimos» (`5/100`) se escriben tal cual. Si los bytes son iguales, la notación original es la misma.
- Una fracción con denominador 1 (`3/1`) también se escribe tal cual si el texto original lo escribía así. Si el texto original es un entero, no se usa FRACTION sino un Codec entero. Si el texto original es un decimal (`0.5`, `5%`), se usa DECIMAL.
- El signo va solo en el numerador. El denominador es un Codec sin signo.
- Si el valor del denominador es 0, es invalid (tanto `0` como `0.0`).

### Comparación {#비교}

- La capa de comparación calcula FRACTION como el número racional exacto `(C1 × 10^E1) / (C2 × 10^E2)` (los componentes INTEGER con `E = 0`). No se aproxima con coma flotante.
- La comparación, la ordenación y la detección de duplicados se hacen con este valor, mientras que el almacenamiento, la firma y el hash de contenido se hacen con la notación (los bytes). `2/4`, `1/2` y `0.5` tienen el mismo valor y bytes distintos.
- La comprobación de quórum («dos tercios o más del derecho de voto de los accionistas presentes») se compara con este valor exacto.

## Longitud {#길이}

- El total es 1 WORD de TAG + (TAG de extensión de Length) + los dos registros. Un registro entero es 1 WORD de TAG + 1 WORD de Payload o más, y un registro decimal es 1 WORD de TAG + 2 de exponente + 1 WORD de coefficient o más.
- Una fracción entera pequeña son 5 WORD y una fracción decimal pequeña, 9 WORD. A partir de 15 WORD se usa la longitud extendida ([registro y TAG WORD](../record.md)).

| Texto original | Componentes | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Ejemplo {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`, 5 WORD), numerator `0611 0002` (SIGNED-INTEGER 2), denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD), numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relación con otros formatos {#다른-형식과의-관계}

- amount, lower y upper de [QUANTITY](0x066L-quantity.md) admiten FRACTION. «Dos tercios del derecho de voto de los presentes» se puede escribir como un QUANTITY sin unidad con amount `2/3`.
- El documento de especificación de geul.org `0x00000000/codecs/0x00000670` lo describe con dos campos de registro: numerator (`0610`·`0680`) y denominator (`0620`·`0690`) ([documento de especificación de Codec](../codec-spec.md)).
- Si se necesita una fracción int64 fija que obligue a simplificar, se usa el formato de Issuer [RATIONAL-I64](adhoc.geul.org/rational-i64.md).

## Problemas abiertos {#열린-문제}

1. La conservación de la notación de las fracciones mixtas (`1 y 2/3`).
2. Un formato que contenga en dos QUANTITY una fracción cuyos componentes tienen unidad (área/área). FRACTION no contiene unidad.
3. El criterio de notación sobre si los porcentajes y los por mil (`5%`, `5‰`) se escriben como DECIMAL con unidad o como FRACTION (`5/100`).
4. Las fracciones complejas (FRACTION en el numerador o el denominador). Por ahora está prohibido.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000670/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
