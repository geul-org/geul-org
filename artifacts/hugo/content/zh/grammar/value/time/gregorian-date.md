---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE 是以 proleptic Gregorian 1970-01-01 为 day 0 的 signed int32 天数 Value（Codec 0x20）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE 是以 proleptic Gregorian `1970-01-01` 为 day 0 的 signed 天数。不承载时区和一天中的时刻。

## 布局

- 码：Value 直接码 `0x20`。系列 TIME。
- 使用与 Arrow Date32、Parquet `DATE` 相同的固定宽度 signed int32 物理类型。

```
TAG WORD          0x0920 (0000 1001 0010 0000)  总计 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## 解读与有效性

- 把整个 Payload 2 WORD 读作 big-endian WORD 顺序的 32 位二进制补码 signed day count。
- 有效范围是 `-2^31`~`2^31-1` 天。负数是 epoch 之前的日期。
- 由 day count 反推年·月·日时，不考虑历史上的历法转换，使用 proleptic Gregorian calendar。
- 即使是很小的值也始终使用 2 WORD。

## 长度

- 总计是 TAG 1 WORD 与 Payload 2 WORD 之和，恰好 3 WORD，使用直接长度 `LLLL=0010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例

| 日期 | Payload | 总 Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD（`LLLL=0010`） |
| `1970-01-02` | `0000 0001` | 3 WORD（`LLLL=0010`） |
| `1969-12-31` | `ffff ffff` | 3 WORD（`LLLL=0010`） |

## 与 EDTF 的关系

- 比"日"更粗的精度、不确定·大约、区间用 [EDTF](/zh/grammar/value/time/edtf/) 书写。能用 GREGORIAN-DATE 精确表示的日期，不用 EDTF 书写（EDTF 规范形式）。

## 标准依据

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) 的 `DATE` 是存放自 Unix epoch 1970-01-01 起的天数的 `int32`，使用 signed 顺序。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 和 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 的 Date32 把自 Unix epoch 起的天数存放为 32 位 signed integer。
- 按 proleptic Gregorian 反推是本格式采用的 GEUL calendar profile。Arrow/Parquet 的 int32 day-count 含义保持不变，只增加 TAG 和 big-endian 16 位 WORD 分帧。
