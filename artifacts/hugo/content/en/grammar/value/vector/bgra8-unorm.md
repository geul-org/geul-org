---
title: "BGRA8-UNORM"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM is a pixel Value that holds four UNORM8 components in the order B, G, R, A in a 2 WORD Payload (KHRONOS Issuer format 0x0001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM is a Value that stores the four UNORM8 components B, G, R, and A packed in a fixed Payload of 2 WORDs.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0041` KHRONOS, format number `0x0001`. Family NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD in total
Issuer            1 WORD  0x0041 (KHRONOS)
Format number     1 WORD  0x0001
Payload WORD 1st: [B: upper 8bit][G: lower 8bit]
Payload WORD 2nd: [R: upper 8bit][A: lower 8bit]
```

## Interpretation Rules

- The serialized byte order is `B, G, R, A`, and the value of each component byte `b` is `b / 255`.
- This corresponds to the byte 0-3 component order and the UNORM numeric mapping of Vulkan `VK_FORMAT_B8G8R8A8_UNORM`.
- It is not an `_SRGB` format, so it implies neither sRGB nor any other color space or transfer function. Alpha is also a UNORM number, but whether it is straight or premultiplied and its compositing meaning are external context. There is no ABI padding.

## Validity

- Every 8-bit pattern is valid. The Payload must be exactly 2 WORDs.

## Standards Basis and Format Status

- The component memory order and UNORM meaning match `VK_FORMAT_B8G8R8A8_UNORM` of the Khronos [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) and the [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html).
- The GEUL TAG/Length and the framing of two 16-bit big-endian WORDs are GEUL-specific rules, and do not define the serialization of a Vulkan image itself.

## Length

- The total is exactly 5 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 2 WORD, using the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 2 WORDs, reject.

## Example

- The Payload `0000 ff80` is the bytes `B=00, G=00, R=ff, A=80`.
