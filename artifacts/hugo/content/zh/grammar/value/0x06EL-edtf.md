---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF 是以 ISO 8601-2 扩展日期字符串承载年·月精度、公元前、不确定、区间等日期的 Value（Codec 0x06EL/0x06FL）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF 是以 ISO 8601-2 扩展日期字符串承载年·月精度、公元前、不确定、区间等日期的 Value（Codec 0x06EL/0x06FL）。

| 项目 | 值 |
|---|---|
| 名称 | `EDTF`（奇偶分组。各代码的名称见下面的成员表） |
| TAG ID | `0x06EL`·`0x06FL` |
| 章节 | 3 `0011`（Value），章节内偏移 C = 14~15 |
| Kind | Value · 系列：TIME |
| 索引说明 | EDTF（ISO 8601-2）日期字符串。偶数·奇数字节。可用 GREGORIAN-DATE 书写的日期不使用 |
| Hugo 页面 | `value/time/edtf.md` |

## 成员 {#구성원}

本页同时处理奇偶一对的两个代码。偶数代码是字节数为偶数的值，奇数代码是字节数为奇数的值（[记录与 TAG WORD](../record.md#가변-길이-바이트열)）。Codec 文档每个代码一份。两份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 字节数 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | 偶数 | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | 奇数 | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 剩余原始值（`0xFFFF`） |  |  |

EDTF 是以 [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html)（美国国会图书馆，ISO 8601-2:2019）字符串承载日期的 Value。表示比日更粗的精度、公元前、不确定·近似·部分未知、区间。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x06EL`（偶数字节）·`0x06FL`（奇数字节）。系列 TIME。Payload 虽然是字符串，但放在 TIME 系列。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。即 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](_index.md)）。

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = 奇数字节)
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          EDTF 字符串的 ASCII 字节 / 奇数时最后为 0x00
```

## 解释与有效性 {#해석과-유효성}

- 字节序列是遵循 EDTF Level 0·1·2 语法的 ASCII 字符串。空字符串为 invalid。
- 例：日 `1952-03-11`，月 `1952-03`，年 `1952`，十年 `195X`，公元前 44 年 `-0043`，不确定 `1974?`，近似 `~1974`，区间 `1952/2001`，大年份 `Y-13799999999`。
- 年份采用 ISO 8601 天文纪年。`0000` 是公元前 1 年，`-0043` 是公元前 44 年。从历史纪年写法转换时要移动一年。
- 采用格里高利历。EDTF 不处理其他历法。儒略历等其他历法的原始写法用 [GEDCOM-DATE](0x070L-gedcom-date.md) 保存。将该日期换算为格里高利历后的同一天·同一期间的值，可用 EDTF 或 GREGORIAN-DATE 书写。
- **规范形式：** 可用 [GREGORIAN-DATE](0x06AL-gregorian-date.md) 精确书写的日期，即没有限定词（`?`、`~`、`%`）·未知位数（`X`）·区间·`Y` 前缀的 `[-]YYYY-MM-DD`，用 GREGORIAN-DATE 书写。把这样的日期写成 EDTF 为 invalid。同一天只能以一种格式书写，才能按时间进行索引·比较。
- schema 目前不检查 EDTF 语法。由生产者用 EDTF 解析器检查。例：`github.com/sfomuseum/go-edtf`（BSD-3-Clause）的 `parser.ParseString`。`parser.IsValid` 只看语法，会让 `2023-02-29`、`1974-13` 也通过，因此不使用。该解析器尚不支持 `Y` 前缀年份。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（若有）与 Payload 的 WORD 数之和（[Length](../record.md)）。

## 示例 {#예시}

| 日期 | 字节 | 总计 WORD |
|---|---|---|
| `1974` | 4（偶数） | `06E2 3139 3734` |
| `197X` | 4（偶数） | `06E2 3139 3758` |
| `1952-03` | 7（奇数） | `06F4 3139 3532 2D30 3300` |

## 标准依据 {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html)。Level 0 是 ISO 8601-1 的子集，Level 1·2 是 ISO 8601-2 的功能。
- 在 RDF 中以数据类型 `http://id.loc.gov/datatypes/edtf` 标示同一字符串。

## 未决问题 {#열린-문제}

- 检查器的 EDTF 语法检查（检查器是否依赖外部库）。
- 将维基数据的世纪·千年精度转换为 EDTF 未知位数的规则。

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[GREGORIAN-DATE](0x06AL-gregorian-date.md)、[GEDCOM-DATE](0x070L-gedcom-date.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000006E0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

上面是 `EDTF-EVEN`（`0x06EL`）的 Codec 文档。其他成员（`EDTF-ODD`）的 Codec 文档，只有 DOC-ID 中的 Codec ID、DECLARE 目标、`#1` 所绑定的名称（BIND）不同。
