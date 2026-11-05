---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST 是承载 SHA3-256 完整结果的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST 是承载 SHA3-256 完整结果的定宽 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000015` NIST，Codec 编号 `0x0000C001`，系列 BINARY。Payload 恰好是 16 WORD（256 bit），不允许截断（truncation）。

## 布局 {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 扩展 TAG   1 WORD  0x0016 (总计 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Codec 编号        2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 32 octet 按 SHA3-256 的输出顺序读取。每个 WORD 中高位 octet 在前。
- 不对 digest bit string 另行应用 GEUL endian 转换。只是将输出 octet sequence 按顺序每两个 octet 一组，以 16bit big-endian WORD 进行 framing。
- Payload 不是 16 WORD，或任意截断结果的表示，均予以拒绝。没有 descriptor 和 padding。

## 标准依据 {#표준-근거}

- SHA3-256 算法与 256bit 结果遵循 NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final)。NIST 的 [Hash Functions 项目](https://csrc.nist.gov/Projects/hash-functions)也介绍了 SHA-3 标准。
- GEUL TAG、Length、16bit WORD framing 是此格式新增的规则，不属于 SHA-3 算法的一部分。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 16 WORD 之和，恰好 22 WORD，使用 `LLLL=1110`。没有 descriptor 和 padding。
- Payload 不是恰好 16 WORD 则拒绝。

## 示例 {#예시}

- 将 digest octet `d[0]` 至 `d[31]` 按输出顺序每两个 octet 一组放入 16 个 Payload WORD。总 Length 始终为 22 WORD。
