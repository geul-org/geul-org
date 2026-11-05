---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR is a tensor Value that writes the shape and element format in the Payload descriptor and stores a C-contiguous row-major payload."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR is a tensor Value that writes the shape and element format in the Payload descriptor and stores a C-contiguous row-major payload. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000600`, family NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length ext. TAG] when the total is 15 WORD or more
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload rest      [dense payload]
```

## Interpretation {#해석}

- The rank is a 4-bit value in the descriptor, so structurally only `0..15` can be expressed. Each dimension is a non-negative big-endian uint32.
- As in the logical tensor rules of ONNX, a rank 0 shape `[]` is a scalar with one element, and if any dimension is 0 the number of elements is 0. Otherwise the number of elements is the product of all dimensions.
- The payload is read with the element format of the descriptor, in C-contiguous row-major order. The computed number of logical elements must equal the number of elements in the payload after the descriptor.

## Validity {#유효성}

- Once the supported version and element format are determined, the payload boundary is recovered with that element width, and it is verified against the shape product computed without overflow.
- The descriptor, all dimensions, and the payload must fit completely within the record Length, and there is no arbitrary ABI padding.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The rule that a shape is a list of non-negative dimensions and the number of values equals the product of the dimensions, and the meaning of a rank 0 scalar and a zero dimension, follow the [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). The C-contiguous row-major logical order matches the order of the [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- The 4-bit rank, the uint32 dimensions, the version/element-format fields, the GEUL TAG/Length, and the big-endian WORD payload are a GEUL-specific descriptor. They are not the wire or memory serialization of the [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), ONNX TensorProto, or the [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Length {#길이}

- The total is the number of WORD obtained by adding TAG 1 WORD, the Length extension TAG (if present), Issuer 2 WORD, codec number 2 WORD, and the Payload. 14 WORD or fewer use the direct length, and 15 WORD or more use the `1110` or `1111` extended length, and the extension TAG is included in the total ([Record and TAG WORD](../../record.md)).
- The descriptor is 1 WORD, the shape is `2 × rank` WORD, and the remainder is the payload.

## Example {#예시}

- In a profile where the rank is 2, the 4 WORD after the descriptor are the two uint32 dimensions, and everything after that is the row-major payload. Whether it is actually allowed and the verification of the number of elements require a finalized version and format profile.

## Open problems {#열린-문제}

- The values of the version and element-format registries, and the range of profiles to support among the expressible ranks `0..15`, have not yet been decided.
