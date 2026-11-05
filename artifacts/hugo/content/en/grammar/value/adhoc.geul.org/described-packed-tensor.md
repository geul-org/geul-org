---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR is a tensor Value that writes the shape and packed format in the Payload descriptor and stores elements smaller than a WORD in packed form."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR is a tensor Value that writes the shape and packed format in the Payload descriptor and stores elements smaller than a WORD in packed form. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000601`, family NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length ext. TAG] when the total is 15 WORD or more
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload rest      [packed payload octet stream, low-bit-first]
```

## Interpretation {#해석}

- The rank is a 4-bit value in the descriptor, so structurally only `0..15` can be expressed. Each dimension is a non-negative big-endian uint32. The logical order is C-contiguous row-major.
- As in the logical tensor rules of ONNX, a rank 0 shape `[]` is a scalar with one element, and if any dimension is 0 the number of elements is 0. Otherwise the number of elements is the product of all dimensions.
- The packed-format fixes the element encoding and bit width, as for int2/int4, FP4/FP6, and certain FP8 variants.
- Let the payload octet sequence be `p[0], p[1], ...` and view it as the little-bit-endian integer `P = Σ(p[j] << (8j))`. Then the logical element `i` of width `w` is `(P >> (i × w)) & ((1 << w) - 1)`. That is, elements are placed starting from the lowest bits, beginning with the first element.
- In WORD, `p[0]` is carried as the upper octet of the first WORD and `p[1]` as the lower octet, and so on. The unused upper tail bits of the last used octet must be 0, and if the number of payload octets is odd, the entire unused lower octet of the last WORD must be `00`.

## Validity {#유효성}

- When the bit width of the supported format is applied, the product of the shape dimensions computed without overflow must match the number of payload elements.
- If any high tail bit or octet padding after the required payload bits is 1, it is rejected. The descriptor, shape, and payload must fit completely within the record Length.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The logical meaning of the shape, the rank 0 scalar, and the zero dimension follows the [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). The rule of placing sub-byte elements starting from the lower bits follows the int2/int4 packing of the official [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) and the little bit-endian packing of [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- The 4-bit rank, the uint32 dimensions, the version/packed-format fields, the grouping of octets into big-endian WORD, and the GEUL TAG/Length are a GEUL-specific descriptor. They are not the wire or memory serialization of ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html), or DLPack themselves.

## Length {#길이}

- The total is the number of WORD obtained by adding TAG 1 WORD, the Length extension TAG (if present), Issuer 2 WORD, codec number 2 WORD, and the Payload. 14 WORD or fewer use the direct length, and 15 WORD or more use the `1110` or `1111` extended length, and the extension TAG is included in the total ([Record and TAG WORD](../../record.md)).
- The descriptor is 1 WORD, the shape is `2 × rank` WORD, and the remainder is the packed payload.
- If the number of logical elements is `N` and the element width is `w`, the number of payload octets is `ceil(N × w / 8)`, and the number of payload WORD is `ceil(number of payload octets / 2)`.

## Example {#예시}

- In a profile where the rank is 2, the 4 WORD after the descriptor are the shape, and what follows is the low-bit-first payload octet sequence. The element width and whether it is actually allowed are judged by the finalized format profile.
- The payload octet sequence of the 4-bit elements `[1, 2, 3]` is `21 03`, and the payload WORD is `2103`. The first element is in the low nibble of the first octet, and the unused high nibble of the last octet is 0.

## Open problems {#열린-문제}

- The values of the version and packed-format registries, and the range of profiles to support among the expressible ranks `0..15`, have not yet been decided.
