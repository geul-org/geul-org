---
title: "IEEE-DECIMAL32-DPD"
weight: 1028
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD 是表示 IEEE 754 decimal32 DPD interchange encoding 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD 是表示 IEEE 754 decimal32 DPD interchange encoding 的 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x0000000D` IEEE，Codec 编号 `0x00002000`，系列 DECIMAL。原样保留 DPD 比特模式，并与 BID 相区分。

## 布局 {#레이아웃}

```
TAG WORD          0x09D6  总计 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 编号        2 WORD  0x00002000
Payload           2 WORD (32位)  IEEE decimal32 DPD Interchange
```

## 解释 {#해석}

- 将两个 Payload WORD 从高位 WORD 起连接，读作 IEEE 754 decimal32 DPD interchange 比特串。
- 保留比特模式，不任意重新解释为 BID 或 SIGNED-DECIMAL。
- 不对特殊值或 payload 做任意规范化。

## 有效性与长度 {#유효성과-길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 2 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。
- 比特串在语义上的有效性遵循 IEEE DPD interchange 规则。

## 示例 {#예시}

| 结构 | 判定 |
|---|---|
| `09D6 0000 000D 0000 2000` + 2 WORD DPD 比特串 | 规范长度结构 |
| `09D6 0000 000D 0000 2000` + 4 WORD | invalid：Payload 宽度不符 |
| 相同 32 位使用 Codec 编号 `0x00002003` | 是 BID 格式，不是此类型 |

## 标准依据 {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：应用 decimal32 interchange format 的十进制 coefficient encoding（DPD）。不将其数值转换为 IEEE 允许的 BID 替代方案，而是保留所选的 32 位 encoding，仅增加 GEUL TAG 与 WORD big-endian framing。
