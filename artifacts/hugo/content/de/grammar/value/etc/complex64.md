---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 ist ein ADHOC-Issuer-Format mit festen 7 WORD, das eine komplexe Zahl aus zwei binary32-Komponenten für Real- und Imaginärteil enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 ist ein Value, der eine komplexe Zahl aus zwei IEEE-754-binary32-Komponenten in der Reihenfolge `(real, imag)` darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0700`, Familie NUMERIC.

## Layout

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  insgesamt 7 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretation und Gültigkeit

- Jede Komponente sind binary32-Interchange-Bits in Big-Endian-WORD-Reihenfolge.
- Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten, und es gibt kein ABI-Padding.
- Der Payload ist genau 4 WORD. Alle Interchange-Bitmuster der beiden binary32-Komponenten bleiben erhalten.

## Normgrundlage und Formatstatus

- Dass `complex64` aus einer 32-Bit-Real- und einer 32-Bit-Imaginärkomponente besteht, richtet sich nach [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), und die Real-zuerst-Reihenfolge entspricht dem complex raw-data mapping des offiziellen [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). Das Bitmuster jeder Komponente folgt [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data ist Little-Endian fester Breite, aber dieses Format verwendet das Big-Endian-WORD-Framing von GEUL und ist daher selbst keine Wire-Serialisierung von ONNX TensorProto.

## Länge

- Insgesamt sind es genau 7 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 4 WORD Payload, mit der direkten Länge `LLLL=0110`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- Der Payload `3f80 0000 4000 0000` ist `1.0 + 2.0i`.
