---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C ist ein Value fester Breite, der ein CRC-32C-Ergebnis enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C ist ein Value fester Breite, der ein CRC-32C-Ergebnis enthält. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, Codec-Nummer `0x0000C000`, Familie BINARY. Der Payload umfasst genau 2 WORD (32 Bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  insgesamt 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec-Nummer      2 WORD  0x0000C000
Payload           2 WORD  CRC32C obere 16bit │ untere 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- In der Schreibweise der CRC-Parameter: width 32, Castagnoli-Polynom `0x1EDC6F41`, refin/refout true, init `0xFFFFFFFF`, xorout `0xFFFFFFFF`.
- Die berechnete unsigned 32-Bit-Ganzzahl wird in Big-Endian-WORD-Reihenfolge gespeichert. Diese Serialisierung ist weder die Anordnung des SCTP-Checksum-Felds in RFC 3309 noch das iSCSI-Digest-Byte-Mapping in RFC 3720 selbst.
- Hat der Payload nicht 2 WORD, wird er abgelehnt.

## Normgrundlage {#표준-근거}

- Die CRC-32C-Berechnung sowie das Castagnoli-Polynom und die Reflexionsregeln folgen den CRC32C-Definitionen in [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) und [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- GEUL-TAG, Length und das 16-Bit-Big-Endian-WORD-Framing der berechneten 32-Bit-Ganzzahl sind Regeln, die dieses Format hinzufügt.

## Länge {#길이}

- Die Gesamtlänge ist genau 7 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 2 WORD Payload; verwendet wird die direkte Länge `LLLL=0110`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 2 WORD, wird er abgelehnt.

## Beispiel {#예시}

Der CRC-32C-Check-Value `0xE3069283` von ASCII `123456789`:

```
09D6 0000 0007 0000 C000 E306 9283
```
