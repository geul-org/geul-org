---
title: "IEEE-DECIMAL64-BID"
weight: 1029
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID 是表示 IEEE 754 decimal64 BID interchange encoding 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID 是表示 IEEE 754 decimal64 BID interchange encoding 的 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x0000000D` IEEE，Codec 编号 `0x00002004`，系列 DECIMAL。原样保留 BID 比特模式，并与 DPD 相区分。

## 布局 {#레이아웃}

```
TAG WORD          0x09D8  总计 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 编号        2 WORD  0x00002004
Payload           4 WORD (64位)  IEEE decimal64 BID Interchange
```

## 解释 {#해석}

- 将四个 Payload WORD 从高位 WORD 起连接，读作 IEEE 754 decimal64 BID interchange 比特串。
- 保留比特模式，不任意重新解释为 DPD 或 exact decimal。
- 不对特殊值或 payload 做任意规范化。

## 有效性与长度 {#유효성과-길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 4 WORD 之和，恰好 9 WORD，使用直接长度 `LLLL=1000`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。
- 比特串在语义上的有效性遵循 IEEE BID interchange 规则。

## 示例 {#예시}

| 结构 | 判定 |
|---|---|
| `09D8 0000 000D 0000 2004` + 4 WORD BID 比特串 | 规范长度结构 |
| `09D8 0000 000D 0000 2004` + 2 WORD | invalid：Payload 宽度不符 |
| 相同 64 位使用 Codec 编号 `0x00002001` | 是 DPD 格式，不是此类型 |

## 标准依据 {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：应用 decimal64 interchange format 的二进制 coefficient encoding（BID）。不将其数值转换为 IEEE 允许的 DPD 替代方案，而是保留所选的 64 位 encoding，仅增加 GEUL TAG 与 WORD big-endian framing。
