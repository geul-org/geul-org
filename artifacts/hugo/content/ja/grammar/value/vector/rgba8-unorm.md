---
title: "RGBA8-UNORM"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM は、R、G、B、A 順の UNORM8 四つの成分を Payload 2 WORD に収めるピクセル Value だ(KHRONOS Issuer 形式 0x0000)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM は、R、G、B、A の四つの UNORM8 成分を、固定 Payload 2 WORD に packed で保存する Value だ。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0041` KHRONOS、形式番号 `0x0000`。系列 NUMERIC。

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  全体 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
形式番号          1 WORD  0x0000
Payload WORD 1st: [R: 上位 8bit][G: 下位 8bit]
Payload WORD 2nd: [B: 上位 8bit][A: 下位 8bit]
```

## 解釈規則

- シリアライズの byte 順は `R, G, B, A` で、各成分 byte `b` の値は `b / 255` だ。
- これは、Vulkan `VK_FORMAT_R8G8B8A8_UNORM` の byte 0~3 の component 順序と UNORM 数値 mapping に対応する。
- `_SRGB` 形式ではないので、sRGB や他の色空間・transfer function を暗示しない。alpha も UNORM の数値だが、straight/premultiplied かと compositing の意味は外部の文脈だ。ABI padding はない。

## 有効性

- すべての 8ビットパターンが有効だ。Payload はちょうど 2 WORD でなければならない。

## 標準の根拠と形式の位置づけ

- component の memory order と UNORM の意味は、Khronos の [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) と [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) の `VK_FORMAT_R8G8B8A8_UNORM` に合わせる。
- GEUL TAG/Length と二つの 16ビット big-endian WORD framing は GEUL 固有の規則で、Vulkan image 自体のシリアライズは定義しない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 2 WORD を合わせたちょうど 5 WORD で、直接長さ `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 2 WORD でなければ拒否する。

## 例

- Payload `ff00 0080` は bytes `R=ff, G=00, B=00, A=80` だ。
