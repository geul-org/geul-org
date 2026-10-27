---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR 是在 32bit 位数 N 之后，以 MSB-first 承载 N bit 的 GEUL Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR 是写明长度的 raw bit sequence。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0000` GEUL，格式编号 `0xC002`，系列为 BINARY。前 2 个 Payload WORD 是 unsigned 32bit bit count `N`，其后是 `ceil(N/16)` WORD。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0000 (GEUL)
格式编号          1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (高 16bit │ 低 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## 解读与有效性

- `N` 是把前 2 个 Payload WORD 读作 big-endian unsigned 32bit 整数得到的值。
- payload bit 从每个 WORD 的最高位开始依次填充。
- payload WORD 数恰好是 `ceil(N/16)`，最后一个 WORD 中未使用的低位 bit 必须全为 0。
- `N=0` 时没有 payload WORD。两个 count WORD 已经构成 Payload，所以与 Payload 最少 1 WORD 的规则并不冲突。

## 格式地位

- unsigned 32bit bit count、MSB-first 排列、最后一个 WORD 的 zero padding 不是引用外部产业标准，而是 GEUL 专有 framing。
- 包括 GEUL TAG、Length、16bit WORD 规则在内，由本页定义表示。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD、Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](/zh/grammar/record/)）。

## 示例

- 空 bit vector 是 count `0000 0000`，没有 payload，总计 5 WORD，`LLLL=0100`。
- bit sequence `101` 是 count `0000 0003`，payload `a000`，总计 6 WORD，`LLLL=0101`。
