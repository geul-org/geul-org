---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST ist ein Value mit festen 18 WORD, der das gesamte SHA-256-Ergebnis mit 256 Bit enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST ist ein Value fester Breite, der das gesamte Ergebnis von SHA-256 aus der SHA-2-Familie enthält. Direkter Value-Code `0x61`, Familie BINARY. Der Payload ist genau 16 WORD (256 Bit), und Kürzen (truncation) ist nicht zulässig.

## Layout

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0012 (insgesamt 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## Interpretation und Gültigkeit

- Die 32 Oktette des Payloads werden in der Ausgabereihenfolge von SHA-256 gelesen. In jedem WORD steht das obere Oktett zuerst.
- Auf die digest bit string wird keine eigene GEUL-Endian-Umwandlung angewandt. Die Oktettfolge der Ausgabe wird nur der Reihe nach zu je zwei Oktetten zusammengefasst und als 16-Bit-Big-Endian-WORD gerahmt.
- Ein Payload, der nicht 16 WORD hat, oder eine willkürlich gekürzte Darstellung des Ergebnisses wird abgelehnt. Es gibt weder Descriptor noch Padding.

## Normgrundlage

- Der SHA-256-Algorithmus und das 256-Bit-Ergebnis richten sich nach NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL-TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und nicht Teil des SHA-2-Algorithmus.

## Länge

- Insgesamt sind es genau 18 WORD aus 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG und 16 WORD Payload, mit `LLLL=1110`. Es gibt weder Descriptor noch Padding.
- Ist der Payload nicht genau 16 WORD, wird abgelehnt.

## Beispiel

- Die digest-Oktette `d[0]` bis `d[31]` werden der Reihe nach als Payload-WORD `(d[0]<<8)|d[1]` bis `(d[30]<<8)|d[31]` abgelegt. Die gesamte Length ist stets 18 WORD.
