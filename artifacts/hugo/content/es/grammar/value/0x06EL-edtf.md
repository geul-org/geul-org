---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF es el Value que contiene fechas como precisión de año o mes, antes de nuestra era, incertidumbre e intervalos, mediante cadenas de fecha extendidas de ISO 8601-2 (Codec 0x06EL/0x06FL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF es el Value que contiene fechas como precisión de año o mes, antes de nuestra era, incertidumbre e intervalos, mediante cadenas de fecha extendidas de ISO 8601-2 (Codec 0x06EL/0x06FL).

| Elemento | Valor |
|---|---|
| Nombre | `EDTF` (grupo par/impar. El nombre de cada código está en la tabla de miembros de abajo) |
| TAG ID | `0x06EL`·`0x06FL` |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 14~15 |
| Kind | Value · familia: TIME |
| Descripción del índice | cadena de fecha EDTF (ISO 8601-2). Bytes pares e impares. No se usa para fechas que se puedan escribir con GREGORIAN-DATE |
| Lado Hugo | `value/time/edtf.md` |

## Miembros {#구성원}

Esta página trata juntos los dos códigos de un par par/impar. El código par es el de valores con un número par de bytes y el código impar, el de valores con un número impar ([registro y TAG WORD](../record.md#가변-길이-바이트열)). Hay un documento de Codec por cada código. Los campos de los dos documentos de Codec son iguales y solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Número de bytes | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | par | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | impar | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | resto en bruto (`0xFFFF`) |  |  |

EDTF es el Value que contiene fechas mediante cadenas de [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Biblioteca del Congreso de EE. UU., ISO 8601-2:2019). Representa precisiones más gruesas que el día, fechas antes de nuestra era, lo incierto, aproximado o parcialmente desconocido, e intervalos.

## Layout {#레이아웃}

- Código: código directo de Value `0x06EL` (bytes pares) y `0x06FL` (bytes impares). Familia TIME. El Payload es una cadena, pero se coloca en la familia TIME.
- El número de bytes se determina por el bit menos significativo del Codec y por el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo`, y no hay Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = bytes impares)
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st ... Nth          bytes ASCII de la cadena EDTF / si es impar, el último 0x00
```

## Interpretación y validez {#해석과-유효성}

- La secuencia de bytes es una cadena ASCII que sigue la gramática EDTF de Level 0·1·2. Una cadena vacía es invalid.
- Ejemplos: día `1952-03-11`, mes `1952-03`, año `1952`, década `195X`, 44 a. C. `-0043`, incierto `1974?`, aproximado `~1974`, intervalo `1952/2001`, año grande `Y-13799999999`.
- Los años siguen el sistema astronómico de ISO 8601. `0000` es el 1 a. C. y `-0043` es el 44 a. C. Al trasladar desde la notación histórica, se desplaza un año.
- Es el calendario gregoriano. EDTF no trata otros calendarios. La notación original de otros calendarios, como el juliano, se conserva con [GEDCOM-DATE](0x070L-gedcom-date.md). El valor de ese día o período trasladado al calendario gregoriano se puede escribir con EDTF o GREGORIAN-DATE.
- **Forma canónica:** una fecha que se pueda escribir exactamente con [GREGORIAN-DATE](0x06AL-gregorian-date.md), es decir, `[-]YYYY-MM-DD` sin calificadores (`?`, `~`, `%`), sin dígitos desconocidos (`X`), sin intervalo y sin prefijo `Y`, se escribe con GREGORIAN-DATE. Escribir una fecha así con EDTF es invalid. Solo si un mismo día se escribe en un único formato se puede indexar y comparar como tiempo.
- El schema todavía no comprueba la gramática EDTF. El productor la comprueba con un analizador de EDTF. Ejemplo: `parser.ParseString` de `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` solo mira la gramática y deja pasar también `2023-02-29` y `1974-13`, por lo que no se usa. Este analizador aún no admite los años con prefijo `Y`.

## Longitud {#길이}

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload ([Length](../record.md)).

## Ejemplo {#예시}

| Fecha | Bytes | WORD totales |
|---|---|---|
| `1974` | 4 (par) | `06E2 3139 3734` |
| `197X` | 4 (par) | `06E2 3139 3758` |
| `1952-03` | 7 (impar) | `06F4 3139 3532 2D30 3300` |

## Fundamento normativo {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0 es un subconjunto de ISO 8601-1 y Level 1·2 son funciones de ISO 8601-2.
- En RDF, la misma cadena se indica con el tipo de datos `http://id.loc.gov/datatypes/edtf`.

## Problemas abiertos {#열린-문제}

- La comprobación de la gramática EDTF en el validador (si el validador se apoyará en una biblioteca externa).
- La regla para trasladar las precisiones de siglo y milenio de Wikidata a los dígitos desconocidos de EDTF.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000006E0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

Lo anterior es el documento de Codec de `EDTF-EVEN` (`0x06EL`). El documento de Codec del otro miembro (`EDTF-ODD`) solo difiere en el Codec ID del DOC-ID, el destino de DECLARE y el nombre (BIND) asociado a `#1`.
