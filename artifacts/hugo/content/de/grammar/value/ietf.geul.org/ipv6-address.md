---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS ist ein Value fester Breite, der den 128-Bit-Wert einer IPv6-Adresse enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS ist ein Value fester Breite, der den 128-Bit-Wert einer IPv6-Adresse enthält. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, Codec-Nummer `0x0000C002`, Familie BINARY. Der Payload umfasst genau 8 WORD (128 Bit).

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  insgesamt 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec-Nummer      2 WORD  0x0000C002
Payload           8 WORD (128 Bit)  IPv6 address, high-order bit → low-order bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die acht Payload-WORD werden ab dem höchstwertigen WORD aneinandergereiht, und die 128 Bit des IPv6-Adressfelds werden in ihrer Reihenfolge gelesen. In jedem WORD bildet das zuerst kommende Octet die oberen 8 Bit.
- Der Payload enthält nur die 128 Bit einer einzelnen Adresse. CIDR-Prefix-Length, Port und Transportprotokoll werden nicht aufgenommen.
- Der Zone Identifier ist nicht in den 128 Bit der Adresse enthalten und wird daher nicht in den Payload aufgenommen. Eine Scoped Address, die eine Zone benötigt, erhält diese über externen Kontext wie Interface, Edge, Reference oder Profile.
- Alle 128-Bit-Muster sind darstellbar. Die betriebliche Bedeutung und Verwendbarkeit von Mustern wie unspecified, loopback, multicast, speziell oder reserviert wird im externen Kontext beurteilt und schränkt die strukturelle Gültigkeit nicht ein.
- IPV4-ADDRESS und IPV6-ADDRESS sind getrennte Formate. Auch eine IPv4-mapped IPv6-Adresse bleibt ein 128-Bit-IPv6-Wert und wird weder automatisch mit IPV4-ADDRESS gleichgesetzt noch gegenseitig normalisiert.
- Dieser Value kann als Identifikatorbestandteil einer Reference dienen, doch Scope und Referenzrichtlinie sind nicht im Adress-Bitmuster enthalten.

## Normgrundlage {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) definiert die IPv6-Adresse als 128-Bit-Identifier und legt das Adress-Bitformat einschließlich Unicast, Anycast, Multicast und IPv4-mapped IPv6 fest. Dieses Format bewahrt die 128 Bit, ohne sie neu zu interpretieren.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) definiert Source Address und Destination Address eines IPv6-Pakets jeweils als 128-Bit-Feld. Die Payload-WORD bewahren die Reihenfolge von High-Order-Bit bis Low-Order-Bit dieses Adressfelds.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) legt dar, dass die Zone einer Non-Global-Address nicht in der Adresse selbst kodiert, sondern durch den Kontext bestimmt wird. Der Zone Identifier liegt daher außerhalb des Payloads.
- Die Zeichenkettenschreibweise von RFC 4291 darf nur für Erläuterung und Ein-/Ausgabe verwendet werden. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) legt kein internes Speicherformat fest, daher wird dessen String-Kanonisierung nicht als Kanonisierung dieses binären Records verwendet.
- GEUL-TAG, Issuer-Zuweisung, direkte Length und 16-Bit-WORD-Framing sind keine Bestandteile dieser RFCs, sondern Regeln, die dieses Format hinzufügt.

## Länge {#길이}

- Die Gesamtlänge ist genau 13 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 8 WORD Payload; verwendet wird die direkte Länge `LLLL=1100`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 8 WORD, wird er abgelehnt.

## Beispiel {#예시}

Die IPv6-Adresse `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- Die abgekürzte Schreibweise der Zeichenkette hat keinen Einfluss auf den Payload.
