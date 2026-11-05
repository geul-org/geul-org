---
title: "BGRA8-UNORM"
weight: 1037
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM 是将 B、G、R、A 四个 UNORM8 分量 packed 存储于固定 Payload 2 WORD 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM 是将 B、G、R、A 四个 UNORM8 分量 packed 存储于固定 Payload 2 WORD 的 Value。

## 布局 {#레이아웃}

- 码：Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x0000000E` KHRONOS，Codec 编号 `0x00000001`。系列 NUMERIC。

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  总计 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
Codec 编号        2 WORD  0x00000001
Payload WORD 1st: [B: 高 8bit][G: 低 8bit]
Payload WORD 2nd: [R: 高 8bit][A: 低 8bit]
```

## 解释规则 {#해석-규칙}

- 序列化 byte 顺序为 `B, G, R, A`，每个分量 byte `b` 的值为 `b / 255`。
- 这对应于 Vulkan `VK_FORMAT_B8G8R8A8_UNORM` 的 byte 0~3 component 顺序与 UNORM 数值 mapping。
- 它不是 `_SRGB` 格式，所以不暗示 sRGB 或其他色彩空间·transfer function。alpha 虽也是 UNORM 数值，但 straight/premultiplied 与 compositing 含义属于外部上下文。没有 ABI padding。

## 有效性 {#유효성}

- 所有 8 位模式均有效。Payload 必须恰好是 2 WORD。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- component memory order 与 UNORM 含义对齐 Khronos 的 [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) 与 [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) 的 `VK_FORMAT_B8G8R8A8_UNORM`。
- GEUL TAG/Length 与两个 16 位 big-endian WORD framing 是 GEUL 特有的规则，并不定义 Vulkan image 本身的 serialization。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD 与 Payload 2 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例 {#예시}

- Payload `0000 FF80` 是 bytes `B=00, G=00, R=FF, A=80`。
