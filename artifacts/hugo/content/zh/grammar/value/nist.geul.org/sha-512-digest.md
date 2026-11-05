---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST 是承载 SHA-2 系列 SHA-512 完整结果的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST 是承载 SHA-2 系列 SHA-512 完整结果的定宽 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000015` NIST，Codec 编号 `0x0000C000`，系列 BINARY。Payload 恰好是 32 WORD（512 bit），不允许截断（truncation）。

## 布局 {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 扩展 TAG   1 WORD  0x0026 (总计 38 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Codec 编号        2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 64 octet 按 SHA-512 的输出顺序读取。每个 WORD 中高位 octet 在前。
- 不对 digest bit string 另行应用 GEUL endian 转换。只是将输出 octet sequence 按顺序每两个 octet 一组，以 16bit big-endian WORD 进行 framing。
- Payload 不是 32 WORD，或任意截断结果的表示，均予以拒绝。没有 descriptor 和 padding。

## 标准依据 {#표준-근거}

- SHA-512 算法与 512bit 结果遵循 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)。
- GEUL TAG、Length、16bit WORD framing 是此格式新增的规则，不属于 SHA-2 算法的一部分。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 32 WORD 之和，恰好 38 WORD，使用 `LLLL=1110`。没有 descriptor 和 padding。
- Payload 不是恰好 32 WORD 则拒绝。

## 示例 {#예시}

- digest octet `d[0]` 至 `d[63]` 依次放为 Payload WORD `(d[0]<<8)|d[1]` 至 `(d[62]<<8)|d[63]`。总 Length 始终为 38 WORD。
