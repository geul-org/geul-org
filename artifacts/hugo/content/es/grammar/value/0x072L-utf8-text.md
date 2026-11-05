---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT es un Value que contiene una cadena UTF-8 sin idioma."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT es un Value que contiene una cadena UTF-8 sin idioma. Usa la pareja de códigos de bytes pares e impares 0x072L/0x073L.

| Elemento | Valor |
|---|---|
| Nombre | `UTF8-TEXT` (grupo par/impar; el nombre de cada código figura en la tabla de miembros de abajo) |
| TAG ID | `0x072L`·`0x073L` |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 18~19 |
| Kind | Value · familia: TEXT |
| Descripción del índice | Secuencia de bytes UTF-8 válida que no implica normalización. Bytes pares e impares |
| Lado Hugo | `value/text/utf8-text.md` |

## Miembros {#구성원}

Esta página trata conjuntamente dos códigos que forman una pareja par/impar. El código par es el de valores con un número par de bytes y el impar, el de valores con un número impar de bytes ([Registro y TAG WORD](../record.md#가변-길이-바이트열)). Hay un documento de Codec por código. Los campos de ambos documentos son los mismos; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Número de bytes | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | par | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | impar | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | resto de valor en bruto (`0xFFFF`) |  |  |

UTF8-TEXT es un Value que contiene una secuencia de bytes UTF-8 válida según RFC 3629. Se usa para cadenas sin idioma, como identificadores, códigos y nombres de archivo.

## Layout {#레이아웃}

- Código: código directo de Value `0x072L` (bytes pares) y `0x073L` (bytes impares). Familia TEXT.
- El número de bytes se determina por el bit menos significativo del Codec y el número de WORD de Payload. Es `2 × número de WORD de Payload − bit menos significativo`, y no hay Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretación y validez {#해석과-유효성}

- La secuencia de bytes debe ser UTF-8 bien formado en su forma más corta (shortest-form) conforme a la gramática de RFC 3629. El resultado de la decodificación contiene solo Unicode scalar value del rango `U+0000..U+10FFFF` y no incluye el rango de surrogates `U+D800..U+DFFF`.
- Un U+FEFF al comienzo del Payload (la secuencia de bytes UTF-8 `EF BB BF`) también se considera el mismo carácter que un U+FEFF en cualquier otra posición y se admite. No se aplica el tratamiento de la signature (BOM) de U+FEFF inicial que describe RFC 3629. No se elimina ni se interpreta como signature, sino que se conserva tal cual en el original.
- No se impone la Unicode normalization. Se conserva tal cual la scalar sequence original decodificada.
- La secuencia de bytes UTF-8 válida se coloca en el Payload sin conversión. Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD de Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Fundamento normativo {#표준-근거}

- El rango de scalar y las secuencias de bytes bien formadas de UTF-8 siguen [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- La pareja de códigos par/impar, el zero padding y la disposición de TAG/Length de GEUL y WORD de 16 bits son reglas de framing canónico de este formato.

## Longitud {#길이}

- El total es el número de WORD que suman 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también se incluye en el total ([Length](../record.md)).
- Una cadena de 0 bytes se escribe como un registro de 1 WORD (solo el TAG WORD) con el código par ([Value](_index.md)).

## Ejemplo {#예시}

- `A` (`41`) es de 1 byte (impar), por lo que es `UTF8-TEXT-ODD` (`0x073L`), Payload `4100`, 2 WORD en total y `LLLL=0001`. El total es `0731 4100`.
- La cadena vacía es 1 WORD: `0720` (`UTF8-TEXT-EVEN`, solo el TAG WORD).

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000720/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

Lo anterior es el documento de Codec de `UTF8-TEXT-EVEN` (`0x072L`). El documento de Codec del otro miembro (`UTF8-TEXT-ODD`) solo difiere en el Codec ID del DOC-ID, el destino de DECLARE y el nombre enlazado en `#1` (BIND).
