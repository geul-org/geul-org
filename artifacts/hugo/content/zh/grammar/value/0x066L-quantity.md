---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY 是以数值、单位、下限·上限表示一个数量的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `QUANTITY`（规格文档 BIND `QUANTITY`） |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| 规格文档 | `0x00000000/codecs/0x00000660/`（DECLARE 目标 `0660`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 6 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 数值 Value amount（整数·BINARY-FLOAT·十进制数·分数），单位 Reference，下限·上限。单位·边界可省略（ABSENT `0x0000`） |
| Hugo 页面 | `value/numeric/quantity.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | 记录 | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference），`0000` ABSENT（可选字段） |  |
| 3 | `lower` | #4 | 记录 | `0680` SIGNED-DECIMAL, `0000` ABSENT（可选字段）, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | 记录 | `0680` SIGNED-DECIMAL, `0000` ABSENT（可选字段）, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY 是以数值、单位、下限·上限表示一个数量的 Value。Value 直接码 `0x066L`，系列为 NUMERIC。四个部分各自都是完整的记录。单位和边界是[可选字段](../codec-spec.md)，省略时写 ABSENT（`0x0000`）。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[Length 扩展 TAG] 总计 15 WORD 以上时
amount            数值 Value 记录 (整数·BINARY-FLOAT·十进制数·分数)
unit              Reference 记录 (单位条目), 无单位则为 0x0000
lower             数值 Value 记录, 省略则为 0x0000 ABSENT
upper             数值 Value 记录, 省略则为 0x0000 ABSENT
```

## 解释与有效性 {#해석과-유효성}

- amount 是一个完整的数值 Value 记录。接收的 Codec 有六个：[SIGNED-INTEGER](0x061L-signed-integer.md)（`0x061L`）、[UNSIGNED-INTEGER](0x062L-unsigned-integer.md)（`0x062L`）、[BINARY-FLOAT](0x063L-binary-float.md)（`0x063L`）、[FRACTION](0x067L-fraction.md)（`0x067L`）、[SIGNED-DECIMAL](0x068L-signed-decimal.md)（`0x068L`）、[UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md)（`0x069L`）。这是封闭列表，不是通配符。BOOL、COORDINATE-EARTH·COORDINATE-GEO、QUANTITY 自身（禁止嵌套，深度固定）以及其他 Value 均不接收。amount 不能使用占位标记（`0x0000` 等）。
- 内部记录也遵循各 Codec 的规范形式（整数·coefficient 为最小 WORD，BINARY-FLOAT 为 1/2/4/8 WORD，FRACTION 遵循其规则）。若存在非规范的内部记录，则整个 QUANTITY 为 invalid。
- amount·lower·upper 为 BINARY-FLOAT 时必须是有限值。NaN 和 ±Infinity 为 invalid（与 [COORDINATE-EARTH](0x064L-coordinate-earth.md) 的纬度·经度规则相同）。
- 数的格式完全遵循原始写法。整数原文用 INTEGER，小数原文用 DECIMAL，分数原文用 FRACTION，IEEE 754 binary 值用 BINARY-FLOAT 承载，编码器不得改变格式来做规范化。DECIMAL 的 C 与 E 原样承载原始写法的位数：`1.20` = `120×10^-2`，`1.2` = `12×10^-1`。两者是同一个数，但有效数字不同，因此是不同的 Value。整数和 coefficient 的位数没有上限（最小 WORD，可变长度）。
- unit 恰好是一个完整的 Reference 记录，或者是 `0x0000`。任何指向单位条目的 Reference 都可使用（维基数据单位用 WIKIDATA-QID）。`0x0000` 表示无单位（个数、比率、人口等）。
- lower·upper 各自是与 amount 相同的六个 Codec 之一的记录，或者是 `0x0000` ABSENT。占位标记只接受 ABSENT 省略。只有其中之一也可以。三个数的 Codec 不必相同。
- lower ≤ amount ≤ upper 不按字节或 Codec，而按数值比较。类型不同也按数比较（例：SIGNED-INTEGER `652` 与 SIGNED-DECIMAL `651.5`）。FRACTION 按精确有理数比较。对称范围（`652 ± 1`）也写成下限·上限两个值（`651`、`653`）。由于存在非对称范围，无论如何都需要两个值，因此不设缩减为单个 ± 的格式。
- 单位是值的一部分。不将单位用 QUALIFIER 等剥离出来（剥离后无法知道 `652` 是 km 还是 m）。
- 取出 amount 记录后，它本身就是独立的 Value 记录。需要去掉单位的数时，不必重新编码，直接使用该记录。
- 不承载换算为 SI 单位的值。那是可由单位和换算表计算出的派生值。
- 读完四个记录后的游标必须与 Payload 末尾恰好一致。其他形态为 invalid。
- geul.org 规格文档以四个记录字段书写：amount（`0610`·`0620`·`0630`·`0670`·`0680`·`0690`）、unit（`000F`·`020F`·`040F`·`0000`）、lower·upper（`0610`·`0620`·`0630`·`0670`·`0680`·`0690`·`0000`）（[Codec 规格文档](../codec-spec.md)）。

## 长度 {#길이}

- 总计是 TAG 1 WORD + （Length 扩展 TAG）+ 四个记录。整数记录为 TAG 1 + Payload 1 WORD 以上，BINARY-FLOAT 记录为 2·3·5·9 WORD，十进制数记录为 TAG 1 + 指数 2 + coefficient 1 WORD 以上，FRACTION 记录为 5 WORD 以上。
- 无单位·无边界的小整数为 6 WORD，小十进制数为 8 WORD。15 WORD 以上使用扩展长度（[记录与 TAG WORD](../record.md)）。

## 示例 {#예시}

无单位 `1.20`：

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667`（Codec `0x066L`，8 WORD），amount `0683 FFFF FFFE 0078`（E = -2，C = 120），unit·lower·upper `0000`。

无单位整数 `42`：

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665`（6 WORD），amount `0611 002A`（SIGNED-INTEGER 42），unit·lower·upper `0000`。

无单位分数 `2/3`（出席表决权的三分之二）：

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668`（9 WORD），amount `0674 0611 0002 0621 0003`（[FRACTION](0x067L-fraction.md) 2/3），unit·lower·upper `0000`。

`652 km`，范围 `[651, 653]`（km = Q828224）：

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- 总计 17 WORD，因此 `LLLL=1110`，扩展 TAG `0011`。

## 与维基数据的对应 {#위키데이터-대응}

- `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper。amount 与边界字符串（`+1.20`，含指数写法）按位数原样转为 C 和 E。
- 维基数据的 amount·边界是十进制字符串，因此即使是整数形状（`+652`）也转为 SIGNED-DECIMAL。维基数据转换不使用其他数值 Codec。
- unit `"1"` 为无单位（`0x0000`），`http://www.wikidata.org/entity/Qn` 为 WIKIDATA-QID。其他单位、格式不符的数·边界不转换，而以 UTF8-TEXT 保存原文。
- 维基数据样本（转储前部 quantity 约 4.2 万条）：无单位 61%，有边界 13%（其中对称 93%），最长 amount 31 个字符。

## 标准依据 {#표준-근거}

- 十进制写法与位数保留：[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal 的 coefficient·exponent·quantum 概念（GEUL SIGNED-DECIMAL）。
- 维基数据数量模型：Wikibase DataModel `QuantityValue`。

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[SIGNED-DECIMAL](0x068L-signed-decimal.md)、[COORDINATE-GEO](0x065L-coordinate-geo.md)、[CODEC](../edge/0x0BEL-codec.md)、[WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000660/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
