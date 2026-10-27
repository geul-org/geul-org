---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE 是用 GEDCOM 7 日期值字符串，原样保留儒略历等其他历法日期的 Value（Codec 0x26/0x27）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE 是承载 [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html)（FamilySearch）日期值（`DateValue`）字符串的 Value。对于原件用非格里高利历（儒略历等）书写的日期，**按原样**保留。

## 布局

- 码：Value 直接码 `0x26`（偶数字节）·`0x27`（奇数字节）。系列 TIME。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。是 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](/zh/grammar/value/)）。

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = 奇数字节)
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          GEDCOM 日期字符串的 ASCII 字节 / 奇数则末尾为 0x00
```

## 解读与有效性

- 字节序列是遵循 GEDCOM 7 `DateValue` 语法的 ASCII 字符串。空字符串是 invalid。GEDCOM 允许空的 `DateValue`，但没有值时就不写记录。
- 语法要点：`[历法] [[日] 月] 年 [BCE]`。前面可加 `ABT`·`CAL`·`EST`（大约）、`BEF`·`AFT`·`BET … AND …`（范围）、`FROM … TO …`（期间）。分隔符是一个空格。
- 历法：`GREGORIAN`（省略则为默认）、`JULIAN`、`FRENCH_R`、`HEBREW`、扩展标签。月份名称按历法规定（儒略历与格里高利历相同，是 `JAN`…`DEC`）。
- 年份采用**历史纪年**。没有 0 年，公元前加 `BCE`（`44 BCE` = 公元前 44 年）。与 EDTF·GREGORIAN-DATE 的天文纪年相差一年。
- schema 只检查字节格式：ASCII `0x20`~`0x7E`、非空、首尾没有空格。语法和是否真实存在该日由生产者检查。例：`github.com/cacack/gedcom-go/v3`（MIT）的 `gedcom.ParseDate`。这个库的 `Validate` 只对格里高利历检查日期，会让 `JULIAN 30 FEB 1100` 通过，`ToGregorian` 不会真正转换年·月精度。日期是否真实存在的检查和规范化要另行处理。
- **使用位置：** 格里高利历日期用 [GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/) 或 [EDTF](/zh/grammar/value/time/edtf/) 书写。GEDCOM-DATE 用于必须保留原始写法的其他历法日期。

## 与规范化值一起使用

- 要在时间轴上比较·索引同一日期，需要格里高利历的值。日精度对应同一天的 GREGORIAN-DATE，年·月精度对应该期间的格里高利历区间 EDTF（`JULIAN 1300` → `1300-01-09/1301-01-08`），这才是准确的对应。
- 把原始写法（GEDCOM-DATE）和规范化值作为两个 Value 一起承载的方法尚未确定（未决问题）。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）和 Payload 之和的 WORD 数（[Length](/zh/grammar/record/)）。

## 示例

| 日期 | 字节 | 总计 WORD |
|---|---|---|
| `JULIAN 1300` | 11（奇数） | `0B27 4a55 4c49 414e 2031 3330 3000` |

## 标准依据

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date)、[Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars)。规范仓库的许可证是 Apache 2.0。GEUL 只参照格式，不转载规范正文。
- ISO 8601、EDTF、XSD、CLDR 历法标识符（`u-ca`）中没有儒略历。GEDCOM 7 是用一套语法处理历法前缀·公元前·精度·限定符的公开交换格式。

## 未决问题

- 同时使用原始写法与规范化值的方法（在一个 TRIPLE 中连接两者的方法）。
- schema 的 GEDCOM 语法检查。
- 世纪·十年精度。GEDCOM 中没有对应格式。Wikidata 中无法转换的日期，把原文以 UTF8-TEXT 保留。

## 相关页面

- [Value](/zh/grammar/value/)、[EDTF](/zh/grammar/value/time/edtf/)、[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/)
