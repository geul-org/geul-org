---
title: "DENSE-BINARY16-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR is a 1-dimensional vector Value that holds binary16 elements contiguously with no descriptor (ADHOC Issuer format 0x0506)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR holds IEEE 754 binary16 interchange bit patterns contiguously with no descriptor.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0506`. Family NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Interpretation Rules

- The element count is the Payload WORD count. Bit patterns, including NaN payloads and signed zero, are preserved as they are.
- There is no ABI padding between elements or at the end.

## Validity

- The Payload must be at least 1 WORD. This format, which has no descriptor, does not allow an empty vector.
- The Payload size must be an integer multiple of the element width of 1 WORD.

## Standards Basis and Format Status

- The interchange format of binary16 elements follows [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- The contiguous 1-dimensional sequence with no descriptor, the GEUL TAG/Length, and the 16-bit big-endian WORD placement are a GEUL-specific format. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) assumes native-endian, so this Payload is not the wire serialization of DLPack, Arrow, or ONNX.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).

## Example

- The Payload `3c00 8000` is binary16 `1.0` and `-0`, a 5 WORD record.
