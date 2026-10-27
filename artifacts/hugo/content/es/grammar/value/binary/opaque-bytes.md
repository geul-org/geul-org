---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES es un formato Issuer de GEUL que contiene bytes arbitrarios cuyo significado y formato no fija él mismo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
OPAQUE-BYTES son bytes arbitrarios cuyo significado y formato no fija este formato por sí mismo. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, números de formato `0xC000`·`0xC001` (bytes par·impar), familia BINARY. El número de bytes se fija con el bit menos significativo del número de formato y el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo` y no hay Byte Count ([Value](/es/grammar/value/)).

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0000 (GEUL)
Número de formato 1 WORD  0xC000/0xC001
Payload WORD 1.º ... N-ésimo   bytes / relleno de ceros final
```

## Interpretación y validez

- Del Payload se leen en orden tantos bytes como indique el número de bytes. Dentro de un WORD, el byte superior va primero.
- El número de WORD del Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.
- Si el código par·impar, el número de WORD del Payload y el relleno de ceros no concuerdan entre sí, se rechaza.

## Estatus del formato

- El par de códigos par·impar, la disposición del payload y el relleno de ceros del último WORD no citan un estándar industrial externo, sino que son framing propio de GEUL.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Registro y TAG WORD](/es/grammar/record/)).
- 0 bytes se escriben con el número de formato par (`0xC000`), como un registro de 3 WORD sin Payload (TAG, Issuer, número de formato).

## Ejemplo

Los bytes `ab cd ef` son 3 bytes (impar), así que el número de formato es `0xC001` y el Payload `abcd ef00`. Como son 5 WORD en total, `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
