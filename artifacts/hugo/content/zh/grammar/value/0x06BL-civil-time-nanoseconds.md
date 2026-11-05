---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS 以午夜之后的 nanosecond 数表示不含日期的民用时刻。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `CIVIL-TIME-NANOSECONDS`（规格文档 BIND `CIVIL-TIME-NANOSECONDS`） |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| 规格文档 | `0x00000000/codecs/0x000006B0/`（DECLARE 目标 `06B0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 11 |
| Kind | Value · 系列：TIME |
| TAG WORD | `0000 0110 1011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 民用日午夜之后的 unsigned nanosecond 计数 |
| Hugo 页面 | `value/time/civil-time-nanoseconds.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | 原始值 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS 以午夜之后的 nanosecond 数表示不含日期的民用时刻。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x06BL`。系列 TIME。
- 使用与 Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  总计 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 4 WORD 整体读作 big-endian WORD 顺序的 64 位二进制补码 signed count。
- 物理类型是 signed int64，但有效范围为 `0 <= value < 86,400×10^9` ns。负数和达到或超过上限的值予以拒绝。
- 不允许 `24:00` 和闰秒 label。也不承载日期、时区、UTC offset。
- 即使数值很小也始终使用 4 WORD。

## 长度 {#길이}

- 总计是 TAG 1 WORD 与 Payload 4 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例 {#예시}

- 午夜的 Payload 为 `0000 0000 0000 0000`，总计 5 WORD，`LLLL=0100`。
- 午夜之后 1 ns 的 Payload 为 `0000 0000 0000 0001`。
- `86,400×10^9` ns 等于上限，因此无效。
- `FFFF FFFF FFFF FFFF` 作为 signed int64 为 -1，因此无效。

## 标准依据 {#표준-근거}

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) 的 `TIME(isAdjustedToUTC=false, unit=NANOS)` 将 local time 午夜之后的 nanosecond 存入 `int64`，使用 signed 顺序。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 的权威 [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 将 NANOSECOND Time 定义为 64 位 signed integer，把有效范围限制在含午夜、不足 86,400 秒，且不允许闰秒。GEUL 只加上 TAG 和 big-endian 16 位 WORD framing。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000006B0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
