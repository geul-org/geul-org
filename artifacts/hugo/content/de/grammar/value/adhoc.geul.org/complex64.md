---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 ist ein Value, der eine komplexe Zahl aus zwei IEEE-754-binary32-Komponenten in der Reihenfolge (real, imag) darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 ist ein Value, der eine komplexe Zahl aus zwei IEEE-754-binary32-Komponenten in der Reihenfolge `(real, imag)` darstellt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000700`, Familie NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  insgesamt 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Jede Komponente besteht aus binary32-Interchange-Bits in Big-Endian-WORD-Reihenfolge.
- Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten, und es gibt kein ABI-Padding.
- Der Payload umfasst genau 4 WORD. Alle Interchange-Bitmuster der beiden binary32-Komponenten bleiben erhalten.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Dass `complex64` aus einer 32-Bit-Real- und einer 32-Bit-Imaginärkomponente besteht, folgt [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html); die Reihenfolge Real zuerst entspricht dem Complex-Raw-Data-Mapping im offiziellen [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). Das Bitmuster jeder Komponente folgt [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ONNX Raw Data ist Little-Endian fester Breite, dieses Format verwendet jedoch das GEUL-Big-Endian-WORD-Framing und ist daher keine ONNX-TensorProto-Wire-Serialisierung als solche.

## Länge {#길이}

- Die Gesamtlänge ist genau 9 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 4 WORD Payload; verwendet wird die direkte Länge `LLLL=1000`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 4 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Der Payload `3F80 0000 4000 0000` ist `1.0 + 2.0i`.
