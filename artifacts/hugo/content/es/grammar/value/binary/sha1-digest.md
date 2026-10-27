---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST es un Value de 11 WORD fijos que contiene los 160 bits completos del resultado de SHA-1 y que solo se usa para identificación, como los ID de objeto de git."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
SHA1-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-1. Es el código directo de Value `0x62`, familia BINARY. El Payload es exactamente 10 WORD (160 bits) y no se admite el truncamiento.

**Se usa solo para identificación.** La resistencia a colisiones de SHA-1 está rota (SHAttered, 2017). Como base de integridad y firmas se usa [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/). Este formato existe para contener tal cual identificadores ya fijados con SHA-1, sobre todo el ID de objeto (ID de commit) de un repositorio git SHA-1. Por ejemplo, el Version (ID de commit) de [TRANSFORMED-BY](/es/grammar/meta/lineage/transformed-by/) se contiene en 11 WORD en lugar de en texto hex (22 WORD).

## Layout

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interpretación y validez

- Los 20 octetos del Payload se leen en el orden de salida de SHA-1. En cada WORD el octeto superior va primero (el mismo framing que SHA-256-DIGEST).
- Se rechaza una representación cuyo Payload no sea de 10 WORD o que haya recortado arbitrariamente el resultado (ID abreviados de git, etc.). No hay descriptor ni relleno.
- El ID de objeto de git es tal cual el valor calculado por git. El SHA-1 de git es una variante con detección de colisiones (SHA-1DC), pero con entradas que no son ataques de colisión el resultado es igual al de SHA-1.

## Base estándar

- El algoritmo SHA-1 y el resultado de 160 bits siguen [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) de NIST.
- El framing de TAG y WORD de 16 bits de GEUL es una regla que añade este formato.

## Longitud

- El total es exactamente 11 WORD: TAG 1 WORD y Payload 10 WORD, y se usa `LLLL=1010`. No hay extensión de Length.

## Ejemplo

Commit de git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Páginas relacionadas

- [Value](/es/grammar/value/), [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/es/grammar/meta/lineage/transformed-by/)
