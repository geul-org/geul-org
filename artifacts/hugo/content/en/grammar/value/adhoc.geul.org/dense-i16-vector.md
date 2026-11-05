---
title: "DENSE-I16-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR is a homogeneous 1-dimensional Value that stores big-endian int16 elements back to back without a descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR is a homogeneous 1-dimensional Value that stores big-endian int16 elements back to back without a descriptor.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000500`. Family NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length ext. TAG] when the total is 15 WORD or more
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## Interpretation rules {#해석-규칙}

- Each WORD is read as an independent 16-bit two's complement integer. The number of elements is the number of Payload WORD.
- There is no ABI padding between elements or at the end.

## Validity {#유효성}

- The Payload must be at least 1 WORD. This format has no descriptor and does not allow an empty vector.
- The Payload size must be an integer multiple of the element width of 1 WORD.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The signedness and the 16-bit width of the signed integer dtype follow the industry dtypes of the [tensor element type of the ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) and [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- The two's complement interpretation, the descriptor-less 1-dimensional contiguous run, and the placement in GEUL TAG/Length and big-endian WORD are specific to GEUL. DLPack assumes the dtype is native-endian, so this Payload is not the wire serialization of DLPack or ONNX.

## Length {#길이}

- The total is the number of WORD obtained by adding TAG 1 WORD, the Length extension TAG (if present), Issuer 2 WORD, codec number 2 WORD, and the Payload. 14 WORD or fewer use the direct length, and 15 WORD or more use the `1110` or `1111` extended length, and the extension TAG is included in the total ([Length](../../record.md)).

## Example {#예시}

- The Payload `FFFF 0002` is the elements `[-1, 2]`, and the record is 7 WORD in total with the direct length `LLLL=0110`.
