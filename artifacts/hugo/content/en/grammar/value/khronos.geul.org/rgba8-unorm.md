---
title: "RGBA8-UNORM"
weight: 1038
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM is a Value that stores the four UNORM8 components R, G, B, and A packed in a fixed Payload of 2 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM is a Value that stores the four UNORM8 components R, G, B, and A packed in a fixed Payload of 2 WORD.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000E` KHRONOS, codec number `0x00000000`. Family NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD in total
Issuer            2 WORD  0x0000000E (KHRONOS)
Codec number      2 WORD  0x00000000
Payload WORD 1st: [R: upper 8bit][G: lower 8bit]
Payload WORD 2nd: [B: upper 8bit][A: lower 8bit]
```

## Interpretation rules {#해석-규칙}

- The serialized byte order is `R, G, B, A`, and the value of each component byte `b` is `b / 255`.
- This corresponds to the byte 0–3 component order and the UNORM numeric mapping of Vulkan `VK_FORMAT_R8G8B8A8_UNORM`.
- It is not an `_SRGB` format, so it does not imply sRGB or any other color space or transfer function. Alpha is also a UNORM value, but whether it is straight or premultiplied and its compositing semantics are external context. There is no ABI padding.

## Validity {#유효성}

- Every 8-bit pattern is valid. The Payload must be exactly 2 WORD.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The component memory order and the UNORM meaning follow `VK_FORMAT_R8G8B8A8_UNORM` of the Khronos [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) and the [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html).
- The GEUL TAG/Length and the two 16-bit big-endian WORD framing are GEUL-specific rules and do not define the serialization of a Vulkan image itself.

## Length {#길이}

- The total is exactly 7 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 2 WORD, and it uses the direct length `LLLL=0110`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 2 WORD, it is rejected.

## Example {#예시}

- The Payload `FF00 0080` is the bytes `R=FF, G=00, B=00, A=80`.
