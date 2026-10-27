---
title: "BGRA8-UNORM"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM 是把 B, G, R, A 顺序的 UNORM8 四个分量放入 Payload 2 WORD 的像素 Value（KHRONOS Issuer 格式 0x0001）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM 是把 B、G、R、A 四个 UNORM8 分量 packed 存放在固定 Payload 2 WORD 中的 Value。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0041` KHRONOS，格式编号 `0x0001`。系列 NUMERIC。

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  总计 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
格式编号          1 WORD  0x0001
Payload WORD 1st: [B: 高 8bit][G: 低 8bit]
Payload WORD 2nd: [R: 高 8bit][A: 低 8bit]
```

## 解读规则

- 序列化 byte 顺序是 `B, G, R, A`，每个分量 byte `b` 的值是 `b / 255`。
- 这对应 Vulkan `VK_FORMAT_B8G8R8A8_UNORM` 的 byte 0~3 component 顺序和 UNORM 数值 mapping。
- 它不是 `_SRGB` 格式，所以不暗示 sRGB 或其他色彩空间·transfer function。alpha 也是 UNORM 数值，但 straight/premultiplied 与否以及 compositing 含义属于外部上下文。没有 ABI padding。

## 有效性

- 所有 8 位模式都有效。Payload 必须恰好是 2 WORD。

## 标准依据与格式地位

- component memory order 和 UNORM 含义，对应 Khronos 的 [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) 和 [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) 中的 `VK_FORMAT_B8G8R8A8_UNORM`。
- GEUL TAG/Length 与两个 16 位 big-endian WORD framing 是 GEUL 专有规则，并未定义 Vulkan image 本身的 serialization。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD 与 Payload 2 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例

- Payload `0000 ff80` 是 bytes `B=00, G=00, R=ff, A=80`。
