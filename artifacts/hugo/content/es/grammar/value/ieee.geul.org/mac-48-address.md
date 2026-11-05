---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS es un Value de ancho fijo que contiene un valor de dirección MAC IEEE 802 de 48-bit."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS es un Value de ancho fijo que contiene un valor de dirección MAC IEEE 802 de 48-bit. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número de Codec `0x0000C000`, familia BINARY. El Payload es exactamente de 3 WORD (6 octet, 48bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  total 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número de Codec   2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretación y validez {#해석과-유효성}

- Los seis octet de la dirección MAC de 48-bit se dejan en el mismo orden de octet de la cadena de notación y de la transmisión LAN. Los octet 0–1, 2–3 y 4–5 se agrupan cada uno en un WORD, del octet superior al octet inferior.
- En los medios IEEE 802 el least-significant bit de cada octet se transmite primero, pero por eso no se invierten los bit dentro del octet. I/G y U/L permanecen en el least-significant bit del octet 0 y en el bit siguiente.
- I/G=0 es una dirección individual y se usa como unicast en el destination; I/G=1 es una dirección de grupo y se usa como multicast o broadcast. U/L=0 es una dirección universally administered y U/L=1 es una dirección locally administered.
- Ningún pattern queda excluido estructuralmente por el valor de I/G o U/L. Se pueden representar direcciones universally/locally administered e individual/group, y también las direcciones MAC locally administered, randomized, spoofed y virtual como valor de 48bit.
- Este valor solo conserva los 48bit de la dirección observada o presentada. No garantiza la dirección permanente de un dispositivo concreto, la unicidad global, la autenticación de dispositivo o usuario, la propiedad ni la vinculación persistente con el mismo dispositivo.
- Este formato solo trata direcciones MAC IEEE 802 de exactamente 48bit. No contiene EUI-64 ni otras direcciones MAC de 64-bit. IEEE RA describe el término histórico `MAC-48` como obsolete, pero no toda dirección MAC de 48-bit puede llamarse EUI-48, por lo que este formato no se equipara automáticamente con EUI-48.
- Si el Payload no es exactamente de 3 WORD, se rechaza.

## Base normativa {#표준-근거}

- [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) de la IEEE Registration Authority explica que la dirección MAC LAN de 48-bit se anota como seis octet en orden de transmisión, que cada octet se transmite empezando por el least-significant bit y que I/G y U/L son los dos least-significant bit del primer octet. Este formato conserva tal cual las posiciones de octet y de bit.
- [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) de la IEEE Registration Authority define I/G=0/1 como individual/group y U/L=0/1 como administración universal/local, y explica que las direcciones locales no son globalmente únicas. También explica la relación terminológica histórica y las diferencias entre `MAC-48` y EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) explica que EUI-48 y EUI-64 pueden usarse como direcciones MAC, entre otros usos. Eso no significa que se meta un EUI-64 en este registro de 48-bit.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) y [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) registran que los dispositivos reales pueden generar y cambiar aleatoriamente direcciones MAC locally administered. Por eso no se infiere una identity permanente de dispositivo solo a partir del valor MAC.
- El TAG de GEUL, la asignación de Issuer, el Length directo y el framing en WORD de 16bit no forman parte de IEEE 802 ni de los materiales anteriores, sino que son reglas que añade este formato.

## Longitud {#길이}

- El total es exactamente 8 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 3 WORD, con longitud directa `LLLL=0111`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 3 WORD, se rechaza.

## Ejemplo {#예시}

Dirección individual (unicast) locally administered `02:00:5e:10:00:00` (en el primer octet `0x02`, I/G=0, U/L=1):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
