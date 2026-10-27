---
title: "DENSE-BINARY32-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR is a 1-dimensional vector Value that holds binary32 elements contiguously with no descriptor (ADHOC Issuer format 0x0508)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR holds IEEE 754 binary32 interchange bit patterns contiguously with no descriptor.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0508`. Family NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## Interpretation Rules

- 2 consecutive WORDs make one element and are read from the upper WORD. Bit patterns, including NaN payloads and signed zero, are preserved as they are.
- The element count is 1/2 of the Payload WORD count, and there is no ABI padding.

## Validity

- The Payload must be at least 2 WORDs and an integer multiple of 2 WORDs. This format, which has no descriptor, does not allow an empty vector.

## Standards Basis and Format Status

- The interchange format of binary32 elements follows [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- The contiguous 1-dimensional sequence with no descriptor, the GEUL TAG/Length, and the 16-bit big-endian WORD placement are a GEUL-specific format. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) assumes native-endian, so this Payload is not the wire serialization of DLPack, Arrow, or ONNX.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).

## Example

- The Payload `3f80 0000 8000 0000` is binary32 `[1.0, -0]`, a 7 WORD record.
