---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD 是原样承载 IEEE 754 decimal32 DPD interchange 位串的固定 5 WORD Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD 是表示 IEEE 754 decimal32 DPD interchange encoding 的 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0040` IEEE，格式编号 `0x2000`，系列为 DECIMAL。原样保留 DPD 位模式，并与 BID 区分。

## 布局

```
TAG WORD          0x0A7C  总计 5 WORD
Issuer            1 WORD  0x0040 (IEEE)
格式编号          1 WORD  0x2000
Payload           2 WORD (32位)  IEEE decimal32 DPD Interchange
```

## 解读

- 把两个 Payload WORD 从高位 WORD 起连接，读作 IEEE 754 decimal32 DPD interchange 位串。
- 保留位模式，不随意重新解读为 BID 或 SIGNED-DECIMAL。
- 不随意规范化特殊值或 payload。

## 有效性与长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 2 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。
- 位串在语义上的有效性遵循 IEEE DPD interchange 规则。

## 示例

| 结构 | 判定 |
|---|---|
| `0A7C 0040 2000` + 2 WORD DPD 位串 | 规范长度结构 |
| `0A7C 0040 2000` + 4 WORD | invalid：Payload 宽度不符 |
| 同样的 32 位使用格式编号 `0x2003` | 是 BID 格式，不是此类型 |

## 标准依据

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：采用 decimal32 interchange format 的十进制 coefficient 编码(DPD)。不把它数值转换为 IEEE 允许的 BID 替代方式，而是保留所选的 32 位 encoding，GEUL 只增加 TAG 和 WORD big-endian 分帧。
