---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT es un Value que contiene una cadena UTF-8 sin idioma. Usa el par de códigos de bytes par/impar 0x40/0x41."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
UTF8-TEXT es un Value que contiene bytes UTF-8 válidos según RFC 3629. Se usa para cadenas sin idioma, como identificadores, códigos y nombres de archivo.

## Layout

- Código: código directo de Value `0x40` (bytes pares) y `0x41` (bytes impares). Familia TEXT.
- El número de bytes se fija con el bit menos significativo del Codec y el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo` y no hay Byte Count ([Value](/es/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1.º ... N-ésimo          bytes UTF-8 / relleno de ceros final
```

## Interpretación y validez

- Los bytes deben ser UTF-8 well-formed shortest-form que se ajuste a la gramática de RFC 3629. El resultado de la decodificación contiene solo Unicode scalar value en el rango `U+0000..U+10FFFF` y no contiene el rango de surrogates `U+D800..U+DFFF`.
- Un U+FEFF al principio del Payload (bytes UTF-8 `EF BB BF`) se permite y es un carácter, igual que un U+FEFF en cualquier otra posición. No se aplica el tratamiento de la signature U+FEFF inicial (BOM) que describe RFC 3629: no se elimina ni se interpreta como signature, y se conserva tal cual el original.
- No se impone la normalización Unicode. Se conserva tal cual la secuencia de scalar del original decodificado.
- Los bytes UTF-8 válidos se colocan en el Payload sin conversión. Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD del Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Base estándar

- El rango de scalar de UTF-8 y los bytes well-formed siguen [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- El par de códigos par/impar, el relleno de ceros, el TAG/Length de GEUL y la disposición en WORD de 16 bits son reglas de canonical framing de este formato.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida `1110`·`1111`, y el TAG de extensión también se incluye en el total ([Length](/es/grammar/record/)).
- Una cadena de 0 bytes se escribe como un registro de 1 WORD (solo el TAG WORD) con el código par ([Value](/es/grammar/value/)).

## Ejemplo

- `A` (`41`) es 1 byte (impar), por lo que es `UTF8-TEXT-ODD` (`0x41`), Payload `4100`, 2 WORD en total, `LLLL=0001`. El total es `08C1 4100`.
- La cadena vacía es `0840` (`UTF8-TEXT-EVEN`, solo el TAG WORD), 1 WORD.
