---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS es un Value de ancho fijo que contiene el valor de 128bit de una dirección IPv6."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS es un Value de ancho fijo que contiene el valor de 128bit de una dirección IPv6. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número de Codec `0x0000C002`, familia BINARY. El Payload es exactamente de 8 WORD (128bit).

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
Número de Codec   2 WORD  0x0000C002
Payload           8 WORD (128bit)  IPv6 address, high-order bit → low-order bit
```

## Interpretación y validez {#해석과-유효성}

- Los ocho WORD del Payload se concatenan empezando por el WORD más significativo y se leen los 128bit del campo de dirección IPv6 en su orden. En cada WORD, el octet que viene primero son los 8bit superiores.
- El Payload solo contiene los 128bit de una dirección. No contiene CIDR prefix length, port ni transport protocol.
- El zone identifier no está incluido en los 128bit de la dirección, por lo que no se pone en el Payload. Una scoped address que necesita zone se proporciona mediante un contexto externo como la interface o un Edge, Reference o profile.
- Se puede representar cualquier bit pattern de 128bit. El significado operativo y la posibilidad de uso de patterns unspecified, loopback, multicast, especiales o reservados se juzgan en el contexto externo y no limitan la validez estructural.
- IPV4-ADDRESS e IPV6-ADDRESS son formatos distintos. Una dirección IPv6 IPv4-mapped también se conserva como valor IPv6 de 128bit, y no se equipara automáticamente con IPV4-ADDRESS ni se normalizan entre sí.
- Este Value puede usarse como componente identificador de un Reference, pero el scope y la política de referencia no están contenidos en el bit pattern de la dirección.

## Base normativa {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) define la dirección IPv6 como un identifier de 128bit y fija el bit format de las direcciones, incluidas unicast, anycast, multicast e IPv4-mapped IPv6. Este formato conserva esos 128bit sin reinterpretarlos.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) define el Source Address y el Destination Address del packet IPv6 como campos de 128bit cada uno. Los WORD del Payload conservan el orden de ese campo de dirección, del high-order bit al low-order bit.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) indica que el zone de una non-global address no se encode en la propia dirección sino que se determina por el contexto. Por eso el zone identifier se deja fuera del Payload.
- La notación en cadena de RFC 4291 solo puede usarse para explicación y entrada/salida. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) no fija el formato de almacenamiento interno, por lo que su canonicalization de cadena no se usa como canonicalization de este registro binary.
- El TAG de GEUL, la asignación de Issuer, el Length directo y el framing en WORD de 16bit no forman parte de estos RFC, sino que son reglas que añade este formato.

## Longitud {#길이}

- El total es exactamente 13 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 8 WORD, con longitud directa `LLLL=1100`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo {#예시}

Dirección IPv6 `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- La abreviación de la cadena no afecta al Payload.
