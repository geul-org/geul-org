---
title: "UNSIGNED-DECIMAL"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL 是用 signed 32 位指数 E 和最小 WORD 无符号系数 C 承载精确十进制数 C×10^E 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-DECIMAL 是带有无符号 coefficient 的精确十进制数（exact decimal）Value。Value 直接码 `0x11`，系列为 DECIMAL。Payload 的前 2 WORD 是 signed 32bit 十进制 exponent `E`，其余是最小 WORD unsigned coefficient `C`，值为 `C×10^E`。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x11
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st–2nd (32位)         Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD 以上)  Unsigned Coefficient C
```

## 解读

- `E` 是从高位 WORD 起记录的 signed 32bit big-endian 二进制补码整数。
- `C` 是把其余所有 WORD 从高位 WORD 起读取的任意精度 unsigned magnitude。
- `C` 遵循与 [UNSIGNED-INTEGER](/zh/grammar/value/numeric/unsigned-integer/) 相同的最小 WORD 规则。0 是 `0000`，2 WORD 以上时禁止第一个 WORD 为 `0000`。

## 长度与有效性

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](/zh/grammar/record/)）。
- Payload 是 exponent 2 WORD 加 coefficient 1 WORD 以上，所以最少 3 WORD。
- 字节表示的规范性只检查 coefficient 的最小 WORD 表示。

## 示例

| 值表示 | Payload（`E` + `C`） | 判定 |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | 字节表示规范 |
| `10×10^-1` | `ffff ffff 000a` | 字节表示规范，与上面表示的 canonical 关系是未决问题 |
| `1×10^0` | `0000 0000 0000 0001` | 非规范：coefficient 前导 `0000` 不必要 |
| 负 coefficient | 不适用 | invalid |

## 格式地位

- 把 signed 32 位 exponent `E` 和 unsigned 最小 WORD coefficient `C` 绑定的这种布局，不是 IEEE 754 decimal interchange 或 Apache Parquet `DECIMAL`，而是 GEUL 专有格式。
- Parquet `DECIMAL` 使用 signed unscaled value、`unscaledValue × 10^(-scale)` 和必需的 precision/scale metadata，byte-array 物理类型是 big-endian 二进制补码，且 scale 为 0 以上。本格式因为 `C` 是 unsigned、`E` 是 signed、且没有 precision metadata，所以不是同一种格式。
- 与 IEEE 754 decimal 或 Parquet `DECIMAL` 交换，需要明确规定符号、范围、precision/scale、quantum、特殊值策略的显式转换。
- 比较依据：[IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/)、[Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## 未决问题

- 像 `10×10^-1` 与 `1×10^0` 这样，表示同一个数的 exponent/coefficient 对有多个。
- 本格式是否保留 quantum、如何判定值等价、如何规范化 canonical exponent，尚未确定。
- 因此实现不得在 coefficient 最小 WORD 规则之外，随意强制 exponent/coefficient 规范化。
