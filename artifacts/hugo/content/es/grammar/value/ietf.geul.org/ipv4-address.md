---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS es un Value de ancho fijo que contiene el valor de 32bit de una dirección IPv4."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS es un Value de ancho fijo que contiene el valor de 32bit de una dirección IPv4. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número de Codec `0x0000C001`, familia BINARY. El Payload es exactamente de 2 WORD (32bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Número de Codec   2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretación y validez {#해석과-유효성}

- Los octet de la dirección se dejan en network byte order. En cada WORD, el octet que viene primero son los 8bit superiores y el siguiente octet son los 8bit inferiores.
- El Payload solo contiene los 32bit de una dirección. No contiene CIDR prefix length, port ni transport protocol.
- Se puede representar cualquier bit pattern de 32bit. El significado operativo y la posibilidad de uso de patterns como unspecified, especiales, reservados o multicast se juzgan en el contexto externo y no limitan la validez estructural.
- IPV4-ADDRESS e IPV6-ADDRESS son formatos distintos. Una dirección IPv6 IPv4-mapped no se convierte automáticamente a este formato ni se normaliza al mismo valor.
- Este Value puede usarse como componente identificador de un Reference, pero la política de referencia y el ciclo de vida no están contenidos en el bit pattern de la dirección.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Base normativa {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) define la dirección IPv4 como de longitud fija de 4 octet (32bit) y define Source Address y Destination Address como campos de 32bit cada uno. El Payload conserva el orden de transmisión de octet del Appendix B y la regla most-significant-bit-first de cada octet.
- El TAG de GEUL, la asignación de Issuer, la agrupación en WORD de 16bit y el Length no forman parte de RFC 791, sino que son reglas de framing que añade este formato.

## Longitud {#길이}

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 2 WORD, con longitud directa `LLLL=0110`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Ejemplo {#예시}

Dirección IPv4 `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
