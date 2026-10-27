---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST 是承载 BLAKE3 默认 hash mode 输出前 32 octet 的固定 20 WORD Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST 是承载 BLAKE3 default hash mode 输出前 32 octet（256 bit）的固定宽度 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0xC000`，系列为 BINARY。Payload 恰好是 16 WORD，不承载 keyed hash mode、key derivation mode 以及其他长度的 XOF 输出。

## 布局

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 扩展 TAG   1 WORD  0x0014 (总计 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## 解读与有效性

- Payload 是 BLAKE3 default hash mode output stream 的前 32 octet。保留输出顺序，每个 WORD 中高 octet 在前。
- 不对输出另行应用 GEUL 的 endian 转换。把输出 octet sequence 按顺序每两个 octet 一组，分帧为 16bit big-endian WORD。
- Payload 不是 16 WORD，或承载了 keyed_hash、derive_key、其他长度 XOF 结果的表示，予以拒绝。没有 descriptor 和 padding。

## 标准依据

- 算法和 mode·output 定义遵循 BLAKE3 团队的[官方实现仓库](https://github.com/BLAKE3-team/BLAKE3)和 [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf)。
- GEUL TAG、Length、16bit WORD framing 是本格式增加的规则，不是 BLAKE3 算法的一部分。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 16 WORD 之和，恰好 20 WORD，使用 `LLLL=1110`。没有 descriptor 和 padding。
- Payload 不是恰好 16 WORD 则拒绝。

## 示例

- 把 output octet `d[0]` 到 `d[31]` 按输出顺序每两个 octet 放入 16 个 Payload WORD。总 Length 始终是 20 WORD。
