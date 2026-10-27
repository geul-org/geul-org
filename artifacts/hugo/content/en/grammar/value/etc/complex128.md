---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 is a fixed 11 WORD ADHOC Issuer format that holds a complex number as two binary64 components, real and imaginary."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 is a Value that represents a complex number with two IEEE 754 binary64 components in the order `(real, imag)`. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0701`, family NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD in total
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretation and Validity

- Each component is binary64 interchange bits in big-endian WORD order.
- Bit patterns, including NaN payloads and signed zero, are preserved as they are, and there is no ABI padding.
- The Payload is exactly 8 WORDs. All interchange bit patterns of the two binary64 components are preserved.

## Standards Basis and Format Status

- That `complex128` consists of a 64-bit real component and a 64-bit imaginary component follows the [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), and the real-first order is the same as the complex raw-data mapping of the official [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). The bit pattern of each component follows [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data is fixed-width little-endian, but this format uses GEUL big-endian WORD framing, so it is not the ONNX TensorProto wire serialization itself.

## Length

- The total is exactly 11 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 8 WORD. It uses the direct length `LLLL=1010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, reject.

## Example

- If the two binary64 values in the Payload are `1.0, -0.0`, the value has real part 1.0 and imaginary part -0.0.
