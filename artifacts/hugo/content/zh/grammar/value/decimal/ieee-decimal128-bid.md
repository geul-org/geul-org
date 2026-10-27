---
title: "IEEE-DECIMAL128-BID"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID 是原样承载 IEEE 754 decimal128 BID interchange 位串的固定 11 WORD Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID 是表示 IEEE 754 decimal128 BID interchange encoding 的 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0040` IEEE，格式编号 `0x2005`，系列为 DECIMAL。原样保留 BID 位模式，并与 DPD 区分。

## 布局

```
TAG WORD          0x0D7C  总计 11 WORD
Issuer            1 WORD  0x0040 (IEEE)
格式编号          1 WORD  0x2005
Payload           8 WORD (128位)  IEEE decimal128 BID Interchange
```

## 解读

- 把八个 Payload WORD 从高位 WORD 起连接，读作 IEEE 754 decimal128 BID interchange 位串。
- 保留位模式，不随意重新解读为 DPD 或精确十进制格式。
- 不随意规范化特殊值或 payload。

## 有效性与长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 8 WORD 之和，恰好 11 WORD，使用直接长度 `LLLL=1010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。
- 位串在语义上的有效性遵循 IEEE BID interchange 规则。

## 示例

| 结构 | 判定 |
|---|---|
| `0D7C 0040 2005` + 8 WORD BID 位串 | 规范 |
| 总计不是 11 WORD（`LLLL=1010`） | invalid：与固定 Payload 宽度不符 |

## 标准依据

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：采用 decimal128 interchange format 的二进制 coefficient 编码(BID)。不把它数值转换为 IEEE 允许的 DPD 替代方式，而是保留所选的 128 位 encoding，GEUL 只增加 TAG 和 WORD big-endian 分帧。
