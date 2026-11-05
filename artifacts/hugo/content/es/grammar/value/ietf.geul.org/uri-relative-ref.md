---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF es un Value que contiene la secuencia de bytes ASCII de la gramática relative-ref de RFC 3986."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF es un Value que contiene la secuencia de bytes ASCII de la gramática `relative-ref` de RFC 3986. El base URI y el resultado ya resuelto no se ponen en el Payload.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número de Codec `0x00008000` (número par de bytes) y `0x00008001` (número impar de bytes). Familia TEXT.
- El número de bytes se determina por el bit menos significativo del número de Codec y el número de WORD del Payload: `2 × número de WORD del Payload − bit menos significativo`. No hay Byte Count ([Value](../_index.md)).

```
TAG WORD                  0000 1001 1101 LLLL      Codec 0x09DL
[TAG extendida de Length] si el total es de 15 WORD o más
Issuer                    2 WORD  0x00000007 (IETF)
Número de Codec           2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretación y validez {#해석과-유효성}

- La secuencia de bytes debe ajustarse a la gramática de RFC 3986 `relative-ref = relative-part [ "?" query ] [ "#" fragment ]`.
- Los terminales de la gramática URI son caracteres US-ASCII. Los caracteres ASCII permitidos se almacenan tal cual, y al aplicar percent-encoding a un octet se usa la forma `pct-encoded = "%" HEXDIG HEXDIG`. No se deben poner caracteres no ASCII directamente como literal byte.
- Como `relative-part` puede ser `path-empty`, una secuencia de bytes vacía también es un `relative-ref` gramaticalmente válido.
- El base URI, el resolution context y el resultado resuelto son contexto externo a este formato.
- Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD del Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Base normativa {#표준-근거}

- La gramática de `relative-ref`, los caracteres URI y el percent-encoding siguen [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- El par de códigos par/impar, el zero padding, el TAG/Length de GEUL y la disposición en WORD de 16 bit son reglas de framing de este formato. El base URI y el resultado de la resolución de referencia son contexto de la RFC, pero no se ponen en el Payload.

## Longitud {#길이}

- El total es el número de WORD que suman TAG 1 WORD, TAG extendida de Length (si existe), Issuer 2 WORD, número de Codec 2 WORD y Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y la TAG extendida también cuenta en el total ([Length](../../record.md)).
- 0 byte es un `relative-ref` vacío, semánticamente admitido, y no tiene WORD de Payload. Su disposición física es el problema abierto de más abajo.

## Ejemplo {#예시}

- `a/b?x=1` tiene 7 byte (impar), así que el número de Codec es `0x00008001` y el Payload es `612F 623F 783D 3100`. Como el total es de 9 WORD, `LLLL=1000`. El conjunto es `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## Problemas abiertos {#열린-문제}

- La disposición física de un `relative-ref` vacío (0 byte). Un registro sin Payload no concuerda con la regla de «Payload mínimo de 1 WORD», por lo que aún no se ha fijado.
