---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 is a Value that represents a quaternion by four IEEE 754 binary32 components in the order (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 is a Value that represents a quaternion by four IEEE 754 binary32 components in the order `(x, y, z, w)`. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000704`, family NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD in total
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretation and validity {#해석과-유효성}

- Each component is binary32 interchange bits in big-endian WORD order.
- The frame, handedness, unit norm, and `q/-q` equivalence are external context and are not part of the meaning of this format.
- The NaN payload and signed zero bit pattern are preserved, and there is no ABI padding.
- The Payload is exactly 8 WORD. This format does not enforce unit norm or `q/-q` normalization.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The `x, y, z, w` order is the same as the quaternion component order of the Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/), and each component is [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- A glTF node rotation requires a unit quaternion whose W is the scalar. This format is a general quaternion that does not enforce unit norm or rotation semantics, so it cannot be regarded as the same as a glTF rotation unless an external profile adds those conditions.

## Length {#길이}

- The total is exactly 13 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 8 WORD, and it uses the direct length `LLLL=1100`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 8 WORD, it is rejected.

## Example {#예시}

- The components `(0.0, 0.0, 0.0, 1.0)` are a valid value that stores the four bit patterns in order.
