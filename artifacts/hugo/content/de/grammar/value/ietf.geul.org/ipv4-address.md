---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS ist ein Value fester Breite, der den 32-Bit-Wert einer IPv4-Adresse enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS ist ein Value fester Breite, der den 32-Bit-Wert einer IPv4-Adresse enthält. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, Codec-Nummer `0x0000C001`, Familie BINARY. Der Payload umfasst genau 2 WORD (32 Bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  insgesamt 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec-Nummer      2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Adress-Octets bleiben in Network Byte Order. In jedem WORD bildet das zuerst kommende Octet die oberen 8 Bit und das nächste Octet die unteren 8 Bit.
- Der Payload enthält nur die 32 Bit einer einzelnen Adresse. CIDR-Prefix-Length, Port und Transportprotokoll werden nicht aufgenommen.
- Alle 32-Bit-Muster sind darstellbar. Die betriebliche Bedeutung und Verwendbarkeit von Mustern wie unspecified, speziell, reserviert oder Multicast wird im externen Kontext beurteilt und schränkt die strukturelle Gültigkeit nicht ein.
- IPV4-ADDRESS und IPV6-ADDRESS sind getrennte Formate. Eine IPv4-mapped IPv6-Adresse wird weder automatisch in dieses Format umgewandelt noch auf denselben Wert normalisiert.
- Dieser Value kann als Identifikatorbestandteil einer Reference dienen, doch deren Referenzrichtlinie und Lebensdauer sind nicht im Adress-Bitmuster enthalten.
- Hat der Payload nicht genau 2 WORD, wird er abgelehnt.

## Normgrundlage {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) definiert die IPv4-Adresse als feste Länge von 4 Octets (32 Bit) und Source Address und Destination Address jeweils als 32-Bit-Feld. Die Octet-Übertragungsreihenfolge aus Appendix B und die Regel Most-Significant-Bit-First je Octet bleiben im Payload erhalten.
- GEUL-TAG, Issuer-Zuweisung, die Bündelung zu 16-Bit-WORD und Length sind keine Bestandteile von RFC 791, sondern Framing-Regeln, die dieses Format hinzufügt.

## Länge {#길이}

- Die Gesamtlänge ist genau 7 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 2 WORD Payload; verwendet wird die direkte Länge `LLLL=0110`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 2 WORD, wird er abgelehnt.

## Beispiel {#예시}

Die IPv4-Adresse `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
