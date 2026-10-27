---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C ist ein IETF-Issuer-Format mit festen 5 WORD, das das 32-Bit-Ergebnis des Castagnoli-CRC-32C enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C ist ein Value fester Breite, der ein CRC-32C-Ergebnis enthält. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, Formatnummer `0xC000`, Familie BINARY. Der Payload ist genau 2 WORD (32 Bit).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  insgesamt 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Formatnummer      1 WORD  0xC000
Payload           2 WORD  CRC32C obere 16 Bit │ untere 16 Bit
```

## Interpretation und Gültigkeit

- In der Notation der CRC-Parameter: width 32, Castagnoli-Polynom `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- Die vorzeichenlose 32-Bit-Ganzzahl des Rechenergebnisses wird in Big-Endian-WORD-Reihenfolge gespeichert. Diese Serialisierung ist weder die Anordnung des SCTP-Checksum-Feldes nach RFC 3309 noch das iSCSI-Digest-Byte-Mapping nach RFC 3720 selbst.
- Hat der Payload nicht 2 WORD, wird abgelehnt.

## Normgrundlage

- Die CRC-32C-Berechnung sowie Castagnoli-Polynom und Reflexionsregeln richten sich nach der CRC32C-Definition in [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) und [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- GEUL-TAG, Length und das 16-Bit-Big-Endian-WORD-Framing der berechneten 32-Bit-Ganzzahl sind Regeln, die dieses Format hinzufügt.

## Länge

- Insgesamt sind es genau 5 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 2 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 2 WORD, wird abgelehnt.

## Beispiel

Der CRC-32C-check value `0xe3069283` für ASCII `123456789`:

```
0A7C 0020 C000 e306 9283
```
