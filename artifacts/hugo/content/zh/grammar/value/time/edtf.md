---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF 是用 ISO 8601-2 扩展日期字符串承载年·月精度、公元前、不确定、区间等日期的 Value（Codec 0x24/0x25）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF 是用 [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html)（美国国会图书馆，ISO 8601-2:2019）字符串承载日期的 Value。表示比"日"更粗的精度、公元前、不确定·大约·部分未知、区间。

## 布局

- 码：Value 直接码 `0x24`（偶数字节）·`0x25`（奇数字节）。系列 TIME。Payload 虽然是字符串，但放在 TIME 系列中，使解码器和索引即使不知道格式也把它当作时间值处理。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。是 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](/zh/grammar/value/)）。

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = 奇数字节)
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          EDTF 字符串的 ASCII 字节 / 奇数则末尾为 0x00
```

## 解读与有效性

- 字节序列是遵循 EDTF Level 0·1·2 语法的 ASCII 字符串。空字符串是 invalid。
- 例：日 `1952-03-11`、月 `1952-03`、年 `1952`、十年 `195X`、公元前 44 年 `-0043`、不确定 `1974?`、大约 `~1974`、区间 `1952/2001`、大年份 `Y-13799999999`。
- 年份采用 ISO 8601 天文纪年。`0000` 是公元前 1 年，`-0043` 是公元前 44 年。从历史纪年写法转换时要移动一年。
- 是格里高利历。EDTF 不处理其他历法。儒略历等其他历法的原始写法用 [GEDCOM-DATE](/zh/grammar/value/time/gedcom-date/) 保留。把该日期换算成格里高利历的同一天·同一期间的值，可以用 EDTF 或 GREGORIAN-DATE 书写。
- **规范形式：** 能用 [GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/) 精确表示的日期，即没有限定符（`?`、`~`、`%`）·未知位数（`X`）·区间·`Y` 前缀的 `[-]YYYY-MM-DD`，要用 GREGORIAN-DATE 书写。把这样的日期写成 EDTF 则 invalid。同一天只有一种写法，才能作为时间进行索引·比较。
- schema 目前还不检查 EDTF 语法。由生产者用 EDTF 解析器检查。例：`github.com/sfomuseum/go-edtf`（BSD-3-Clause）的 `parser.ParseString`。`parser.IsValid` 只看语法，会让 `2023-02-29`、`1974-13` 也通过，所以不使用。这个解析器目前还不支持 `Y` 前缀年份。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）和 Payload 之和的 WORD 数（[Length](/zh/grammar/record/)）。

## 示例

| 日期 | 字节 | 总计 WORD |
|---|---|---|
| `1974` | 4（偶数） | `0924 3139 3734` |
| `197X` | 4（偶数） | `0924 3139 3758` |
| `1952-03` | 7（奇数） | `0A25 3139 3532 2d30 3300` |

## 标准依据

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html)。Level 0 是 ISO 8601-1 的子集，Level 1·2 是 ISO 8601-2 的功能。
- 在 RDF 中，用数据类型 `http://id.loc.gov/datatypes/edtf` 标示同样的字符串。

## 未决问题

- 检查器的 EDTF 语法检查（检查器是否依赖外部库）。
- 把 Wikidata 的世纪·千年精度转换为 EDTF 未知位数的规则。

## 相关页面

- [Value](/zh/grammar/value/)、[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/)、[GEDCOM-DATE](/zh/grammar/value/time/gedcom-date/)
