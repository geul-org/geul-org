---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE 是 GEDCOM 7 日期值字符串，按书写原样保存儒略历等其他历法的日期的 Value（Codec 0x070L/0x071L）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE 是 GEDCOM 7 日期值字符串，按书写原样保存儒略历等其他历法的日期的 Value（Codec 0x070L/0x071L）。

| 项目 | 值 |
|---|---|
| 名称 | `GEDCOM-DATE`（奇偶分组。各代码的名称见下方成员表） |
| TAG ID | `0x070L`·`0x071L` |
| 章节 | 3 `0011`（Value），章节内偏移 C = 16~17 |
| Kind | Value · 系列：TIME |
| 索引说明 | GEDCOM 7 日期值字符串。保存其他历法（儒略历等）的原始写法。偶数·奇数字节 |
| Hugo 路径 | `value/time/gedcom-date.md` |

## 成员 {#구성원}

本页同时处理奇偶一对的两个代码。偶数代码的值字节数为偶数，奇数代码的值字节数为奇数（[记录与 TAG WORD](../record.md#가변-길이-바이트열)）。Codec 文档每个代码一份。两份 Codec 文档的字段相同，只有 DECLARE 对象和名称（BIND）不同。

| TAG ID | 名称 | 字节数 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | 偶数 | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | 奇数 | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 剩余原始值（`0xFFFF`） |  |  |

GEDCOM-DATE 是承载 [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html)（FamilySearch）日期值（`DateValue`）字符串的 Value。对于原文以非格里高利历的历法（儒略历等）书写的日期，**按书写原样**保存。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x070L`（偶数字节）·`0x071L`（奇数字节）。系列 TIME。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。即 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](_index.md)）。

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = 奇数字节)
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          GEDCOM 日期字符串的 ASCII 字节 / 奇数时最后为 0x00
```

## 解释与有效性 {#해석과-유효성}

- 字节序列是遵循 GEDCOM 7 `DateValue` 语法的 ASCII 字符串。空字符串为 invalid。GEDCOM 允许空的 `DateValue`，但没有值时不写记录。
- 语法要点：`[历法] [[日] 月] 年 [BCE]`。前面可加 `ABT`·`CAL`·`EST`（大约）、`BEF`·`AFT`·`BET … AND …`（范围）、`FROM … TO …`（期间）。分隔符为一个空格。
- 历法：`GREGORIAN`（省略时为默认）、`JULIAN`、`FRENCH_R`、`HEBREW`、扩展标签。月份名称因历法而定（儒略历与格里高利历相同，为 `JAN`…`DEC`）。
- 年份采用**历史式**。没有 0 年，公元前加 `BCE`（`44 BCE` = 公元前 44 年）。与 EDTF、GREGORIAN-DATE 的天文式相差一年。
- schema 只检查字节格式：ASCII `0x20`~`0x7E`、非空、首尾无空格。语法以及日期是否真实存在由生产者检查。例如 `github.com/cacack/gedcom-go/v3`（MIT）的 `gedcom.ParseDate`。该库的 `Validate` 只在格里高利历下检查日，因此会放行 `JULIAN 30 FEB 1100`，而 `ToGregorian` 对年·月精度并不实际转换。日期的真实性检查与规范化需另行进行。
- **使用场合：** 格里高利历日期用 [GREGORIAN-DATE](0x06AL-gregorian-date.md) 或 [EDTF](0x06EL-edtf.md) 书写。GEDCOM-DATE 用于必须保存原始写法的其他历法日期。

## 与规范化值一起使用 {#정규화된-값과-함께-쓰기}

- 要在时间轴上比较、索引同一日期，需要格里高利历的值。日精度的正确对应是同一天的 GREGORIAN-DATE，年·月精度的正确对应是该期间的格里高利历区间 EDTF（`JULIAN 1300` → `1300-01-09/1301-01-08`）。
- 将原始写法（GEDCOM-DATE）与规范化值作为两个 Value 一起承载的方法尚未确定（未决问题）。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG（如有）与 Payload 的 WORD 数之和（[Length](../record.md)）。

## 示例 {#예시}

| 日期 | 字节 | 总 WORD |
|---|---|---|
| `JULIAN 1300` | 11（奇数） | `0716 4A55 4C49 414E 2031 3330 3000` |

## 标准依据 {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date)、[Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars)。规范仓库的许可证为 Apache 2.0。GEUL 只参照格式，不转录规范正文。
- ISO 8601、EDTF、XSD、CLDR 历法标识符（`u-ca`）中都没有儒略历。GEDCOM 7 是用一套语法处理历法前缀、公元前、精度、限定词的公开交换格式。

## 未决问题 {#열린-문제}

- 同时书写原始写法与规范化值的方法（在一个 TRIPLE 中把两者连起来的方法）。
- schema 对 GEDCOM 语法的检查。
- 世纪·十年精度。GEDCOM 没有对应格式。无法从 Wikidata 转入的日期，其原文保留为 UTF8-TEXT。

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[EDTF](0x06EL-edtf.md)、[GREGORIAN-DATE](0x06AL-gregorian-date.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000700/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

以上是 `GEDCOM-DATE-EVEN`（`0x070L`）的 Codec 文档。其他成员（`GEDCOM-DATE-ODD`）的 Codec 文档只在 DOC-ID 的 Codec ID、DECLARE 对象、`#1` 绑定的名称（BIND）上不同。
