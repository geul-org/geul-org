---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS es un formato Issuer IETF de 11 WORD fijos que contiene los 128 bits de una dirección IPv6 en su orden."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
IPV6-ADDRESS es un Value de ancho fijo que contiene el valor de 128 bits de una dirección IPv6. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, número de formato `0xC002`, familia BINARY. El Payload es exactamente 8 WORD (128 bits).

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD en total
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0xC002
Payload           8 WORD (128 bits)  IPv6 address, high-order bit → low-order bit
```

## Interpretación y validez

- Los ocho WORD del Payload se concatenan empezando por el WORD superior, y se leen en su orden los 128 bits del campo de dirección IPv6. En cada WORD, el octeto que va primero son los 8 bits superiores.
- El Payload contiene solo los 128 bits de una dirección. No contiene CIDR prefix length, port ni transport protocol.
- El zone identifier no está en los 128 bits de la dirección, así que no se pone en el Payload. Una scoped address que necesite zone se da con un contexto externo como la interfaz, un Edge, un Reference o un Profile.
- Se pueden representar todos los patrones de 128 bits. El significado operativo y la utilizabilidad de patrones unspecified, loopback, multicast, especiales o reservados se juzgan en un contexto externo y no limitan la validez estructural.
- IPV4-ADDRESS e IPV6-ADDRESS son formatos distintos. Una dirección IPv6 IPv4-mapped también se conserva como valor IPv6 de 128 bits y no se identifica automáticamente con IPV4-ADDRESS ni se normalizan entre sí.
- Este Value puede usarse como componente identificador de un Reference, pero el scope y la política de referencia no están en el patrón de bits de la dirección.

## Base estándar

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) define una dirección IPv6 como un identificador de 128 bits y fija el formato de bits de las direcciones, incluidas unicast, anycast, multicast e IPv4-mapped IPv6. Este formato conserva esos 128 bits sin reinterpretarlos.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) define Source Address y Destination Address del paquete IPv6 como campos de 128 bits cada uno. Los WORD del Payload conservan el orden desde el high-order bit hasta el low-order bit de ese campo de dirección.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) establece que el zone de una dirección non-global no está codificado en la propia dirección sino que lo fija el contexto. Por eso el zone identifier queda fuera del Payload.
- La notación en cadena de RFC 4291 solo puede usarse para explicación y entrada/salida. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) no fija el formato de almacenamiento interno, así que esa canonicalización de cadenas no se usa como canonicalización de este registro binario.
- El TAG de GEUL, la asignación de Issuer, el Length directo y el framing en WORD de 16 bits son reglas que añade este formato, no parte de esos RFC.

## Longitud

- El total es exactamente 11 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 8 WORD, y se usa la longitud directa `LLLL=1010`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo

Dirección IPv6 `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- La notación abreviada de la cadena no afecta al Payload.
