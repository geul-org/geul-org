---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY 是以数值 Value 记录的数量（整数·BINARY-FLOAT·十进制数·分数）、单位 Reference、下限·上限四条记录承载一个数量的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY 是用数、单位、下限·上限表示一个数量的 Value。Value 直接码 `0x06`，系列为 NUMERIC。四个部分各自是完整的记录。单位和边界是[可选字段](/zh/grammar/codec-spec/)，省略时写 ABSENT（`0x0000`）。

## 布局

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length 扩展 TAG] 总计 15 WORD 以上时
amount            数值 Value 记录 (整数·BINARY-FLOAT·十进制数·分数)
unit              Reference 记录 (单位条目)，无单位则为 0x0000
lower             数值 Value 记录，省略则为 0x0000 ABSENT
upper             数值 Value 记录，省略则为 0x0000 ABSENT
```

## 解读与有效性

- amount 是一条完整的数值 Value 记录。接受的 Codec 是 [SIGNED-INTEGER](/zh/grammar/value/numeric/signed-integer/)（`0x01`）、[UNSIGNED-INTEGER](/zh/grammar/value/numeric/unsigned-integer/)（`0x02`）、[BINARY-FLOAT](/zh/grammar/value/numeric/binary-float/)（`0x03`）、[FRACTION](/zh/grammar/value/numeric/fraction/)（`0x07`）、[SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/)（`0x10`）、[UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/)（`0x11`）这六个。这是封闭列表，不是通配符。不接受 BOOL、COORDINATE-EARTH·COORDINATE-GEO、QUANTITY 本身（禁止嵌套，深度固定）以及其他 Value。amount 不能使用位置标记（`0x0000` 等）。
- 内部记录也遵循各 Codec 的规范形式（整数·系数为最小 WORD，BINARY-FLOAT 为 1/2/4/8 WORD，FRACTION 按其规则）。若有非规范的内部记录，整个 QUANTITY 为 invalid。
- amount·lower·upper 为 BINARY-FLOAT 时必须是有限值。NaN 和 ±Infinity 为 invalid（与 [COORDINATE-EARTH](/zh/grammar/value/numeric/coordinate-earth/) 的纬度·经度规则相同）。
- 数的格式原样遵循原来的写法。整数原文用 INTEGER，小数原文用 DECIMAL，分数原文用 FRACTION，IEEE 754 binary 值用 BINARY-FLOAT 承载，编码器不改换格式进行规范化。DECIMAL 的 C 和 E 原样保留原来写法的位数：`1.20` = `120×10^-2`，`1.2` = `12×10^-1`。两个值是同一个数，但有效数字不同，所以是不同的 Value。整数和系数的位数没有上限（最小 WORD，可变长度）。
- unit 恰好是一条完整的 Reference 记录，或者是 `0x0000`。可以使用任何指向单位条目的 Reference（Wikidata 的单位是 WIKIDATA-QID）。`0x0000` 是无单位（个数、比率、人口等）。
- lower·upper 各自是与 amount 相同的六个 Codec 之一的记录，或者是 `0x0000` ABSENT。位置标记只接受 ABSENT 省略。只有其中一个也可以。三个数的 Codec 不必相同。对称范围（`652 ± 1`）也写成下限·上限两个（`651`、`653`）。因为存在非对称范围，反正需要两个值，所以不设缩减为一个 ± 的格式。
- lower ≤ amount ≤ upper 不按字节或 Codec，而按数值比较。即使类型不同也按数比较（例：SIGNED-INTEGER `652` 与 SIGNED-DECIMAL `651.5`）。FRACTION 按精确的有理数比较。
- 单位是值的一部分。不要用 QUALIFIER 等把单位拆下来（拆开后就无法知道 `652` 是 km 还是 m）。
- 取出 amount 记录，它本身就是独立的 Value 记录。需要去掉单位的数时，不必重新编码，直接使用该记录。
- 不存放换算为 SI 单位的值。这是可以由单位和换算表计算得出的派生值。
- 读完四条记录的游标必须与 Payload 末尾恰好吻合。其他形态 invalid。
- geul.org 规格文档用 amount（`0801`·`0802`·`0803`·`0807`·`0810`·`0811`）、unit（`0780`·`0000`）、lower·upper（`0801`·`0802`·`0803`·`0807`·`0810`·`0811`·`0000`）四个记录字段来写（[Codec 规格文档](/zh/grammar/codec-spec/)）。

## 长度

- 总计是 TAG 1 WORD + (Length 扩展 TAG) + 四条记录。整数记录是 TAG 1 + Payload 1 WORD 以上，BINARY-FLOAT 记录是 2·3·5·9 WORD，十进制数记录是 TAG 1 + 指数 2 + 系数 1 WORD 以上。FRACTION 记录是 5 WORD 以上。
- 无单位·无边界的小整数是 6 WORD，小的十进制数是 8 WORD。15 WORD 以上则使用扩展长度（[记录与 TAG WORD](/zh/grammar/record/)）。

## 示例

无单位 `1.20`：

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86`（Codec `0x06`，8 WORD），amount `0990 FFFF FFFE 0078`（E = -2，C = 120），unit·lower·upper `0000`。

无单位整数 `42`：

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86`（6 WORD），amount `0881 002A`（SIGNED-INTEGER 42），unit·lower·upper `0000`。

无单位分数 `2/3`（出席表决权的三分之二）：

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06`（9 WORD），amount `0A07 0881 0002 0882 0003`（[FRACTION](/zh/grammar/value/numeric/fraction/) 2/3），unit·lower·upper `0000`。

`652 km`，范围 `[651, 653]`（km = Q828224）：

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- 总计 17 WORD，所以 `LLLL=1110`，扩展 TAG `0011`。

## 与 Wikidata 的对应

- `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper。amount 和边界字符串（`+1.20`，包括指数写法）按位数原样转换为 C 和 E。
- Wikidata 的 amount·边界是十进制字符串，所以即使是整数形式（`+652`）也转换为 SIGNED-DECIMAL。Wikidata 转换不使用其他数值 Codec。
- unit `"1"` 是无单位（`0x0000`），`http://www.wikidata.org/entity/Qn` 是 WIKIDATA-QID。其他单位，以及格式不符的数·边界不转换，而把原文以 UTF8-TEXT 保留。
- Wikidata 样本（转储前部 quantity 约 4.2 万条）：无单位 61%，有边界 13%（其中对称 93%），最长 amount 31 个字符。

## 标准依据

- 十进制写法与位数保留：[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal 的 coefficient·exponent·quantum 概念（GEUL SIGNED-DECIMAL）。
- Wikidata 数量模型：Wikibase DataModel `QuantityValue`。

## 相关页面

- [Value](/zh/grammar/value/)、[SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/)、[COORDINATE-GEO](/zh/grammar/value/numeric/coordinate-geo/)、[CODEC](/zh/grammar/edge/codec/)、[WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)
