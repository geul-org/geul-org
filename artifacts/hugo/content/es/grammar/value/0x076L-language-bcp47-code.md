---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE es un Value que contiene un language tag BCP 47 completo como secuencia de bytes ASCII."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE es un Value que contiene un language tag BCP 47 completo como secuencia de bytes ASCII. Usa la pareja de códigos de bytes pares e impares 0x076L/0x077L.

| Elemento | Valor |
|---|---|
| Nombre | `LANGUAGE-BCP47-CODE` (grupo par/impar; el nombre de cada código figura en la tabla de miembros de abajo) |
| TAG ID | `0x076L`·`0x077L` |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 22~23 |
| Kind | Value · familia: TEXT |
| Descripción del índice | Secuencia de bytes ASCII de un language tag BCP 47 completo en canonical casing. Bytes pares e impares |
| Lado Hugo | `value/text/language-bcp47-code.md` |

## Miembros {#구성원}

Esta página trata conjuntamente dos códigos que forman una pareja par/impar. El código par es el de valores con un número par de bytes y el impar, el de valores con un número impar de bytes ([Registro y TAG WORD](../record.md#가변-길이-바이트열)). Hay un documento de Codec por código. Los campos de ambos documentos son los mismos; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Número de bytes | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | par | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | impar | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | resto de valor en bruto (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE es un Value que contiene un language tag BCP 47 completo. Se usa cuando se quiere anotar con exactitud el idioma hasta el script, la región y la variante.

## Layout {#레이아웃}

- Código: código directo de Value `0x076L` (bytes pares) y `0x077L` (bytes impares). Familia TEXT.
- El número de bytes se determina por el bit menos significativo del Codec y el número de WORD de Payload. Es `2 × número de WORD de Payload − bit menos significativo`, y no hay Byte Count ([Value](_index.md)).
- El Payload no es texto UTF-8, sino la secuencia de bytes ASCII del tag BCP 47.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretación y validez {#해석과-유효성}

- La secuencia de bytes debe ser un language tag BCP 47 well-formed según RFC 5646. No se admite la cadena vacía.
- El Payload usa solo caracteres ASCII, dígitos y el guion-menos `-`. El separador es siempre el `-` ASCII; no se admiten `_`, espacios ni caracteres no ASCII.
- La comparación de tags BCP 47 no distingue mayúsculas de minúsculas. El perfil canónico de GEUL usa `-` para todos los separadores y serializa los subtags language/extlang/variant/extension/private-use en minúsculas, el script en Titlecase y la región en mayúsculas.
- Que esté well-formed no basta. La validez de los subtags registrados y de los tags grandfathered se determina según un snapshot concreto del IANA Language Subtag Registry, y debe conservarse junto con ella la fecha de ese snapshot o la versión del registry.
- Los tags private-use y los subtags private-use se admiten si están well-formed según la gramática de RFC 5646. Pero su significado depende del acuerdo entre las partes y no lo define el registry de IANA, por lo que no garantizan interoperabilidad pública.
- Si en el mismo snapshot un subtag deprecated o un tag grandfathered tiene Preferred-Value, la forma GEUL canónica escribe ese valor de sustitución en canonical casing. Un tag con la notación deprecated tal cual puede interpretarse como entrada, pero no es la forma de almacenamiento canónica.
- BCP 47 es un perfil ASCII, por lo que no se aplican requisitos de Unicode normalization como UTF-8 NFC.
- Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD de Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Fundamento normativo {#표준-근거}

- La gramática de los language tag, la interpretación insensible a mayúsculas y los conceptos de deprecated/Preferred-Value siguen [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- El registry que determina la validez de los tags es el [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- La pareja de códigos par/impar, el zero padding, la política de almacenamiento en canonical casing y el cálculo de Length son reglas de framing de GEUL.

## Longitud {#길이}

- El total es el número de WORD que suman 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también se incluye en el total ([Length](../record.md)).

## Relación con LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- Un tag que tiene número en el GEUL Language Registry puede escribirse con 1 WORD de [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md).
- Un tag sin número en el registro (incluidos los tags que contienen extension o private-use) se escribe con LANGUAGE-BCP47-CODE. También se usa LANGUAGE-BCP47-CODE cuando hace falta conservar el original del full tag.
- El SHORT-CODE `n` y el LANGUAGE-BCP47-CODE del tag que el registro asocia a `n` (sin distinguir mayúsculas) son el mismo idioma.

## Ejemplo {#예시}

- `ko-KR` son 5 bytes ASCII (impar), por lo que es `LANGUAGE-BCP47-CODE-ODD` (`0x077L`) y el Payload es `6B6F 2D4B 5200`.
- Con 1 WORD de TAG y 3 WORD de Payload, el total es de 4 WORD y `LLLL=0011`. El total es `0773 6B6F 2D4B 5200`.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000760/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

Lo anterior es el documento de Codec de `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). El documento de Codec del otro miembro (`LANGUAGE-BCP47-CODE-ODD`) solo difiere en el Codec ID del DOC-ID, el destino de DECLARE y el nombre enlazado en `#1` (BIND).
