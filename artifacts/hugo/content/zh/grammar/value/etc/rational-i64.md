---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 是用 int64 分子和正 int64 分母的既约分数承载有理数的固定 11 WORD ADHOC Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 是用 big-endian int64 numerator 和 int64 denominator 的既约分数表示有理数的 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0702`，系列为 NUMERIC。

## 布局

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  总计 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## 解读与有效性

- 每个 int64 是从高位 WORD 起连接的固定宽度二进制补码整数，值为 `numerator / denominator`。
- 没有 ABI padding。
- Payload 恰好是 8 WORD，且 denominator 必须为正数。
- 只允许 `gcd(|numerator|, denominator) = 1` 的既约形式。0 只写成 `0/1`。

## 格式地位

- 两个 int64、正的 denominator、最大公约数 1、`0/1` canonicalization，不是采用外部 wire 标准，而是 GEUL 专有格式。
- 包括每个 int64 的二进制补码解读、分量顺序、big-endian WORD framing 在内，由本页完整定义表示。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 8 WORD 之和，恰好 11 WORD，使用直接长度 `LLLL=1010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例

- numerator `1`、denominator `2` 是有效的 `1/2`。`2/4`、`0/2`、denominator `-2` 是 invalid。
