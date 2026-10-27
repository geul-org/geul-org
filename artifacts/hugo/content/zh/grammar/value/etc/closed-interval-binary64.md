---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 是用 binary64 下限·上限承载有限且非空闭区间的固定 11 WORD ADHOC Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 是用 `(lower, upper)` 顺序的两个 IEEE 754 binary64 endpoint 表示闭区间的 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0703`，系列为 NUMERIC。

## 布局

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  总计 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## 解读与有效性

- 两个 endpoint 是 big-endian WORD 顺序的 binary64，包含两端。
- 有效 endpoint 的 signed zero bit pattern 原样保留。没有 ABI padding。
- Payload 恰好是 8 WORD，且必须 `lower ≤ upper`。
- NaN 无法比较，所以拒绝。infinity endpoint 是无界区间，所以也拒绝。
- empty、unbounded、open interval 以及 NaI 无法用本格式表示，予以拒绝。

## 标准依据与格式地位

- endpoint 的数值格式遵循 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)，闭 endpoint pair 的含义参考 [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) 及其 simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734) 的 interval 模型。
- 本格式是只允许有限且非空闭区间的简单 GEUL profile。不实现也不原样序列化 decorations、NaI、empty/unbounded interval，以及 IEEE 1788/1788.1 的完整运算·interchange 模型。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 8 WORD 之和，恰好 11 WORD，使用直接长度 `LLLL=1010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例

- endpoint `(1.0, 2.0)` 是 `[1.0, 2.0]`，有效。`(2.0, 1.0)` 和 `(NaN, 1.0)` 是 invalid。
