---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST ist ein Value fester Breite, der das Ergebnis von SHA3-256 vollständig enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST ist ein Value fester Breite, der das Ergebnis von SHA3-256 vollständig enthält. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, Codec-Nummer `0x0000C001`, Familie BINARY. Der Payload umfasst genau 16 WORD (256 Bit); Truncation (Abschneiden) ist nicht zulässig.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0016 (insgesamt 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Codec-Nummer      2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die 32 Octets des Payloads werden in der Ausgabereihenfolge von SHA3-256 gelesen. In jedem WORD steht das obere Octet zuerst.
- Auf den Digest-Bitstring wird keine eigene GEUL-Endian-Umwandlung angewandt. Die Octet-Folge der Ausgabe wird lediglich der Reihe nach zu je zwei Octets zu 16-Bit-Big-Endian-WORD gerahmt.
- Ein Payload, der nicht 16 WORD umfasst, oder eine Darstellung mit willkürlich abgeschnittenem Ergebnis wird abgelehnt. Descriptor und Padding gibt es nicht.

## Normgrundlage {#표준-근거}

- Der SHA3-256-Algorithmus und das 256-Bit-Ergebnis folgen NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). Auch das [Hash-Functions-Projekt](https://csrc.nist.gov/Projects/hash-functions) von NIST informiert über den SHA-3-Standard.
- GEUL-TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und kein Bestandteil des SHA-3-Algorithmus.

## Länge {#길이}

- Die Gesamtlänge ist genau 22 WORD: 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 16 WORD Payload; verwendet wird `LLLL=1110`. Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 16 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die Digest-Octets `d[0]` bis `d[31]` werden in Ausgabereihenfolge zu je zwei Octets in die 16 Payload-WORD gelegt. Die Gesamtlänge beträgt immer 22 WORD.
