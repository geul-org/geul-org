---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF es un Value que contiene fechas como cadena extendida de ISO 8601-2: precisión de año o mes, antes de Cristo, incertidumbre e intervalos (Codec 0x24/0x25)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
EDTF es un Value que contiene una fecha como cadena [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Biblioteca del Congreso de EE. UU., ISO 8601-2:2019). Representa precisiones más gruesas que el día, antes de Cristo, incertidumbre·aproximación·desconocimiento parcial e intervalos.

## Layout

- Código: código directo de Value `0x24` (bytes pares) y `0x25` (bytes impares). Familia TIME. El Payload es una cadena, pero se coloca en la familia TIME para que el decodificador y el índice lo traten como valor de tiempo aunque no conozcan el formato.
- El número de bytes se fija con el bit menos significativo del Codec y el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo` y no hay Byte Count ([Value](/es/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = número impar de bytes)
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1.º ... N-ésimo          bytes ASCII de la cadena EDTF / si es impar, el último 0x00
```

## Interpretación y validez

- Los bytes son una cadena ASCII que sigue la gramática EDTF Level 0·1·2. La cadena vacía es invalid.
- Ejemplos: día `1952-03-11`, mes `1952-03`, año `1952`, década `195X`, año 44 antes de Cristo `-0043`, incierta `1974?`, aproximada `~1974`, intervalo `1952/2001`, año grande `Y-13799999999`.
- Los años son de estilo astronómico de ISO 8601. `0000` es el año 1 antes de Cristo y `-0043` es el año 44 antes de Cristo. Al trasladar desde la notación histórica, se desplaza un año.
- Es calendario gregoriano. EDTF no trata otros calendarios. La notación original de otros calendarios, como el juliano, se conserva con [GEDCOM-DATE](/es/grammar/value/time/gedcom-date/). El valor de ese mismo día o periodo pasado al calendario gregoriano se puede escribir con EDTF o GREGORIAN-DATE.
- **Forma canónica:** una fecha que se pueda escribir exactamente con [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/), es decir, `[-]YYYY-MM-DD` sin calificadores (`?`, `~`, `%`), dígitos desconocidos (`X`), intervalo ni prefijo `Y`, se escribe con GREGORIAN-DATE. Escribir una fecha así con EDTF es invalid. Solo si un mismo día se anota con un único formato se puede indexar y comparar como tiempo.
- El schema todavía no comprueba la gramática EDTF. La comprueba el productor con un analizador EDTF. Ejemplo: `parser.ParseString` de `github.com/sfomuseum/go-edtf` (BSD-3-Clause). No se usa `parser.IsValid` porque solo mira la gramática y deja pasar `2023-02-29` y `1974-13`. Este analizador aún no admite años con prefijo `Y`.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload ([Length](/es/grammar/record/)).

## Ejemplo

| Fecha | Bytes | WORD en total |
|---|---|---|
| `1974` | 4 (par) | `0924 3139 3734` |
| `197X` | 4 (par) | `0924 3139 3758` |
| `1952-03` | 7 (impar) | `0A25 3139 3532 2d30 3300` |

## Base estándar

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). El Level 0 es un subconjunto de ISO 8601-1 y los Level 1·2 son funciones de ISO 8601-2.
- En RDF, la misma cadena se indica con el datatype `http://id.loc.gov/datatypes/edtf`.

## Problemas abiertos

- La comprobación de la gramática EDTF por el verificador (si el verificador se apoya en una biblioteca externa).
- La regla para trasladar a dígitos desconocidos de EDTF la precisión de siglo y milenio de Wikidata.

## Páginas relacionadas

- [Value](/es/grammar/value/), [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/es/grammar/value/time/gedcom-date/)
