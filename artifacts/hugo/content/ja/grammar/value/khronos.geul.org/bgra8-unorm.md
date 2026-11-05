---
title: "BGRA8-UNORM"
weight: 1037
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORMは、B, G, R, A の4つの UNORM8 成分を、固定の Payload 2 WORD に packed で格納する Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORMは、B, G, R, A の4つの UNORM8 成分を、固定の Payload 2 WORD に packed で格納する Value である。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x0000000E` KHRONOS、Codec 番号 `0x00000001`。系列 NUMERIC。

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  全体 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
Codec 番号        2 WORD  0x00000001
Payload WORD 1st: [B: 上位 8bit][G: 下位 8bit]
Payload WORD 2nd: [R: 上位 8bit][A: 下位 8bit]
```

## 解釈規則 {#해석-규칙}

- シリアライズ時の byte 順は `B, G, R, A` であり、各成分 byte `b` の値は `b / 255` である。
- これは Vulkan `VK_FORMAT_B8G8R8A8_UNORM` の byte 0~3 の component 順序と UNORM の数値 mapping に対応する。
- `_SRGB` 形式ではないので、sRGB やその他の色空間・transfer function を暗示しない。alpha も UNORM の数値であるが、straight/premultiplied の別と compositing の意味は外部の文脈である。ABI padding はない。

## 有効性 {#유효성}

- すべての8ビットパターンが有効である。Payload は正確に2 WORD でなければならない。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- component の memory order と UNORM の意味は、Khronos の [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) と [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) の `VK_FORMAT_B8G8R8A8_UNORM` に合わせる。
- GEUL の TAG/Length と2つの16ビット big-endian WORD の framing は GEUL 固有の規則であり、Vulkan image 自体の serialization を定義するものではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD と Payload 2 WORD を合わせた正確に7 WORD であり、直接長 `LLLL=0110` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に2 WORD でなければ拒否する。

## 例 {#예시}

- Payload `0000 FF80` は bytes `B=00, G=00, R=FF, A=80` である。
