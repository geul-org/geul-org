---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF es un Value que contiene los bytes ASCII de la gramática relative-ref de RFC 3986. Usa los números de formato 0x8000/0x8001 del Issuer IETF."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
URI-RELATIVE-REF es un Value que contiene los bytes ASCII de la gramática `relative-ref` de RFC 3986. El base URI y el resultado resuelto no se meten en el Payload.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, número de formato `0x8000` (bytes pares) y `0x8001` (bytes impares). Familia TEXT.
- El número de bytes se fija con el bit menos significativo del número de formato y el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo` y no hay Byte Count ([Value](/es/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0x8000/0x8001
Payload WORD 1.º ... N-ésimo          bytes de relative-ref / relleno de ceros final
```

## Interpretación y validez

- Los bytes deben ajustarse a la gramática `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` de RFC 3986.
- Los terminales de la gramática URI son caracteres US-ASCII. Los caracteres ASCII permitidos se almacenan tal cual, y al aplicar percent-encoding a un octeto se usa la forma `pct-encoded = "%" HEXDIG HEXDIG`. No se deben meter directamente como bytes literales caracteres no ASCII.
- Como `relative-part` puede ser `path-empty`, unos bytes vacíos también son un `relative-ref` válido según la gramática.
- El base URI, el contexto de resolución y el resultado resuelto son contexto externo a este formato.
- Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD del Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Base estándar

- La gramática de `relative-ref`, de los caracteres URI y del percent-encoding sigue [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- El par de códigos par/impar, el relleno de ceros, el TAG/Length de GEUL y la disposición en WORD de 16 bits son reglas de framing de este formato. El base URI y el resultado de interpretar la referencia son contexto del RFC, pero no se meten en el Payload.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida `1110`·`1111`, y el TAG de extensión también se incluye en el total ([Length](/es/grammar/record/)).
- 0 bytes se admite semánticamente como `relative-ref` vacío y no tiene WORD de Payload. Su disposición física es un problema abierto, más abajo.

## Ejemplo

- `a/b?x=1` son 7 bytes (impar), por lo que el número de formato es `0x8001` y el Payload `612f 623f 783d 3100`. Como son 7 WORD en total, `LLLL=0110`. El total es `0B7C 0020 8001 612f 623f 783d 3100`.

## Problemas abiertos

- La disposición física de un `relative-ref` vacío (0 bytes). Aún no se ha fijado porque un registro sin Payload no concuerda con la regla de "Payload mínimo de 1 WORD".
