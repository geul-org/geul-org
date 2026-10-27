---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS es un formato Issuer IEEE de 6 WORD fijos que contiene una dirección MAC IEEE 802 de 48 bits en el orden de sus octetos."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
MAC-48-ADDRESS es un Value de ancho fijo que contiene el valor de una dirección MAC IEEE 802 de 48 bits. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, número de formato `0xC000`, familia BINARY. El Payload es exactamente 3 WORD (6 octetos, 48 bits).

## Layout

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  6 WORD en total
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretación y validez

- Los seis octetos de la dirección MAC de 48 bits se dejan en el orden de octetos de la cadena de notación y de la transmisión LAN. Los octetos 0–1, 2–3 y 4–5 se agrupan cada uno en un WORD, del octeto superior al inferior.
- En los medios IEEE 802 el least-significant bit de cada octeto se transmite primero, pero por eso no se invierten los bits dentro de un octeto. I/G y U/L permanecen en el least-significant bit del octeto 0 y en el bit siguiente.
- I/G=0 es una dirección individual y se usa como unicast en el destination; I/G=1 es una dirección de grupo y se usa como multicast o broadcast. U/L=0 es una dirección universally administered y U/L=1, locally administered.
- Ningún patrón queda excluido estructuralmente por el valor de I/G o U/L. Se representan direcciones universally/locally administered e individual/group, y también las direcciones MAC locally administered, randomized, spoofed o virtuales como valores de 48 bits.
- Este valor conserva solo los 48 bits de la dirección observada o presentada. No garantiza la dirección permanente de un dispositivo concreto, la unicidad global, la autenticación de dispositivo o usuario, la propiedad ni la vinculación duradera con un mismo dispositivo.
- Este formato trata solo direcciones MAC IEEE 802 de exactamente 48 bits. No contiene EUI-64 ni otras direcciones MAC de 64 bits. La IEEE RA describe el término histórico `MAC-48` como obsoleto, pero no todas las direcciones MAC de 48 bits pueden llamarse EUI-48, por lo que este formato no se identifica automáticamente con EUI-48.
- Si el Payload no es exactamente de 3 WORD, se rechaza.

## Base estándar

- [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) de la IEEE Registration Authority anota las direcciones MAC LAN de 48 bits como seis octetos en orden de transmisión, y explica que cada octeto se transmite empezando por el least-significant bit y que I/G y U/L son los dos least-significant bit del primer octeto. Este formato conserva tal cual las posiciones de octetos y bits.
- [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) de la IEEE Registration Authority define I/G=0/1 como individual/group y U/L=0/1 como universal/local administration, y explica que las direcciones locales no son globalmente únicas. También explica la relación histórica y la diferencia entre los términos `MAC-48` y EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) explica que EUI-48 y EUI-64 pueden usarse como direcciones MAC, entre otros usos. Eso no significa que un EUI-64 se meta en este registro de 48 bits.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) y [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) registran que los dispositivos reales pueden generar y cambiar aleatoriamente direcciones MAC locally administered. Por eso, solo por el valor de una MAC no se infiere una identidad permanente del dispositivo.
- El TAG de GEUL, la asignación de Issuer, el Length directo y el framing en WORD de 16 bits son reglas que añade este formato, no parte de IEEE 802 ni de las fuentes anteriores.

## Longitud

- El total es exactamente 6 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 3 WORD, y se usa la longitud directa `LLLL=0101`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 3 WORD, se rechaza.

## Ejemplo

Dirección locally administered individual (unicast) `02:00:5e:10:00:00` (I/G=0 y U/L=1 del primer octeto `0x02`):

```
0afc 0040 c000 0200 5e10 0000
```
