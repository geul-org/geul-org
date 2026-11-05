---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST ist ein Value fester Breite, der die ersten 32 Octets (256 Bit) der Ausgabe des BLAKE3 Default Hash Mode enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST ist ein Value fester Breite, der die ersten 32 Octets (256 Bit) der Ausgabe des BLAKE3 Default Hash Mode enthält. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x0000C000`, Familie BINARY. Der Payload umfasst genau 16 WORD und enthält weder Keyed Hash Mode noch Key Derivation Mode noch XOF-Ausgaben anderer Länge.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0016 (insgesamt 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der Payload sind die ersten 32 Octets des Output Stream des BLAKE3 Default Hash Mode. Die Ausgabereihenfolge bleibt erhalten, und in jedem WORD steht das obere Octet zuerst.
- Auf die Ausgabe wird keine eigene GEUL-Endian-Umwandlung angewandt. Die Octet-Folge der Ausgabe wird der Reihe nach zu je zwei Octets zu 16-Bit-Big-Endian-WORD gerahmt.
- Ein Payload, der nicht 16 WORD umfasst, oder eine Darstellung mit Ergebnissen von keyed_hash, derive_key oder XOF anderer Länge wird abgelehnt. Descriptor und Padding gibt es nicht.

## Normgrundlage {#표준-근거}

- Algorithmus sowie Mode- und Output-Definition folgen dem [offiziellen Implementierungs-Repository](https://github.com/BLAKE3-team/BLAKE3) des BLAKE3-Teams und der [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- GEUL-TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und kein Bestandteil des BLAKE3-Algorithmus.

## Länge {#길이}

- Die Gesamtlänge ist genau 22 WORD: 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 16 WORD Payload; verwendet wird `LLLL=1110`. Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 16 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die Output-Octets `d[0]` bis `d[31]` werden in Ausgabereihenfolge zu je zwei Octets in die 16 Payload-WORD gelegt. Die Gesamtlänge beträgt immer 22 WORD.
