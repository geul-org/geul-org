---
title: "IEEE-DECIMAL128-DPD"
weight: 1026
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD 是表示 IEEE 754 decimal128 DPD interchange encoding 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD 是表示 IEEE 754 decimal128 DPD interchange encoding 的 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x0000000D` IEEE，Codec 编号 `0x00002002`，系列 DECIMAL。原样保留 DPD 比特模式，并与 BID 相区分。

## 布局 {#레이아웃}

```
TAG WORD          0x09DC  总计 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 编号        2 WORD  0x00002002
Payload           8 WORD (128位)  IEEE decimal128 DPD Interchange
```

## 解释 {#해석}

- 将八个 Payload WORD 从高位 WORD 起连接，读作 IEEE 754 decimal128 DPD interchange 比特串。
- 保留比特模式，不任意重新解释为 BID 或 exact decimal。
- 不对特殊值或 payload 做任意规范化。

## 有效性与长度 {#유효성과-길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 8 WORD 之和，恰好 13 WORD，使用直接长度 `LLLL=1100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。
- 比特串在语义上的有效性遵循 IEEE DPD interchange 规则。

## 示例 {#예시}

| 结构 | 判定 |
|---|---|
| `09DC 0000 000D 0000 2002` + 8 WORD DPD 比特串 | 规范 |
| 总计不是 13 WORD（`LLLL=1100`） | invalid：与固定 Payload 宽度不符 |

## 标准依据 {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：应用 decimal128 interchange format 的十进制 coefficient encoding（DPD）。不将其数值转换为 IEEE 允许的 BID 替代方案，而是保留所选的 128 位 encoding，仅增加 GEUL TAG 与 WORD big-endian framing。
