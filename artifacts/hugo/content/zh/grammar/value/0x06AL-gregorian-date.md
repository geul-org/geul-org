---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE 是以 proleptic Gregorian 1970-01-01 为 day 0 的 signed 日期数。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `GREGORIAN-DATE`（规格文档 BIND `GREGORIAN-DATE`） |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| 规格文档 | `0x00000000/codecs/0x000006A0/`（DECLARE 目标 `06A0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 10 |
| Kind | Value · 系列：TIME |
| TAG WORD | `0000 0110 1010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 以 proleptic Gregorian `1970-01-01` 为基准的 signed 日期数 |
| Hugo 页面 | `value/time/gregorian-date.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | 原始值 2 WORD |  |  |

GREGORIAN-DATE 是以 proleptic Gregorian `1970-01-01` 为 day 0 的 signed 日期数。不承载时区和一天中的时刻。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x06AL`。系列 TIME。
- 使用与 Arrow Date32、Parquet `DATE` 相同的固定宽度 signed int32 物理类型。

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  总计 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 2 WORD 整体读作 big-endian WORD 顺序的 32 位二进制补码 signed day count。
- 有效范围为 `-2^31`~`2^31-1` 日。负数是 epoch 之前的日期。
- 将 day count 反推为年·月·日时，使用 proleptic Gregorian calendar，不含历史上的历法转换。
- 即使数值很小也始终使用 2 WORD。

## 长度 {#길이}

- 总计是 TAG 1 WORD 与 Payload 2 WORD 之和，恰好 3 WORD，使用直接长度 `LLLL=0010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例 {#예시}

| 日期 | Payload | 总计 Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD（`LLLL=0010`） |
| `1970-01-02` | `0000 0001` | 3 WORD（`LLLL=0010`） |
| `1969-12-31` | `FFFF FFFF` | 3 WORD（`LLLL=0010`） |

## 与 EDTF 的关系 {#edtf와의-관계}

- 比日更粗的精度、不确定·近似、区间使用 [EDTF](0x06EL-edtf.md) 书写。可用 GREGORIAN-DATE 精确书写的日期不用 EDTF 书写（EDTF 规范形式）。

## 标准依据 {#표준-근거}

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) 的 `DATE` 是存储自 Unix epoch 1970-01-01 起日数的 `int32`，使用 signed 顺序。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 与权威的 [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 中的 Date32，将自 Unix epoch 起的日数存为 32 位 signed integer。
- proleptic Gregorian 反推是本格式采用的 GEUL calendar profile。Arrow/Parquet 的 int32 day-count 含义保持不变，只加上 TAG 和 big-endian 16 位 WORD framing。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000006A0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
