---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS es un formato Issuer IETF de 5 WORD fijos que contiene los 32 bits de una dirección IPv4 tal cual en network byte order."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
IPV4-ADDRESS es un Value de ancho fijo que contiene el valor de 32 bits de una dirección IPv4. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, número de formato `0xC001`, familia BINARY. El Payload es exactamente 2 WORD (32 bits).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD en total
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretación y validez

- Los octetos de la dirección se dejan en network byte order. En cada WORD, el octeto que va primero son los 8 bits superiores y el siguiente los 8 bits inferiores.
- El Payload contiene solo los 32 bits de una dirección. No contiene CIDR prefix length, port ni transport protocol.
- Se pueden representar todos los patrones de 32 bits. El significado operativo y la utilizabilidad de patrones como unspecified, especiales, reservados o multicast se juzgan en un contexto externo y no limitan la validez estructural.
- IPV4-ADDRESS e IPV6-ADDRESS son formatos distintos. Una dirección IPv6 IPv4-mapped no se convierte automáticamente a este formato ni se normaliza al mismo valor.
- Este Value puede usarse como componente identificador de un Reference, pero la política de referencia y la vida útil no están en el patrón de bits de la dirección.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Base estándar

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) define una dirección IPv4 como 4 octetos (32 bits) de longitud fija, y define Source Address y Destination Address como campos de 32 bits cada uno. En el Payload se conservan el orden de transmisión de octetos del Appendix B y la regla most-significant-bit-first de cada octeto.
- El TAG de GEUL, la asignación de Issuer, la agrupación en WORD de 16 bits y el Length son reglas de framing que añade este formato, no parte de RFC 791.

## Longitud

- El total es exactamente 5 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 2 WORD, y se usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Ejemplo

Dirección IPv4 `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
