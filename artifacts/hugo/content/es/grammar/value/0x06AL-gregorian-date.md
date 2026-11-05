---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE es un número de días con signo que toma el 1970-01-01 del calendario gregoriano proléptico como day 0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `GREGORIAN-DATE` (documento de especificación BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| Documento de especificación | `0x00000000/codecs/0x000006A0/` (destino de DECLARE `06A0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 10 |
| Kind | Value · familia: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | número de días con signo respecto al `1970-01-01` gregoriano proléptico |
| Lado Hugo | `value/time/gregorian-date.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | valor en bruto, 2 WORD |  |  |

GREGORIAN-DATE es un número de días con signo que toma el `1970-01-01` del calendario gregoriano proléptico como day 0. No contiene zona horaria ni hora del día.

## Layout {#레이아웃}

- Código: código directo de Value `0x06AL`. Familia TIME.
- Usa el mismo tipo físico int32 con signo de ancho fijo que Arrow Date32 y `DATE` de Parquet.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  total 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretación y validez {#해석과-유효성}

- Los 2 WORD del Payload se leen como un day count con signo de 32 bits en complemento a dos, en orden de WORD big-endian.
- El rango válido es de `-2^31` a `2^31-1` días. Los negativos son fechas anteriores al epoch.
- Al calcular año, mes y día a partir del day count se usa el calendario gregoriano proléptico, sin cambios históricos de calendario.
- Incluso los valores pequeños usan siempre 2 WORD.

## Longitud {#길이}

- El total es exactamente 3 WORD: 1 WORD de TAG más 2 WORD de Payload, y usa la longitud directa `LLLL=0010`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 2 WORD, se rechaza.

## Ejemplo {#예시}

| Fecha | Payload | Length total |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## Relación con EDTF {#edtf와의-관계}

- Las precisiones más gruesas que el día, lo incierto o aproximado y los intervalos se escriben con [EDTF](0x06EL-edtf.md). Una fecha que se pueda escribir exactamente con GREGORIAN-DATE no se escribe con EDTF (forma canónica de EDTF).

## Fundamento normativo {#표준-근거}

- El `DATE` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) es un `int32` que guarda el número de días desde el epoch de Unix, 1970-01-01, y usa orden con signo.
- Date32 de [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) y del [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo guarda el número de días desde el epoch de Unix como entero de 32 bits con signo.
- El cálculo gregoriano proléptico es el perfil de calendario de GEUL adoptado por este formato. Se conserva el significado de day-count int32 de Arrow/Parquet y solo se añaden el TAG y el framing de WORD de 16 bits big-endian.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000006A0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
