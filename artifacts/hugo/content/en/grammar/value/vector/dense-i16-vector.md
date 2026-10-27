---
title: "DENSE-I16-VECTOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR is a 1-dimensional vector Value that holds big-endian int16 elements contiguously with no descriptor (ADHOC Issuer format 0x0500)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR is a homogeneous 1-dimensional Value that holds big-endian int16 elements contiguously with no descriptor.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0500`. Family NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## Interpretation Rules

- Each WORD is read as an independent 16-bit two's complement integer. The element count is the Payload WORD count.
- There is no ABI padding between elements or at the end.

## Validity

- The Payload must be at least 1 WORD. This format, which has no descriptor, does not allow an empty vector.
- The Payload size must be an integer multiple of the element width of 1 WORD.

## Standards Basis and Format Status

- The signedness and 16-bit width of a signed integer dtype match the industry dtypes of the [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) and [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- The two's complement interpretation, the contiguous 1-dimensional sequence with no descriptor, the GEUL TAG/Length, and the big-endian WORD placement are a GEUL-specific format. DLPack assumes native-endian for dtype, so this Payload is not the wire serialization of DLPack or ONNX.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).

## Example

- The Payload `ffff 0002` is the elements `[-1, 2]`, a 5 WORD record with the direct length `LLLL=0100`.
