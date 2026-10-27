---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR is an ADHOC Issuer format that holds C-contiguous row-major elements after an element format, rank, and shape descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR is a tensor Value that writes the shape and element format in a Payload descriptor and stores a C-contiguous row-major payload. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0600`, family NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload rest      [dense payload]
```

## Interpretation

- The rank is a 4-bit value in the descriptor, so structurally only `0..15` can be expressed. Each dimension is a non-negative big-endian uint32.
- As in the logical tensor rules of ONNX, a rank 0 shape `[]` is a scalar of 1 element, and if any dimension is 0, the element count is 0. Otherwise the element count is the product of all dimensions.
- The payload is read in the element format of the descriptor, in C-contiguous row-major order. The calculated logical element count must equal the number of elements in the payload after the descriptor.

## Validity

- Once the supported versions and element formats are set, recover the payload boundary with that element width, and verify it against the shape product calculated without overflow.
- The descriptor, all dimensions, and the payload must fit completely within the record Length, and there is no arbitrary ABI padding.

## Standards Basis and Format Status

- The rules that a shape is a list of non-negative dimensions and the value count equals the product of the dimensions, and the meaning of a rank 0 scalar and a zero dimension, follow the [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). The C-contiguous row-major logical order matches the order of the [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- The 4-bit rank, uint32 dimensions, the version and element-format fields, the GEUL TAG/Length, and the big-endian WORD payload are a GEUL-specific descriptor. It is not the wire or memory serialization of the [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), ONNX TensorProto, or the [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Records and the TAG WORD](/grammar/record/)).
- The descriptor is 1 WORD, the shape is `2 × rank` WORDs, and the rest is the payload.

## Example

- For a profile with rank 2, the 4 WORDs after the descriptor are the two uint32 dimensions, and everything after that is the row-major payload. Whether it is actually allowed and the element count check need a confirmed version and format profile.

## Open Questions

- The values of the version and element-format registries, and the range of profiles to support among the expressible ranks `0..15`, are not yet decided.
