---
title: "COMPLEX128"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 ist ein Value, der eine komplexe Zahl aus zwei IEEE-754-binary64-Komponenten in der Reihenfolge (real, imag) darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 ist ein Value, der eine komplexe Zahl aus zwei IEEE-754-binary64-Komponenten in der Reihenfolge `(real, imag)` darstellt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000701`, Familie NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  insgesamt 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Jede Komponente besteht aus binary64-Interchange-Bits in Big-Endian-WORD-Reihenfolge.
- Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten, und es gibt kein ABI-Padding.
- Der Payload umfasst genau 8 WORD. Alle Interchange-Bitmuster der beiden binary64-Komponenten bleiben erhalten.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Dass `complex128` aus einer 64-Bit-Real- und einer 64-Bit-Imaginärkomponente besteht, folgt [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html); die Reihenfolge Real zuerst entspricht dem Complex-Raw-Data-Mapping im offiziellen [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). Das Bitmuster jeder Komponente folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ONNX Raw Data ist Little-Endian fester Breite, dieses Format verwendet jedoch das GEUL-Big-Endian-WORD-Framing und ist daher keine ONNX-TensorProto-Wire-Serialisierung als solche.

## Länge {#길이}

- Die Gesamtlänge ist genau 13 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 8 WORD Payload; verwendet wird die direkte Länge `LLLL=1100`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 8 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Sind die beiden binary64 im Payload `1.0, -0.0`, ist der Wert mit Realteil 1.0 und Imaginärteil -0.0 gegeben.
