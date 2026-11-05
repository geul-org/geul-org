---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SHA1-DIGEST` (BIND del documento de especificación `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| Documento de especificación | `0x00000000/codecs/0x000007D0/` (destino de DECLARE `07D0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 29 |
| Kind | Value · familia: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Resultado de SHA-1 con un Payload fijo de 10 WORD. Solo con fines de identificación, como los ID de objeto de git |
| Lado Hugo | `value/binary/sha1-digest.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | valor en bruto de 10 WORD |  |  |

SHA1-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-1. Es el código directo de Value `0x07DL`, de la familia BINARY. El Payload es exactamente 10 WORD (160 bits) y no se admite el truncamiento.

**Se usa solo con fines de identificación.** SHA-1 perdió su resistencia a colisiones (SHAttered, 2017). Como base de integridad y de firma se usa [SHA-256-DIGEST](0x07CL-sha-256-digest.md). Este formato existe para contener tal cual los identificadores ya fijados con SHA-1, sobre todo el ID de objeto (ID de commit) de un repositorio git SHA-1. Por ejemplo, la Version (ID de commit) de [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) se contiene en 11 WORD en lugar de en texto hexadecimal (22 WORD).

## Layout {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interpretación y validez {#해석과-유효성}

- Los 20 octetos del Payload se leen en el mismo orden de la salida de SHA-1. En cada WORD, el octeto superior va primero (el mismo framing que SHA-256-DIGEST).
- Se rechaza si el Payload no es de 10 WORD o si es una representación en la que el resultado se ha truncado arbitrariamente (ID abreviado de git, etc.). No hay descriptor ni padding.
- El ID de objeto de git es el valor tal cual lo calcula git. El SHA-1 de git es una variante con detección de colisiones (SHA-1DC), pero para entradas que no son ataques de colisión el resultado es igual al de SHA-1.

## Fundamento normativo {#표준-근거}

- El algoritmo SHA-1 y el resultado de 160 bits siguen [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) del NIST.
- El TAG de GEUL y el framing de WORD de 16 bits son reglas que añade este formato.

## Longitud {#길이}

- El total son exactamente 11 WORD, la suma de 1 WORD de TAG y 10 WORD de Payload, y usa `LLLL=1010`. No hay extensión de Length.

## Ejemplo {#예시}

Commit de git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000007D0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
