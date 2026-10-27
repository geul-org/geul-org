---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS ist ein IETF-Issuer-Format mit festen 11 WORD, das eine 128-Bit-IPv6-Adresse in ihrer Reihenfolge unverändert enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS ist ein Value fester Breite, der den 128-Bit-Wert einer IPv6-Adresse enthält. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, Formatnummer `0xC002`, Familie BINARY. Der Payload ist genau 8 WORD (128 Bit).

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  insgesamt 11 WORD
Issuer            1 WORD  0x0020 (IETF)
Formatnummer      1 WORD  0xC002
Payload           8 WORD (128 Bit)  IPv6 address, high-order bit → low-order bit
```

## Interpretation und Gültigkeit

- Die acht Payload-WORD werden ab dem oberen WORD aneinandergehängt und die 128 Bit des IPv6-Adressfeldes in ihrer Reihenfolge gelesen. In jedem WORD ist das zuerst kommende Oktett die oberen 8 Bit.
- Der Payload enthält nur die 128 Bit einer einzigen Adresse. CIDR-Präfixlänge, Port und Transportprotokoll sind nicht enthalten.
- Der zone identifier steckt nicht in den 128 Bit der Adresse und kommt daher nicht in den Payload. Eine scoped address, die eine zone braucht, wird über einen äußeren Kontext wie das Interface oder Edge, Reference und Profile angegeben.
- Alle 128-Bit-Muster lassen sich darstellen. Betriebliche Bedeutung und Verwendbarkeit von Mustern wie unspecified, loopback, multicast, speziell und reserviert beurteilt man im äußeren Kontext, und die strukturelle Gültigkeit wird dadurch nicht eingeschränkt.
- IPV4-ADDRESS und IPV6-ADDRESS sind getrennte Formate. Auch eine IPv4-mapped-IPv6-Adresse wird als 128-Bit-IPv6-Wert bewahrt und weder automatisch mit IPV4-ADDRESS gleichgesetzt noch gegenseitig normalisiert.
- Dieser Value kann als Kennungskomponente eines Reference verwendet werden, aber scope und Referenzpolitik stecken nicht im Adress-Bitmuster.

## Normgrundlage

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) definiert die IPv6-Adresse als 128-Bit-Kennung und legt das Adress-Bitformat einschließlich unicast, anycast, multicast und IPv4-mapped IPv6 fest. Dieses Format bewahrt diese 128 Bit, ohne sie neu zu interpretieren.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) definiert Source Address und Destination Address eines IPv6-Pakets je als 128-Bit-Feld. Die Payload-WORD bewahren die Reihenfolge von den high-order bits bis zu den low-order bits dieses Adressfeldes.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) stellt klar, dass die zone einer non-global address nicht in der Adresse selbst kodiert, sondern vom Kontext bestimmt wird. Deshalb steht der zone identifier außerhalb des Payloads.
- Die Zeichenkettenschreibweise von RFC 4291 darf nur zur Erläuterung und für Ein-/Ausgabe verwendet werden. Da [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) kein internes Speicherformat festlegt, wird dessen Zeichenketten-Kanonisierung nicht als Kanonisierung dieses Binär-Records verwendet.
- GEUL-TAG, Issuer-Vergabe, direkte Length und 16-Bit-WORD-Framing sind nicht Teil dieser RFCs, sondern Regeln, die dieses Format hinzufügt.

## Länge

- Insgesamt sind es genau 11 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 8 WORD Payload, mit der direkten Länge `LLLL=1010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Beispiel

IPv6-Adresse `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- Die abgekürzte Zeichenkettenschreibweise hat keinen Einfluss auf den Payload.
