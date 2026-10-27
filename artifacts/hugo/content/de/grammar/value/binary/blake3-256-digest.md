---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST ist ein Issuer-Format mit festen 20 WORD, das die ersten 32 Oktette der Ausgabe des BLAKE3-Standard-Hash-Modus enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST ist ein Value fester Breite, der die ersten 32 Oktette (256 Bit) der Ausgabe des BLAKE3-default-hash-mode enthält. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0xC000`, Familie BINARY. Der Payload ist genau 16 WORD, und keyed hash mode, key derivation mode und XOF-Ausgaben anderer Länge sind nicht enthalten.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0014 (insgesamt 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretation und Gültigkeit

- Der Payload sind die ersten 32 Oktette des output stream des BLAKE3-default-hash-mode. Die Ausgabereihenfolge bleibt erhalten, und in jedem WORD steht das obere Oktett zuerst.
- Auf die Ausgabe wird keine eigene GEUL-Endian-Umwandlung angewandt. Die Oktettfolge der Ausgabe wird der Reihe nach zu je zwei Oktetten zusammengefasst und als 16-Bit-Big-Endian-WORD gerahmt.
- Ein Payload, der nicht 16 WORD hat, oder eine Darstellung, die Ergebnisse von keyed_hash, derive_key oder XOF anderer Länge enthält, wird abgelehnt. Es gibt weder Descriptor noch Padding.

## Normgrundlage

- Algorithmus sowie Definition von Modus und Ausgabe richten sich nach dem [offiziellen Implementierungs-Repository](https://github.com/BLAKE3-team/BLAKE3) des BLAKE3-Teams und der [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- GEUL-TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und nicht Teil des BLAKE3-Algorithmus.

## Länge

- Insgesamt sind es genau 20 WORD aus 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 1 WORD Issuer, 1 WORD Formatnummer und 16 WORD Payload, mit `LLLL=1110`. Es gibt weder Descriptor noch Padding.
- Ist der Payload nicht genau 16 WORD, wird abgelehnt.

## Beispiel

- Die output-Oktette `d[0]` bis `d[31]` werden in der Ausgabereihenfolge zu je zwei Oktetten in die 16 Payload-WORD gelegt. Die gesamte Length ist stets 20 WORD.
