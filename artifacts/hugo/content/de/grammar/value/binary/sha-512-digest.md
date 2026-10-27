---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST ist ein NIST-Issuer-Format mit festen 36 WORD, das das gesamte SHA-512-Ergebnis mit 512 Bit enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST ist ein Value fester Breite, der das gesamte Ergebnis von SHA-512 aus der SHA-2-Familie enthält. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, Formatnummer `0xC000`, Familie BINARY. Der Payload ist genau 32 WORD (512 Bit), und Kürzen (truncation) ist nicht zulässig.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0024 (insgesamt 36 WORD)
Issuer            1 WORD  0x0062 (NIST)
Formatnummer      1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## Interpretation und Gültigkeit

- Die 64 Oktette des Payloads werden in der Ausgabereihenfolge von SHA-512 gelesen. In jedem WORD steht das obere Oktett zuerst.
- Auf die digest bit string wird keine eigene GEUL-Endian-Umwandlung angewandt. Die Oktettfolge der Ausgabe wird nur der Reihe nach zu je zwei Oktetten zusammengefasst und als 16-Bit-Big-Endian-WORD gerahmt.
- Ein Payload, der nicht 32 WORD hat, oder eine willkürlich gekürzte Darstellung des Ergebnisses wird abgelehnt. Es gibt weder Descriptor noch Padding.

## Normgrundlage

- Der SHA-512-Algorithmus und das 512-Bit-Ergebnis richten sich nach NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL-TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und nicht Teil des SHA-2-Algorithmus.

## Länge

- Insgesamt sind es genau 36 WORD aus 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 1 WORD Issuer, 1 WORD Formatnummer und 32 WORD Payload, mit `LLLL=1110`. Es gibt weder Descriptor noch Padding.
- Ist der Payload nicht genau 32 WORD, wird abgelehnt.

## Beispiel

- Die digest-Oktette `d[0]` bis `d[63]` werden der Reihe nach als Payload-WORD `(d[0]<<8)|d[1]` bis `(d[62]<<8)|d[63]` abgelegt. Die gesamte Length ist stets 36 WORD.
