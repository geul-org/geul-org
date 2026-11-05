---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 是以 (lower, upper) 顺序的 IEEE 754 binary64 两个 endpoint 表示闭区间的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 是以 `(lower, upper)` 顺序的 IEEE 754 binary64 两个 endpoint 表示闭区间的 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000703`，系列 NUMERIC。

## 布局 {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  总计 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## 解释与有效性 {#해석과-유효성}

- 两个 endpoint 是 big-endian WORD 顺序的 binary64，包含两端。
- 有效 endpoint 的 signed zero bit pattern 原样保留。没有 ABI padding。
- Payload 恰好是 8 WORD，且必须 `lower ≤ upper`。
- NaN 无法比较，所以拒绝。infinity endpoint 也属于 unbounded 区间，所以拒绝。
- empty、unbounded、open interval 与 NaI 无法用此格式表示，予以拒绝。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- endpoint 数值格式遵循 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)，闭 endpoint pair 的含义参考 [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) 及其 simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734) 的 interval 模型。
- 此格式是只允许有限且非空闭区间的简化 GEUL profile。不实现 decorations、NaI、empty/unbounded interval，也不实现或原样序列化 IEEE 1788/1788.1 的完整运算·interchange 模型。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 8 WORD 之和，恰好 13 WORD，使用直接长度 `LLLL=1100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例 {#예시}

- endpoint `(1.0, 2.0)` 是 `[1.0, 2.0]`，有效。`(2.0, 1.0)` 与 `(NaN, 1.0)` 为 invalid。
