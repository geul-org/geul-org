---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 ist ein ADHOC-Issuer-Format mit festen 11 WORD, das eine komplexe Zahl aus zwei binary64-Komponenten für Real- und Imaginärteil enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 ist ein Value, der eine komplexe Zahl aus zwei IEEE-754-binary64-Komponenten in der Reihenfolge `(real, imag)` darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0701`, Familie NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  insgesamt 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretation und Gültigkeit

- Jede Komponente sind binary64-Interchange-Bits in Big-Endian-WORD-Reihenfolge.
- Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten, und es gibt kein ABI-Padding.
- Der Payload ist genau 8 WORD. Alle Interchange-Bitmuster der beiden binary64-Komponenten bleiben erhalten.

## Normgrundlage und Formatstatus

- Dass `complex128` aus einer 64-Bit-Real- und einer 64-Bit-Imaginärkomponente besteht, richtet sich nach [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), und die Real-zuerst-Reihenfolge entspricht dem complex raw-data mapping des offiziellen [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). Das Bitmuster jeder Komponente folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data ist Little-Endian fester Breite, aber dieses Format verwendet das Big-Endian-WORD-Framing von GEUL und ist daher selbst keine Wire-Serialisierung von ONNX TensorProto.

## Länge

- Insgesamt sind es genau 11 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 8 WORD Payload, mit der direkten Länge `LLLL=1010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Beispiel

- Sind die beiden binary64 des Payloads `1.0, -0.0`, ist es ein Wert mit Realteil 1.0 und Imaginärteil -0.0.
