---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER 是表示有符号整数值的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SIGNED-INTEGER`（规格文档 BIND `SIGNED-INTEGER`） |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| 规格文档 | `0x00000000/codecs/0x00000610/`（DECLARE 目标 `0610`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 1 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 最小 WORD 的二进制补码有符号整数 |
| Hugo 页面 | `value/numeric/signed-integer.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | 剩余原始值（`0xFFFF`） |  |  |

SIGNED-INTEGER 是表示有符号整数值的 Value。Value 直接码 `0x061L`，系列为 NUMERIC。Payload 整体按 big-endian WORD 顺序读作任意精度的二进制补码整数。Payload 至少 1 WORD，且只允许最小 WORD 的规范表示。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st  (高位 WORD)   Integer 1st
...
Payload WORD Nth  (低位 WORD)   Integer Nth
```

## 解释 {#해석}

- 第一个 Payload WORD 的最高位是整个整数的符号位。
- 所有 Payload WORD 读作一个连续的二进制补码位串。第一个 WORD 为最高位，最后一个 WORD 为最低位。
- Payload 为 N WORD 时，解释宽度为 `16N` bit。该宽度不是声明的存储宽度，而是由规范表示确定的值的表示宽度。
- 没有 Byte Count 或 bit width descriptor。

## 规范表示 {#정규-표현}

- 0 是 Payload 1 WORD `0000`。
- 禁止不改变值的前导符号扩展 WORD。
- Payload 为 2 WORD 以上时，以下情形为非规范。
  - 第一个 WORD 为 `0000`，且下一个 WORD 的最高位为 0
  - 第一个 WORD 为 `FFFF`，且下一个 WORD 的最高位为 1
- 保持正数符号的前导 `0000`，在下一个 WORD 的最高位为 1 时允许。
- 保持负数符号的前导 `FFFF`，在下一个 WORD 的最高位为 0 时允许。
- 解码器必须拒绝非规范表示。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（若有）与 Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](../record.md)）。
- 不保留 INT8·INT16·INT32 之类的声明宽度，只保留数值。`-32768`~`32767` 为 1 WORD，超出范围则按需增加 WORD。没有单独的 SIGNED-INT8 格式。

## 示例 {#예시}

| 值 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 规范 |
| 1 | `0001` | 规范 |
| 32767 | `7FFF` | 规范 |
| 32768 | `0000 8000` | 规范：保持正数符号需要 `0000` |
| -1 | `FFFF` | 规范 |
| -32768 | `8000` | 规范 |
| -32769 | `FFFF 7FFF` | 规范：保持负数符号需要 `FFFF` |
| 1 | `0000 0001` | 非规范：多余的前导 `0000` |
| -1 | `FFFF FFFF` | 非规范：多余的前导 `FFFF` |

## 格式地位 {#형식-지위}

- 二进制补码是广泛使用的惯例，但把任意精度值规范化为最小 16 位 WORD 序列并与 GEUL TAG 绑定的这种表示，是 GEUL 专有的 scalar profile。
- 与 INT8/16/32/64 之类的固定宽度外部类型互换时，需要范围检查和显式的宽度转换。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000610/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
