---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST 是承载 SHA-256 结果完整 256bit 的固定 18 WORD Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST 是承载 SHA-2 系列 SHA-256 完整结果的固定宽度 Value。Value 直接码 `0x61`，系列为 BINARY。Payload 恰好是 16 WORD（256 bit），不允许截断（truncation）。

## 布局

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
Length 扩展 TAG   1 WORD  0x0012 (总计 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## 解读与有效性

- 把 Payload 的 32 octet 按 SHA-256 输出顺序原样读取。每个 WORD 中高 octet 在前。
- 不对 digest bit string 另行应用 GEUL 的 endian 转换。只是把输出 octet sequence 按顺序每两个 octet 一组，分帧为 16bit big-endian WORD。
- Payload 不是 16 WORD，或随意截断结果的表示，予以拒绝。没有 descriptor 和 padding。

## 标准依据

- SHA-256 算法和 256bit 结果遵循 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)。
- GEUL TAG、Length、16bit WORD framing 是本格式增加的规则，不是 SHA-2 算法的一部分。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG 1 WORD、Payload 16 WORD 之和，恰好 18 WORD，使用 `LLLL=1110`。没有 descriptor 和 padding。
- Payload 不是恰好 16 WORD 则拒绝。

## 示例

- digest octet `d[0]` 到 `d[31]` 依次放为 Payload WORD `(d[0]<<8)|d[1]` 到 `(d[30]<<8)|d[31]`。总 Length 始终是 18 WORD。
