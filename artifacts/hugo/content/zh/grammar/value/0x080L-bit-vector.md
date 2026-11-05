---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR 是标明长度的 raw bit sequence。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR 是标明长度的 raw bit sequence。Value 直接码 `0x080L`，系列 BINARY。前 2 个 Payload WORD 是 unsigned 32bit 的 bit count `N`，其后跟 `ceil(N/16)` 个 WORD。

| 项目 | 值 |
|---|---|
| 名称 | `BIT-VECTOR`（规格文档 BIND `BIT-VECTOR`） |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| 规格文档 | `0x00000000/codecs/0x00000800/`（DECLARE 对象 `0800`） |
| 章节 | 4 `0100`（Value），章节内偏移 C = 0 |
| Kind | Value · 系列：BINARY |
| TAG WORD | `0000 1000 0000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | bit-count 之后按 MSB-first 存储的 N bit |
| Hugo 路径 | `value/binary/bit-vector.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | 原始值 2 WORD |  |  |
| 2 | `bits` | #3 | 剩余原始值（`0xFFFF`） |  |  |

## 布局 {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st–2nd       Bit Count N (高 16bit │ 低 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## 解释与有效性 {#해석과-유효성}

- `N` 是将前 2 个 Payload WORD 按 big-endian unsigned 32bit 整数读取的值。
- payload bit 从每个 WORD 的最高位开始依次填充。
- payload WORD 数恰好为 `ceil(N/16)`，最后一个 WORD 中未使用的低位 bit 必须全为 0。
- `N=0` 时没有 payload WORD。两个 count WORD 已经构成 Payload，因此与 Payload 至少 1 WORD 的规则不冲突。

## 格式地位 {#형식-지위}

- unsigned 32bit bit count、MSB-first 排布、最后 WORD 的 zero padding 并非引用外部工业标准，而是 GEUL 特有的 framing。
- 包括 GEUL TAG、Length、16bit WORD 规则在内，由本页定义该表示。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG（如有）与 Payload 的 WORD 数之和。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](../record.md)）。

## 示例 {#예시}

- 空 bit vector 的 count 为 `0000 0000`，无 payload，总计 3 WORD，`LLLL=0010`。整体为 `0802 0000 0000`。
- bit sequence `101` 的 count 为 `0000 0003`，payload 为 `A000`，总计 4 WORD，`LLLL=0011`。整体为 `0803 0000 0003 A000`。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000800/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
