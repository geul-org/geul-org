---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY 是以精确十进制数量、单位 Reference、下限·上限四条记录承载一个数量的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY 是用精确十进制数、单位、下限·上限表示一个数量的 Value。Value 直接码 `0x06`，系列为 NUMERIC。四个部分各自是完整的记录。单位和边界是[可选字段](/zh/grammar/codec-spec/)，省略时写 ABSENT（`0x0000`）。

## 布局

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length 扩展 TAG] 总计 15 WORD 以上时
amount            SIGNED-DECIMAL Value 记录
unit              Reference 记录 (单位条目)，无单位则为 0x0000
lower             SIGNED-DECIMAL Value 记录，省略则为 0x0000 ABSENT
upper             SIGNED-DECIMAL Value 记录，省略则为 0x0000 ABSENT
```

## 解读与有效性

- amount 是 [SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/) `C×10^E`。C 和 E 原样保留原来写法的位数：`1.20` = `120×10^-2`，`1.2` = `12×10^-1`。两个值是同一个数，但有效数字不同，所以是不同的 Value。系数位数没有上限（最小 WORD 二进制补码，可变长度）。
- unit 恰好是一条完整的 Reference 记录，或者是 `0x0000`。可以使用任何指向单位条目的 Reference（Wikidata 的单位是 WIKIDATA-QID）。`0x0000` 是无单位（个数、比率、人口等）。
- lower·upper 各自是 SIGNED-DECIMAL 记录，或者是 `0x0000`。只有其中一个也可以。对称范围（`652 ± 1`）也写成下限·上限两个（`651`、`653`）。因为存在非对称范围，反正需要两个值，所以不设缩减为一个 ± 的格式。
- 单位是值的一部分。不要用 QUALIFIER 等把单位拆下来（拆开后就无法知道 `652` 是 km 还是 m）。
- 不存放换算为 SI 单位的值。这是可以由单位和换算表计算得出的派生值。
- 读完四条记录的游标必须与 Payload 末尾恰好吻合。其他形态 invalid。
- geul.org 规格文档用 amount（`0810`）、unit（`0780`·`0000`）、lower·upper（`0810`·`0000`）四个记录字段来写（[Codec 规格文档](/zh/grammar/codec-spec/)）。

## 长度

- 总计是 TAG 1 WORD + (Length 扩展 TAG) + 四条记录。十进制数记录是 TAG 1 + 指数 2 + 系数 1 WORD 以上。
- 无单位·无边界的小数是 8 WORD。15 WORD 以上则使用扩展长度（[记录与 TAG WORD](/zh/grammar/record/)）。

## 示例

无单位 `1.20`：

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86`（Codec `0x06`，8 WORD），amount `0990 FFFF FFFE 0078`（E = -2，C = 120），unit·lower·upper `0000`。

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
- unit `"1"` 是无单位（`0x0000`），`http://www.wikidata.org/entity/Qn` 是 WIKIDATA-QID。其他单位，以及格式不符的数·边界不转换，而把原文以 UTF8-TEXT 保留。
- Wikidata 样本（转储前部 quantity 约 4.2 万条）：无单位 61%，有边界 13%（其中对称 93%），最长 amount 31 个字符。

## 标准依据

- 十进制写法与位数保留：[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal 的 coefficient·exponent·quantum 概念（GEUL SIGNED-DECIMAL）。
- Wikidata 数量模型：Wikibase DataModel `QuantityValue`。

## 相关页面

- [Value](/zh/grammar/value/)、[SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/)、[COORDINATE-GEO](/zh/grammar/value/numeric/coordinate-geo/)、[CODEC](/zh/grammar/edge/codec/)、[WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)
