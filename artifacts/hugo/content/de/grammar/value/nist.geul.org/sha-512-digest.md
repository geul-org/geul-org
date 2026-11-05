---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST ist ein Value fester Breite, der das Ergebnis von SHA-512 aus der SHA-2-Familie vollständig enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST ist ein Value fester Breite, der das Ergebnis von SHA-512 aus der SHA-2-Familie vollständig enthält. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, Codec-Nummer `0x0000C000`, Familie BINARY. Der Payload umfasst genau 32 WORD (512 Bit); Truncation (Abschneiden) ist nicht zulässig.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0026 (insgesamt 38 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Codec-Nummer      2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die 64 Octets des Payloads werden in der Ausgabereihenfolge von SHA-512 gelesen. In jedem WORD steht das obere Octet zuerst.
- Auf den Digest-Bitstring wird keine eigene GEUL-Endian-Umwandlung angewandt. Die Octet-Folge der Ausgabe wird lediglich der Reihe nach zu je zwei Octets zu 16-Bit-Big-Endian-WORD gerahmt.
- Ein Payload, der nicht 32 WORD umfasst, oder eine Darstellung mit willkürlich abgeschnittenem Ergebnis wird abgelehnt. Descriptor und Padding gibt es nicht.

## Normgrundlage {#표준-근거}

- Der SHA-512-Algorithmus und das 512-Bit-Ergebnis folgen NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL-TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und kein Bestandteil des SHA-2-Algorithmus.

## Länge {#길이}

- Die Gesamtlänge ist genau 38 WORD: 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 32 WORD Payload; verwendet wird `LLLL=1110`. Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 32 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die Digest-Octets `d[0]` bis `d[63]` werden der Reihe nach als Payload-WORD `(d[0]<<8)|d[1]` bis `(d[62]<<8)|d[63]` abgelegt. Die Gesamtlänge beträgt immer 38 WORD.
