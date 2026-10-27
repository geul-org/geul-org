---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE es un Value que conserva tal como está escrita, con la cadena de valor de fecha de GEDCOM 7, una fecha de otro calendario, como el juliano (Codec 0x26/0x27)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
GEDCOM-DATE es un Value que contiene la cadena del valor de fecha (`DateValue`) de [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Conserva **tal como está escrita** una fecha que el original anotó en un calendario que no es el gregoriano (juliano, etc.).

## Layout

- Código: código directo de Value `0x26` (bytes pares) y `0x27` (bytes impares). Familia TIME.
- El número de bytes se fija con el bit menos significativo del Codec y el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo` y no hay Byte Count ([Value](/es/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = número impar de bytes)
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1.º ... N-ésimo          bytes ASCII de la cadena de fecha GEDCOM / si es impar, el último 0x00
```

## Interpretación y validez

- Los bytes son una cadena ASCII que sigue la gramática `DateValue` de GEDCOM 7. La cadena vacía es invalid. GEDCOM admite un `DateValue` vacío, pero si no hay valor no se escribe el registro.
- Resumen de la gramática: `[calendario] [[día] mes] año [BCE]`. Delante se pueden poner `ABT`·`CAL`·`EST` (aproximada), `BEF`·`AFT`·`BET … AND …` (rango) y `FROM … TO …` (periodo). El separador es un solo espacio.
- Calendarios: `GREGORIAN` (por defecto si se omite), `JULIAN`, `FRENCH_R`, `HEBREW` y etiquetas de extensión. Los nombres de los meses están fijados por calendario (el juliano usa los mismos `JAN`…`DEC` que el gregoriano).
- Los años son de **estilo histórico**. No hay año 0 y el antes de Cristo lleva `BCE` (`44 BCE` = año 44 antes de Cristo). Difiere en un año del estilo astronómico de EDTF y GREGORIAN-DATE.
- El schema solo comprueba el formato de los bytes: ASCII `0x20`~`0x7E`, no vacío, sin espacios al principio ni al final. La gramática y si el día existe realmente los comprueba el productor. Ejemplo: `gedcom.ParseDate` de `github.com/cacack/gedcom-go/v3` (MIT). El `Validate` de esta biblioteca solo comprueba el día en el calendario gregoriano, por lo que deja pasar `JULIAN 30 FEB 1100`, y `ToGregorian` no convierte realmente la precisión de año·mes. La comprobación de existencia y la normalización de la fecha se hacen aparte.
- **Dónde se usa:** las fechas del calendario gregoriano se escriben con [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/) o [EDTF](/es/grammar/value/time/edtf/). GEDCOM-DATE se usa para fechas de otros calendarios cuya notación original hay que conservar.

## Uso junto con un valor normalizado

- Para comparar e indexar la misma fecha en el eje del tiempo hace falta un valor del calendario gregoriano. Con precisión de día, el GREGORIAN-DATE del mismo día; con precisión de año·mes, el EDTF de intervalo gregoriano de ese periodo (`JULIAN 1300` → `1300-01-09/1301-01-08`) es la correspondencia exacta.
- Cómo contener juntos en dos Value la notación original (GEDCOM-DATE) y el valor normalizado aún no se ha fijado (problema abierto).

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload ([Length](/es/grammar/record/)).

## Ejemplo

| Fecha | Bytes | WORD en total |
|---|---|---|
| `JULIAN 1300` | 11 (impar) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## Base estándar

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). La licencia del repositorio de la especificación es Apache 2.0. GEUL solo se refiere al formato y no traslada el texto de la especificación.
- ISO 8601, EDTF, XSD y los identificadores de calendario de CLDR (`u-ca`) no incluyen el calendario juliano. GEDCOM 7 es un formato de intercambio público que trata en una sola gramática el prefijo de calendario, el antes de Cristo, la precisión y los calificadores.

## Problemas abiertos

- Cómo usar juntos la notación original y el valor normalizado (cómo enlazar los dos en un TRIPLE).
- La comprobación de la gramática GEDCOM por el schema.
- La precisión de siglo y de década. GEDCOM no tiene ese formato. Las fechas de Wikidata que no se puedan trasladar se dejan como UTF8-TEXT del original.

## Páginas relacionadas

- [Value](/es/grammar/value/), [EDTF](/es/grammar/value/time/edtf/), [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/)
