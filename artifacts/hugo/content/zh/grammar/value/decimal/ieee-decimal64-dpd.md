---
title: "IEEE-DECIMAL64-DPD"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-DPD 是原样承载 IEEE 754 decimal64 DPD interchange 位串的固定 7 WORD Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-DPD 是表示 IEEE 754 decimal64 DPD interchange encoding 的 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0040` IEEE，格式编号 `0x2001`，系列为 DECIMAL。原样保留 DPD 位模式，并与 BID 区分。

## 布局

```
TAG WORD          0x0B7C  总计 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
格式编号          1 WORD  0x2001
Payload           4 WORD (64位)  IEEE decimal64 DPD Interchange
```

## 解读

- 把四个 Payload WORD 从高位 WORD 起连接，读作 IEEE 754 decimal64 DPD interchange 位串。
- 保留位模式，不随意重新解读为 BID 或精确十进制格式。
- 不随意规范化特殊值或 payload。

## 有效性与长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 4 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。
- 位串在语义上的有效性遵循 IEEE DPD interchange 规则。

## 示例

| 结构 | 判定 |
|---|---|
| `0B7C 0040 2001` + 4 WORD DPD 位串 | 规范长度结构 |
| `0B7C 0040 2001` + 2 WORD | invalid：Payload 宽度不符 |
| 同样的 64 位使用格式编号 `0x2004` | 是 BID 格式，不是此类型 |

## 标准依据

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：采用 decimal64 interchange format 的十进制 coefficient 编码(DPD)。不把它数值转换为 IEEE 允许的 BID 替代方式，而是保留所选的 64 位 encoding，GEUL 只增加 TAG 和 WORD big-endian 分帧。
