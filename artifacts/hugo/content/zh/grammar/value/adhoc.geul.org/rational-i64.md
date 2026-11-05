---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 是以 big-endian int64 numerator 与 int64 denominator 的既约分数表示有理数的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 是以 big-endian int64 numerator 与 int64 denominator 的既约分数表示有理数的 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000702`，系列 NUMERIC。

## 布局 {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  总计 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## 解释与有效性 {#해석과-유효성}

- 每个 int64 是从高位 WORD 起依次连接的定宽二进制补码整数，值为 `numerator / denominator`。
- 没有 ABI padding。
- Payload 恰好是 8 WORD，denominator 必须为正。
- 只允许 `gcd(|numerator|, denominator) = 1` 的既约形式。0 只能写作 `0/1`。

## 形式地位 {#형식-지위}

- 两个 int64、正的 denominator、最大公约数 1、`0/1` canonicalization 并非采用外部 wire 标准，而是 GEUL 特有的格式。
- 包括每个 int64 的二进制补码解释、分量顺序、big-endian WORD framing 在内，本页完整定义了该表示。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 8 WORD 之和，恰好 13 WORD，使用直接长度 `LLLL=1100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例 {#예시}

- numerator `1`、denominator `2` 是有效的 `1/2`。`2/4`、`0/2`、denominator `-2` 为 invalid。
