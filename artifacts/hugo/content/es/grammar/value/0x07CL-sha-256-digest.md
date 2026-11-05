---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-256, de la familia SHA-2."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SHA-256-DIGEST` (BIND del documento de especificación `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| Documento de especificación | `0x00000000/codecs/0x000007C0/` (destino de DECLARE `07C0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 28 |
| Kind | Value · familia: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Resultado de SHA-256 con un Payload fijo de 16 WORD |
| Lado Hugo | `value/binary/sha-256-digest.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | valor en bruto de 16 WORD |  |  |

SHA-256-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-256, de la familia SHA-2. Es el código directo de Value `0x07CL`, de la familia BINARY. El Payload es exactamente 16 WORD (256 bits) y no se admite el truncamiento.

## Layout {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
TAG de extensión de Length   1 WORD  0x0012 (18 WORD en total)
Payload           16 WORD  SHA-256 Digest
```

## Interpretación y validez {#해석과-유효성}

- Los 32 octetos del Payload se leen en el mismo orden de la salida de SHA-256. En cada WORD, el octeto superior va primero.
- No se aplica por separado una conversión de endian de GEUL a la bit string del digest. Solo se agrupan de dos en dos, en orden, los octetos de la secuencia de salida para hacer el framing en WORD big-endian de 16 bits.
- Se rechaza si el Payload no es de 16 WORD o si es una representación en la que el resultado se ha truncado arbitrariamente. No hay descriptor ni padding.

## Fundamento normativo {#표준-근거}

- El algoritmo SHA-256 y el resultado de 256 bits siguen [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) del NIST.
- El TAG de GEUL, la Length y el framing de WORD de 16 bits son reglas que añade este formato y no forman parte del algoritmo SHA-2.

## Longitud {#길이}

- El total son exactamente 18 WORD, la suma de 1 WORD de TAG, 1 WORD de TAG de extensión de Length y 16 WORD de Payload, y usa `LLLL=1110`. No hay descriptor ni padding.
- Si el Payload no es exactamente 16 WORD, se rechaza.

## Ejemplo {#예시}

- Los octetos del digest, de `d[0]` a `d[31]`, se colocan en orden en los WORD de Payload, de `(d[0]<<8)|d[1]` a `(d[30]<<8)|d[31]`. La Length total es siempre de 18 WORD.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000007C0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
