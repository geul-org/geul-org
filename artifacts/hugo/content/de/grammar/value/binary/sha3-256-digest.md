---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST ist ein NIST-Issuer-Format mit festen 20 WORD, das das gesamte SHA3-256-Ergebnis mit 256 Bit enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST ist ein Value fester Breite, der das gesamte Ergebnis von SHA3-256 enthält. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, Formatnummer `0xC001`, Familie BINARY. Der Payload ist genau 16 WORD (256 Bit), und Kürzen (truncation) ist nicht zulässig.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0014 (insgesamt 20 WORD)
Issuer            1 WORD  0x0062 (NIST)
Formatnummer      1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretation und Gültigkeit

- Die 32 Oktette des Payloads werden in der Ausgabereihenfolge von SHA3-256 gelesen. In jedem WORD steht das obere Oktett zuerst.
- Auf die digest bit string wird keine eigene GEUL-Endian-Umwandlung angewandt. Die Oktettfolge der Ausgabe wird nur der Reihe nach zu je zwei Oktetten zusammengefasst und als 16-Bit-Big-Endian-WORD gerahmt.
- Ein Payload, der nicht 16 WORD hat, oder eine willkürlich gekürzte Darstellung des Ergebnisses wird abgelehnt. Es gibt weder Descriptor noch Padding.

## Normgrundlage

- Der SHA3-256-Algorithmus und das 256-Bit-Ergebnis richten sich nach NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). Auch das NIST-Projekt [Hash Functions](https://csrc.nist.gov/Projects/hash-functions) informiert über den SHA-3-Standard.
- GEUL-TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und nicht Teil des SHA-3-Algorithmus.

## Länge

- Insgesamt sind es genau 20 WORD aus 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 1 WORD Issuer, 1 WORD Formatnummer und 16 WORD Payload, mit `LLLL=1110`. Es gibt weder Descriptor noch Padding.
- Ist der Payload nicht genau 16 WORD, wird abgelehnt.

## Beispiel

- Die digest-Oktette `d[0]` bis `d[31]` werden in der Ausgabereihenfolge zu je zwei Oktetten in die 16 Payload-WORD gelegt. Die gesamte Length ist stets 20 WORD.
