---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 is a Value that represents a complex number by two IEEE 754 binary32 components in the order (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 is a Value that represents a complex number by two IEEE 754 binary32 components in the order `(real, imag)`. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000700`, family NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD in total
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretation and validity {#해석과-유효성}

- Each component is binary32 interchange bits in big-endian WORD order.
- The bit pattern, including NaN payload and signed zero, is preserved as is, and there is no ABI padding.
- The Payload is exactly 4 WORD. All interchange bit patterns of the two binary32 components are preserved.

## Standards basis and formal status {#표준-근거와-형식-지위}

- That `complex64` consists of a 32-bit real component and a 32-bit imaginary component follows the [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), and the real-first order is the same as the complex raw-data mapping of the official [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). The bit pattern of each component follows [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data is fixed-width little-endian, but this format uses GEUL big-endian WORD framing, so it is not the ONNX TensorProto wire serialization itself.

## Length {#길이}

- The total is exactly 9 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 4 WORD, and it uses the direct length `LLLL=1000`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 4 WORD, it is rejected.

## Example {#예시}

- The Payload `3F80 0000 4000 0000` is `1.0 + 2.0i`.
