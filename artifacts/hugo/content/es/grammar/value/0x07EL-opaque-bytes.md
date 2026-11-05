---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES es una secuencia arbitraria de bytes cuyo significado y formato no determina este propio formato."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES es una secuencia arbitraria de bytes cuyo significado y formato no determina este propio formato. Son los códigos directos de Value `0x07EL` (bytes pares) y `0x07FL` (bytes impares), de la familia BINARY. El número de bytes se determina por el bit menos significativo del Codec y el número de WORD de Payload. Es `2 × número de WORD de Payload − bit menos significativo`, y no hay Byte Count ([Value](_index.md)).

| Elemento | Valor |
|---|---|
| Nombre | `OPAQUE-BYTES` (grupo par/impar; el nombre de cada código figura en la tabla de miembros de abajo) |
| TAG ID | `0x07EL`·`0x07FL` |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 30~31 |
| Kind | Value · familia: BINARY |
| Descripción del índice | Secuencia de bytes de significado y formato desconocidos. Bytes pares e impares |
| Lado Hugo | `value/binary/opaque-bytes.md` |

## Miembros {#구성원}

Esta página trata conjuntamente dos códigos que forman una pareja par/impar. El código par es el de valores con un número par de bytes y el impar, el de valores con un número impar de bytes ([Registro y TAG WORD](../record.md#가변-길이-바이트열)). Hay un documento de Codec por código. Los campos de ambos documentos son los mismos; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Número de bytes | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | par | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | impar | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | resto de valor en bruto (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st ... Nth   bytes / zero padding final
```

## Interpretación y validez {#해석과-유효성}

- Del Payload se leen en orden tantos bytes como indique el número de bytes. Dentro de un WORD, el byte superior va primero.
- El número de WORD de Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.
- Se rechaza si el código par o impar, el número de WORD de Payload y el zero padding no concuerdan entre sí.

## Estatus del formato {#형식-지위}

- La pareja de códigos par/impar (`0x07EL` par, `0x07FL` impar), la disposición del payload y el zero padding del último WORD no citan un estándar industrial externo, sino que son un framing propio de GEUL.

## Longitud {#길이}

- El total es el número de WORD que suman 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también entra en el total ([Registro y TAG WORD](../record.md)).
- 0 bytes se escribe como un registro de 1 WORD (solo el TAG WORD) con el código par (`0x07EL`) ([Value](_index.md)).

## Ejemplo {#예시}

Los bytes `AB CD EF` son 3 bytes (impar), por lo que es `OPAQUE-BYTES-ODD` (`0x07FL`) y el Payload es `ABCD EF00`. Con 3 WORD en total, `LLLL=0010`.

```
07F2 ABCD EF00
```

La secuencia de bytes vacía es 1 WORD: `07E0` (`OPAQUE-BYTES-EVEN`, solo el TAG WORD).

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000007E0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

Lo anterior es el documento de Codec de `OPAQUE-BYTES-EVEN` (`0x07EL`). El documento de Codec del otro miembro (`OPAQUE-BYTES-ODD`) solo difiere en el Codec ID del DOC-ID, el destino de DECLARE y el nombre enlazado en `#1` (BIND).
