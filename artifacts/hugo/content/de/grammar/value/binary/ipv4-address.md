---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS ist ein IETF-Issuer-Format mit festen 5 WORD, das eine 32-Bit-IPv4-Adresse unverändert in network byte order enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS ist ein Value fester Breite, der den 32-Bit-Wert einer IPv4-Adresse enthält. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, Formatnummer `0xC001`, Familie BINARY. Der Payload ist genau 2 WORD (32 Bit).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  insgesamt 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Formatnummer      1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretation und Gültigkeit

- Die Adressoktette bleiben in network byte order. In jedem WORD sind die zuerst kommenden Oktette die oberen 8 Bit, das nächste Oktett die unteren 8 Bit.
- Der Payload enthält nur die 32 Bit einer einzigen Adresse. CIDR-Präfixlänge, Port und Transportprotokoll sind nicht enthalten.
- Alle 32-Bit-Muster lassen sich darstellen. Betriebliche Bedeutung und Verwendbarkeit von Mustern wie unspecified, speziell, reserviert und Multicast beurteilt man im äußeren Kontext, und die strukturelle Gültigkeit wird dadurch nicht eingeschränkt.
- IPV4-ADDRESS und IPV6-ADDRESS sind getrennte Formate. Eine IPv4-mapped-IPv6-Adresse wird nicht automatisch in dieses Format umgewandelt oder zum selben Wert normalisiert.
- Dieser Value kann als Kennungskomponente eines Reference verwendet werden, aber Referenzpolitik und Lebensdauer stecken nicht im Adress-Bitmuster.
- Hat der Payload nicht genau 2 WORD, wird abgelehnt.

## Normgrundlage

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) definiert die IPv4-Adresse mit fester Länge von 4 Oktetten (32 Bit) und Source Address und Destination Address je als 32-Bit-Feld. Die Oktett-Übertragungsreihenfolge aus Appendix B und die most-significant-bit-first-Regel jedes Oktetts werden im Payload bewahrt.
- GEUL-TAG, Issuer-Vergabe, 16-Bit-WORD-Bündelung und Length sind nicht Teil von RFC 791, sondern Framing-Regeln, die dieses Format hinzufügt.

## Länge

- Insgesamt sind es genau 5 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 2 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 2 WORD, wird abgelehnt.

## Beispiel

IPv4-Adresse `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
