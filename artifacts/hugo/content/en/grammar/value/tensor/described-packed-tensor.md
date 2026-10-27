---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR is an ADHOC Issuer format that holds sub-WORD elements packed low-bit-first after a packed format, rank, and shape descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR is a tensor Value that writes the shape and packed format in a Payload descriptor and stores elements smaller than a WORD in packed form. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0601`, family NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload rest      [packed payload octet stream, low-bit-first]
```

## Interpretation

- The rank is a 4-bit value in the descriptor, so structurally only `0..15` can be expressed. Each dimension is a non-negative big-endian uint32. The logical order is C-contiguous row-major.
- As in the logical tensor rules of ONNX, a rank 0 shape `[]` is a scalar of 1 element, and if any dimension is 0, the element count is 0. Otherwise the element count is the product of all dimensions.
- The packed-format fixes the element encoding and bit width, as for int2/int4, FP4/FP6, and certain FP8 variants.
- Call the payload octet sequence `p[0], p[1], ...` and view it as the little-bit-endian integer `P = Σ(p[j] << (8j))`. Then logical element `i` of width `w` is `(P >> (i × w)) & ((1 << w) - 1)`. That is, elements are put into the lowest bits starting from the first element.
- In WORDs, `p[0]` is loaded as the upper octet of the first WORD and `p[1]` as the lower octet, in that order. The unused upper tail bits of the last used octet must be 0, and if the payload octet count is odd, the whole unused lower octet of the last WORD must be `00`.

## Validity

- With the bit width of the supported format applied, the shape's dimension product calculated without overflow must match the payload element count.
- If any high tail bit or octet padding after the required payload bits is 1, reject. The descriptor, shape, and payload must fit completely within the record Length.

## Standards Basis and Format Status

- The logical meaning of the shape, rank 0 scalar, and zero dimension follows the [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). The rule of placing sub-byte elements from the lowest bits follows the int2/int4 packing of the official [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) and the little bit-endian packing of [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- The 4-bit rank, uint32 dimensions, the version and packed-format fields, the way octets are grouped into big-endian WORDs, and the GEUL TAG/Length are a GEUL-specific descriptor. It is not the wire or memory serialization of ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html), or DLPack themselves.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Records and the TAG WORD](/grammar/record/)).
- The descriptor is 1 WORD, the shape is `2 × rank` WORDs, and the rest is the packed payload.
- If the logical element count is `N` and the element width is `w`, the payload octet count is `ceil(N × w / 8)` and the payload WORD count is `ceil(payload octet count / 2)`.

## Example

- For a profile with rank 2, the 4 WORDs after the descriptor are the shape, and what follows is the low-bit-first payload octet sequence. The element width and whether it is actually allowed are judged by a confirmed format profile.
- The payload octet sequence of the 4-bit elements `[1, 2, 3]` is `21 03`, and the payload WORD is `2103`. The first element is in the lower nibble of the first octet, and the unused upper nibble of the last octet is 0.

## Open Questions

- The values of the version and packed-format registries, and the range of profiles to support among the expressible ranks `0..15`, are not yet decided.
