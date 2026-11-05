---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION 是按原文书写形式原样表示分数的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `FRACTION`（规格文档 BIND `FRACTION`） |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| 规格文档 | `0x00000000/codecs/0x00000670/`（DECLARE 目标 `0670`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 7 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 保留原文写法的分数：整数·十进制数分子，无符号整数·十进制数分母。不约分 |
| Hugo 页面 | `value/numeric/fraction.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | 记录 | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | 记录 | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION 是按原文书写形式原样表示分数的 Value。Value 直接码 `0x067L`，系列为 NUMERIC。分子和分母各自都是完整的 Value 记录。不约分。承载像法令中的"三分之二"、"百分之五"，以及登记中的小数份额 `23.45/1256.1` 这样、书写形式本身就是记录的分数。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[Length 扩展 TAG] 总计 15 WORD 以上时
numerator         Value 记录 1 个: SIGNED-INTEGER 或 SIGNED-DECIMAL
denominator       Value 记录 1 个: UNSIGNED-INTEGER 或 UNSIGNED-DECIMAL
```

## 解释与有效性 {#해석과-유효성}

- numerator 恰好是一个 [SIGNED-INTEGER](0x061L-signed-integer.md)（`0x061L`）或 [SIGNED-DECIMAL](0x068L-signed-decimal.md)（`0x068L`）记录。
- denominator 恰好是一个 [UNSIGNED-INTEGER](0x062L-unsigned-integer.md)（`0x062L`）或 [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md)（`0x069L`）记录。
- 这是封闭列表。其他 Value、FRACTION 自身（禁止嵌套）、占位标记（`0x0000` 等）均不接收。
- 两个记录各自带有长度，因此不单独书写边界。读完两个记录后的游标必须与 Payload 末尾恰好一致。
- 内部记录也遵循各 Codec 的规范形式（整数·coefficient 为最小 WORD）。若存在非规范的内部记录，则整个 FRACTION 为 invalid。
- 值为 `numerator / denominator`。

### 写法保留 {#표기-보존}

- **整数与小数**：原文的成分是整数（无小数点）时用 INTEGER 记录，有小数点时用 DECIMAL 记录。把成分写成指数 `E = 0` 的 DECIMAL 为 invalid。因此同一种写法只有一种字节序列。
- DECIMAL 成分的 C 与 E 保持原文位数。`23.450` 是 `23450×10^-3`，与 `23.45` 是不同的 Value。
- **不约分。** `2/4`、"百分之五"（`5/100`）原样书写。字节相同则原文写法相同。
- 分母为 1 的分数（`3/1`）若原文这样写，也原样书写。原文是整数时使用整数 Codec 而不是 FRACTION。原文是小数（`0.5`、`5%`）时使用 DECIMAL。
- 符号只放在分子上。分母是无符号 Codec。
- 分母的值为 0 则为 invalid（`0`、`0.0` 均是）。

### 比较 {#비교}

- 比较层把 FRACTION 按精确有理数 `(C1 × 10^E1) / (C2 × 10^E2)` 计算（INTEGER 成分取 `E = 0`）。不用浮点数近似。
- 比较·排序·去重判定按此值进行，存储·签名·内容哈希按写法（字节）进行。`2/4`、`1/2`、`0.5` 值相同而字节不同。
- 法定人数判定（"出席股东表决权的三分之二以上"）按这个精确值比较。

## 长度 {#길이}

- 总计是 TAG 1 WORD + （Length 扩展 TAG）+ 两个记录。整数记录为 TAG 1 + Payload 1 WORD 以上，十进制数记录为 TAG 1 + 指数 2 + coefficient 1 WORD 以上。
- 小整数分数为 5 WORD，小数分数为 9 WORD。15 WORD 以上使用扩展长度（[记录与 TAG WORD](../record.md)）。

| 原文 | 成分 | 总计 |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## 示例 {#예시}

`2/3`：

```
0674 0611 0002 0621 0003
```

- TAG `0674`（Codec `0x067L`，5 WORD），numerator `0611 0002`（SIGNED-INTEGER 2），denominator `0621 0003`（UNSIGNED-INTEGER 3）。

`23.45/1256.1`：

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678`（9 WORD），numerator `0683 FFFF FFFE 0929`（SIGNED-DECIMAL E = -2，C = 2345），denominator `0693 FFFF FFFF 3111`（UNSIGNED-DECIMAL E = -1，C = 12561）。

## 与其他格式的关系 {#다른-형식과의-관계}

- [QUANTITY](0x066L-quantity.md) 的 amount·lower·upper 接收 FRACTION。"出席表决权的三分之二"可写作 amount `2/3` 的无单位 QUANTITY。
- geul.org 规格文档 `0x00000000/codecs/0x00000670` 以两个记录字段书写：numerator（`0610`·`0680`）、denominator（`0620`·`0690`）（[Codec 规格文档](../codec-spec.md)）。
- 需要强制约分的固定 int64 分数时，使用 Issuer 格式 [RATIONAL-I64](adhoc.geul.org/rational-i64.md)。

## 未决问题 {#열린-문제}

1. 带分数（`1又2/3`）的写法保留。
2. 成分带单位的分数（面积/面积）以两个 QUANTITY 承载的格式。FRACTION 不承载单位。
3. 百分数·千分数（`5%`、`5‰`）是用 DECIMAL 与单位表示，还是用 FRACTION（`5/100`）表示的书写标准。
4. 繁分数（分子·分母中含 FRACTION）。目前禁止。

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[QUANTITY](0x066L-quantity.md)、[SIGNED-INTEGER](0x061L-signed-integer.md)、[SIGNED-DECIMAL](0x068L-signed-decimal.md)、[RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000670/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
