---
title: "DENSE-BINARY64-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR stores IEEE 754 binary64 interchange bit patterns back to back without a descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR stores IEEE 754 binary64 interchange bit patterns back to back without a descriptor.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000509`. Family NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length ext. TAG] when the total is 15 WORD or more
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## Interpretation rules {#해석-규칙}

- Each run of 4 consecutive WORD is one element, read from the most significant WORD first. The bit pattern, including NaN payload and signed zero, is preserved as is.
- The number of elements is 1/4 of the number of Payload WORD, and there is no ABI padding.

## Validity {#유효성}

- The Payload must be at least 4 WORD and an integer multiple of 4 WORD. This format has no descriptor and does not allow an empty vector.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The interchange format of binary64 elements follows [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- The descriptor-less 1-dimensional contiguous run and the placement in GEUL TAG/Length and 16-bit big-endian WORD are specific to GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) assumes native endianness, so this Payload is not the wire serialization of DLPack, Arrow, or ONNX.

## Length {#길이}

- The total is the number of WORD obtained by adding TAG 1 WORD, the Length extension TAG (if present), Issuer 2 WORD, codec number 2 WORD, and the Payload. 14 WORD or fewer use the direct length, and 15 WORD or more use the `1110` or `1111` extended length, and the extension TAG is included in the total ([Length](../../record.md)).

## Example {#예시}

- The Payload `3FF0 0000 0000 0000` is binary64 `[1.0]`, and the record is 9 WORD in total.
