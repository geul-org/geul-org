---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 ist ein ADHOC-Issuer-Format mit festen 11 WORD, das ein Quaternion aus vier binary32-Komponenten in der Reihenfolge (x, y, z, w) enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 ist ein Value, der ein Quaternion aus vier IEEE-754-binary32-Komponenten in der Reihenfolge `(x, y, z, w)` darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0704`, Familie NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  insgesamt 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretation und Gültigkeit

- Jede Komponente sind binary32-Interchange-Bits in Big-Endian-WORD-Reihenfolge.
- frame, handedness, unit norm und die Äquivalenz `q/-q` sind äußerer Kontext und nicht Teil der Bedeutung dieses Formats.
- Das Bitmuster von NaN-Payload und signed zero bleibt erhalten, und es gibt kein ABI-Padding.
- Der Payload ist genau 8 WORD. Dieses Format erzwingt weder unit norm noch eine Normalisierung von `q/-q`.

## Normgrundlage und Formatstatus

- Die Reihenfolge `x, y, z, w` entspricht der Komponentenreihenfolge der Quaternionen in der [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) von Khronos, und jede Komponente ist [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Die node rotation von glTF verlangt ein unit quaternion, bei dem W der Skalar ist. Dieses Format ist ein allgemeines Quaternion, das weder unit norm noch eine Rotationsbedeutung erzwingt, daher gilt es nicht als gleich mit der glTF-rotation, sofern ein externes Profil diese Bedingung nicht hinzufügt.

## Länge

- Insgesamt sind es genau 11 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 8 WORD Payload, mit der direkten Länge `LLLL=1010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Beispiel

- Die Komponenten `(0.0, 0.0, 0.0, 1.0)` sind ein gültiger Wert, bei dem die vier Bitmuster der Reihe nach gespeichert sind.
