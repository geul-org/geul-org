---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS 是以午夜之后的 nanosecond 数承载不带日期的民用时刻的 Value（Codec 0x21）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS 用午夜之后的 nanosecond 数表示不带日期的民用时刻。

## 布局

- 码：Value 直接码 `0x21`。系列 TIME。
- 使用与 Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  总计 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解读与有效性

- 把整个 Payload 4 WORD 读作 big-endian WORD 顺序的 64 位二进制补码 signed 计数。
- 物理类型是 signed int64，但有效范围是 `0 <= value < 86,400×10^9`ns。负数和达到上限以上则拒绝。
- 不允许 `24:00` 和闰秒 label。也不承载日期、时区、UTC offset。
- 即使是很小的值也始终使用 4 WORD。

## 长度

- 总计是 TAG 1 WORD 与 Payload 4 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- 午夜是 Payload `0000 0000 0000 0000`，总计 5 WORD，`LLLL=0100`。
- 午夜之后 1ns 是 Payload `0000 0000 0000 0001`。
- `86,400×10^9`ns 等于上限，所以无效。
- `ffff ffff ffff ffff` 作为 signed int64 是 -1，所以无效。

## 标准依据

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) 的 `TIME(isAdjustedToUTC=false, unit=NANOS)` 把 local time 的午夜之后的 nanosecond 存放在 `int64` 中，并使用 signed 顺序。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 的 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 把 NANOSECOND Time 定义为 64 位 signed integer，并把有效范围限制在包含午夜、不足 86,400 秒，不允许闰秒。GEUL 只增加 TAG 和 big-endian 16 位 WORD 分帧。
