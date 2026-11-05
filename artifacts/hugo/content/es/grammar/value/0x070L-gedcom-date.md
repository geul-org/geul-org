---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE es un Value que conserva tal como está escrita la cadena de valor de fecha de GEDCOM 7, incluidas las fechas de otros calendarios como el juliano (Codec 0x070L/0x071L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE es un Value que conserva tal como está escrita la cadena de valor de fecha de GEDCOM 7, incluidas las fechas de otros calendarios como el juliano (Codec 0x070L/0x071L).

| Elemento | Valor |
|---|---|
| Nombre | `GEDCOM-DATE` (grupo par/impar; el nombre de cada código figura en la tabla de miembros de abajo) |
| TAG ID | `0x070L`·`0x071L` |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 16~17 |
| Kind | Value · familia: TIME |
| Descripción del índice | Cadena de valor de fecha de GEDCOM 7. Conserva la notación original de otros calendarios (juliano, etc.). Bytes pares e impares |
| Lado Hugo | `value/time/gedcom-date.md` |

## Miembros {#구성원}

Esta página trata conjuntamente dos códigos que forman una pareja par/impar. El código par es el de valores con un número par de bytes y el impar, el de valores con un número impar de bytes ([Registro y TAG WORD](../record.md#가변-길이-바이트열)). Hay un documento de Codec por código. Los campos de ambos documentos son los mismos; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Número de bytes | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | par | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | impar | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | resto de valor en bruto (`0xFFFF`) |  |  |

GEDCOM-DATE es un Value que contiene la cadena del valor de fecha (`DateValue`) de [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Conserva **tal como está escrita** una fecha que el original anotó en un calendario distinto del gregoriano (juliano, etc.).

## Layout {#레이아웃}

- Código: código directo de Value `0x070L` (bytes pares) y `0x071L` (bytes impares). Familia TIME.
- El número de bytes se determina por el bit menos significativo del Codec y el número de WORD de Payload. Es `2 × número de WORD de Payload − bit menos significativo`, y no hay Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = bytes impares)
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st ... Nth          bytes ASCII de la cadena de fecha GEDCOM / si es impar, el último es 0x00
```

## Interpretación y validez {#해석과-유효성}

- La secuencia de bytes es una cadena ASCII que sigue la gramática `DateValue` de GEDCOM 7. La cadena vacía es invalid. GEDCOM admite un `DateValue` vacío, pero si no hay valor no se escribe el registro.
- Resumen de la gramática: `[calendario] [[día] mes] año [BCE]`. Se antepone `ABT`·`CAL`·`EST` (aproximado), `BEF`·`AFT`·`BET … AND …` (rango) o `FROM … TO …` (período). El separador es un solo espacio.
- Calendarios: `GREGORIAN` (por defecto si se omite), `JULIAN`, `FRENCH_R`, `HEBREW` y etiquetas de extensión. Los nombres de los meses están fijados para cada calendario (el juliano usa los mismos `JAN`…`DEC` que el gregoriano).
- El año es de **tipo histórico**. No existe el año 0 y los años anteriores a la era común llevan `BCE` (`44 BCE` = año 44 a. C.). Difiere en un año del tipo astronómico de EDTF y GREGORIAN-DATE.
- El schema solo comprueba el formato de bytes: ASCII `0x20`~`0x7E`, no vacío, sin espacios al principio ni al final. La gramática y la existencia real del día las comprueba el productor. Por ejemplo, `gedcom.ParseDate` de `github.com/cacack/gedcom-go/v3` (MIT). El `Validate` de esa biblioteca comprueba el día solo en el calendario gregoriano, por lo que deja pasar `JULIAN 30 FEB 1100`, y `ToGregorian` no convierte realmente las precisiones de año y mes. La comprobación de existencia de la fecha y su normalización se hacen aparte.
- **Dónde se usa:** las fechas gregorianas se escriben con [GREGORIAN-DATE](0x06AL-gregorian-date.md) o [EDTF](0x06EL-edtf.md). GEDCOM-DATE se usa para fechas de otros calendarios cuya notación original debe conservarse.

## Uso junto con un valor normalizado {#정규화된-값과-함께-쓰기}

- Para comparar e indexar la misma fecha en el eje temporal hace falta un valor gregoriano. Con precisión de día, la correspondencia exacta es el GREGORIAN-DATE del mismo día; con precisión de año o mes, es el EDTF de intervalo gregoriano de ese período (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- Todavía no se ha decidido cómo incluir la notación original (GEDCOM-DATE) y el valor normalizado como dos Value a la vez (problema abierto).

## Longitud {#길이}

- El total es el número de WORD que suman 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload ([Length](../record.md)).

## Ejemplo {#예시}

| Fecha | Bytes | Total de WORD |
|---|---|---|
| `JULIAN 1300` | 11 (impar) | `0716 4A55 4C49 414E 2031 3330 3000` |

## Fundamento normativo {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). La licencia del repositorio de la especificación es Apache 2.0. GEUL solo hace referencia al formato y no reproduce el texto de la especificación.
- ISO 8601, EDTF, XSD y los identificadores de calendario de CLDR (`u-ca`) no incluyen el calendario juliano. GEDCOM 7 es un formato de intercambio público que trata en una sola gramática el prefijo de calendario, los años anteriores a la era común, la precisión y los calificadores.

## Problemas abiertos {#열린-문제}

- Cómo escribir juntos la notación original y el valor normalizado (cómo unir ambos en un TRIPLE).
- Comprobación de la gramática GEDCOM en el schema.
- Precisión de siglo y de década. GEDCOM no tiene un formato para ellas. Las fechas que no se pueden trasladar desde Wikidata se dejan como texto original en UTF8-TEXT.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [EDTF](0x06EL-edtf.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000700/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

Lo anterior es el documento de Codec de `GEDCOM-DATE-EVEN` (`0x070L`). El documento de Codec del otro miembro (`GEDCOM-DATE-ODD`) solo difiere en el Codec ID del DOC-ID, el destino de DECLARE y el nombre enlazado en `#1` (BIND).
