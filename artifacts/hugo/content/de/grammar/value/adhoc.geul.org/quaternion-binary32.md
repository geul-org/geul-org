---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 ist ein Value, der ein Quaternion aus vier IEEE-754-binary32-Komponenten in der Reihenfolge (x, y, z, w) darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 ist ein Value, der ein Quaternion aus vier IEEE-754-binary32-Komponenten in der Reihenfolge `(x, y, z, w)` darstellt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000704`, Familie NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  insgesamt 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Jede Komponente besteht aus binary32-Interchange-Bits in Big-Endian-WORD-Reihenfolge.
- Frame, Handedness, Unit Norm und die Äquivalenz `q/-q` sind externer Kontext und nicht Teil der Bedeutung dieses Formats.
- NaN-Payload und das Bitmuster von signed zero bleiben erhalten, und es gibt kein ABI-Padding.
- Der Payload umfasst genau 8 WORD. Dieses Format erzwingt weder Unit Norm noch eine `q/-q`-Normalisierung.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Die Reihenfolge `x, y, z, w` entspricht der Quaternion-Komponentenreihenfolge der Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/), und jede Komponente ist [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Die glTF-Node-Rotation verlangt ein Unit Quaternion mit W als Scalar. Dieses Format ist ein allgemeines Quaternion, das weder Unit Norm noch Rotationsbedeutung erzwingt; es kann daher nicht als gleich mit der glTF-Rotation gelten, sofern kein externes Profil diese Bedingung hinzufügt.

## Länge {#길이}

- Die Gesamtlänge ist genau 13 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 8 WORD Payload; verwendet wird die direkte Länge `LLLL=1100`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 8 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die Komponenten `(0.0, 0.0, 0.0, 1.0)` sind ein gültiger Wert, der die vier Bitmuster der Reihe nach ablegt.
