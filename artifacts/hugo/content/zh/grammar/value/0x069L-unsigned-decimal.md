---
title: "UNSIGNED-DECIMAL (0x069L)"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL 是带有无符号 coefficient 的精确十进制数（exact decimal）Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `UNSIGNED-DECIMAL`（规格文档 BIND `UNSIGNED-DECIMAL`） |
| TAG ID | `0x069L` |
| Codec ID | `0x00000690` |
| 规格文档 | `0x00000000/codecs/0x00000690/`（DECLARE 目标 `0690`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 9 |
| Kind | Value · 系列：DECIMAL |
| TAG WORD | `0000 0110 1001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | signed exponent `E` 与最小 WORD unsigned coefficient `C` 的 `C×10^E` |
| Hugo 页面 | `value/decimal/unsigned-decimal.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | 原始值 2 WORD |  |  |
| 2 | `coefficient` | #3 | 剩余原始值（`0xFFFF`） |  |  |

UNSIGNED-DECIMAL 是带有无符号 coefficient 的精确十进制数（exact decimal）Value。Value 直接码 `0x069L`，系列为 DECIMAL。Payload 的前 2 WORD 是 signed 32bit 十进制 exponent `E`，其余是最小 WORD unsigned coefficient `C`，值为 `C×10^E`。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 1001 LLLL      Codec 0x069L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st–2nd (32 位)        Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD 以上)  Unsigned Coefficient C
```

## 解释 {#해석}

- `E` 是自高位 WORD 起记录的 signed 32bit big-endian 二进制补码整数。
- `C` 是将其余全部 WORD 自高位 WORD 起读取的任意精度 unsigned magnitude。
- `C` 遵循与 [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) 相同的最小 WORD 规则。0 是 `0000`，2 WORD 以上时禁止第一个 WORD 为 `0000`。

## 长度与有效性 {#길이와-유효성}

- 总计是 TAG 1 WORD、Length 扩展 TAG（若有）与 Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](../record.md)）。
- Payload 由 exponent 2 WORD 与 coefficient 1 WORD 以上组成，因此最少 3 WORD。
- 字节表示的规范性只检查 coefficient 的最小 WORD 表示。

## 示例 {#예시}

| 值表示 | Payload（`E` + `C`） | 判定 |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | 字节表示规范 |
| `10×10^-1` | `FFFF FFFF 000A` | 字节表示规范，与上一表示之间的 canonical 关系为未决问题 |
| `1×10^0` | `0000 0000 0000 0001` | 非规范：coefficient 前导 `0000` 不必要 |
| 负的 coefficient | 不适用 | invalid |

## 格式地位 {#형식-지위}

- 把 signed 32 位 exponent `E` 与 unsigned 最小 WORD coefficient `C` 绑定的这种排布，是 GEUL 专有格式，既不是 IEEE 754 decimal interchange，也不是 Apache Parquet `DECIMAL`。
- Parquet `DECIMAL` 使用 signed unscaled value、`unscaledValue × 10^(-scale)` 和必需的 precision/scale metadata，byte-array 物理类型为 big-endian 二进制补码，scale 为 0 以上。本格式因为 `C` 是 unsigned、`E` 是 signed、且没有 precision metadata，所以不是同一种格式。
- 与 IEEE 754 decimal 或 Parquet `DECIMAL` 互换时，需要规定符号、范围、precision/scale、quantum、特殊值策略的显式转换。
- 比较依据：[IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/)、[Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## 未决问题 {#열린-문제}

- 像 `10×10^-1` 与 `1×10^0` 这样，表示同一个数的 exponent/coefficient 对有多个。
- 本格式是否保留 quantum、如何判定值相等、如何规范化 canonical exponent，目前尚未规定。
- 因此实现不得在 coefficient 最小 WORD 规则之外，任意强制 exponent/coefficient 的规范化。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000690/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000069000000000
BODY
#1 DECLARE 0x0690
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "UNSIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
