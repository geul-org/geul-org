---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 is a fixed 11 WORD ADHOC Issuer format that holds a quaternion as four binary32 components in the order (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 is a Value that represents a quaternion with four IEEE 754 binary32 components in the order `(x, y, z, w)`. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0704`, family NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD in total
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretation and Validity

- Each component is binary32 interchange bits in big-endian WORD order.
- The frame, handedness, unit norm, and `q/-q` equivalence are external context and are not part of the meaning of this format.
- NaN payloads and signed zero bit patterns are preserved, and there is no ABI padding.
- The Payload is exactly 8 WORDs. This format does not enforce unit norm or `q/-q` normalization.

## Standards Basis and Format Status

- The `x, y, z, w` order is the same as the quaternion component order of the Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/), and each component is [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- A glTF node rotation requires a unit quaternion with W as the scalar. This format is a general quaternion that enforces neither unit norm nor rotation meaning, so it cannot be regarded as the same as a glTF rotation unless an external profile adds that condition.

## Length

- The total is exactly 11 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 8 WORD. It uses the direct length `LLLL=1010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, reject.

## Example

- The components `(0.0, 0.0, 0.0, 1.0)` are a valid value that stores the four bit patterns in order.
