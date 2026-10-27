---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR is a 1-dimensional vector Value that holds BF16 elements contiguously with no descriptor (ADHOC Issuer format 0x0507)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR holds bfloat16 16-bit element bit patterns contiguously with no descriptor. It is a different format from binary16.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0507`. Family NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## Interpretation Rules

- The element count is the Payload WORD count. Bit patterns, including NaN payloads and signed zero, are preserved as they are.
- There is no ABI padding between elements or at the end.

## Validity

- The Payload must be at least 1 WORD. This format, which has no descriptor, does not allow an empty vector.
- The Payload size must be an integer multiple of the element width of 1 WORD.

## Standards Basis and Format Status

- That bfloat16 is a separate 16-bit dtype and is distinguished from binary16 matches the [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) and [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- The contiguous 1-dimensional bit-pattern sequence with no descriptor, the GEUL TAG/Length, and the 16-bit big-endian WORD placement are a GEUL-specific format. DLPack assumes native-endian, so this Payload is not the wire serialization of DLPack, Arrow, or ONNX.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).

## Example

- The Payload `3f80 8000` is BF16 `1.0` and `-0`, a 5 WORD record.
