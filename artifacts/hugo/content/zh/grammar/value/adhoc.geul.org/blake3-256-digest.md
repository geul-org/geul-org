---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST 是承载 BLAKE3 default hash mode 输出前 32 octet（256 bit）的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST 是承载 BLAKE3 default hash mode 输出前 32 octet（256 bit）的定宽 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x0000C000`，系列 BINARY。Payload 恰好是 16 WORD，不承载 keyed hash mode、key derivation mode 以及其他长度的 XOF 输出。

## 布局 {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 扩展 TAG   1 WORD  0x0016 (总计 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## 解释与有效性 {#해석과-유효성}

- Payload 是 BLAKE3 default hash mode output stream 的前 32 octet。保留输出顺序，每个 WORD 中高位 octet 在前。
- 不对输出另行应用 GEUL endian 转换。将输出 octet sequence 按顺序每两个 octet 一组，以 16bit big-endian WORD 进行 framing。
- Payload 不是 16 WORD，或承载 keyed_hash、derive_key、其他长度 XOF 结果的表示，均予以拒绝。没有 descriptor 和 padding。

## 标准依据 {#표준-근거}

- 算法与 mode·output 的定义遵循 BLAKE3 团队的[官方实现仓库](https://github.com/BLAKE3-team/BLAKE3)和 [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf)。
- GEUL TAG、Length、16bit WORD framing 是此格式新增的规则，不属于 BLAKE3 算法的一部分。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 16 WORD 之和，恰好 22 WORD，使用 `LLLL=1110`。没有 descriptor 和 padding。
- Payload 不是恰好 16 WORD 则拒绝。

## 示例 {#예시}

- 将 output octet `d[0]` 至 `d[31]` 按输出顺序每两个 octet 一组放入 16 个 Payload WORD。总 Length 始终为 22 WORD。
