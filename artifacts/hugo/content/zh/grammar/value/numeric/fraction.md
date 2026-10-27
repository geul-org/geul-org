---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION 是把分子（整数·十进制数）和分母（无符号整数·十进制数）按原文写法原样、不约分地承载的分数 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION 是按原文写法表示原文中所写分数的 Value。Value 直接码 `0x07`，系列为 NUMERIC。分子和分母各自是完整的 Value 记录。不约分。它承载写法本身就是记录的分数，例如法令中的"三分之二""百分之五"，以及不动产登记中的小数份额 `23.45/1256.1`。

## 布局

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[Length 扩展 TAG] 总计 15 WORD 以上时
numerator         Value 记录 1 条：SIGNED-INTEGER 或 SIGNED-DECIMAL
denominator       Value 记录 1 条：UNSIGNED-INTEGER 或 UNSIGNED-DECIMAL
```

## 解读与有效性

- numerator 恰好是一条 [SIGNED-INTEGER](/zh/grammar/value/numeric/signed-integer/)（`0x01`）或 [SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/)（`0x10`）记录。
- denominator 恰好是一条 [UNSIGNED-INTEGER](/zh/grammar/value/numeric/unsigned-integer/)（`0x02`）或 [UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/)（`0x11`）记录。
- 这是封闭列表。不接受其他 Value、FRACTION 本身（禁止嵌套）以及位置标记（`0x0000` 等）。
- 两条记录各自带有长度，所以不另写边界。读完两条记录后的游标必须与 Payload 末尾恰好对齐。
- 内部记录也遵循各 Codec 的规范形式（整数·系数为最小 WORD）。若有非规范的内部记录，整个 FRACTION 为 invalid。
- 值为 `numerator / denominator`。

### 保留写法

- **整数与小数**：原文成分是整数（没有小数点）时用 INTEGER 记录，有小数点时用 DECIMAL 记录。把成分写成指数 `E = 0` 的 DECIMAL 是 invalid。因此同一写法只有一种字节序列。
- DECIMAL 成分的 C 和 E 原样保留原文的位数。`23.450` 是 `23450×10^-3`，与 `23.45` 是不同的 Value。
- **不约分。** `2/4`、"百分之五"（`5/100`）原样书写。字节相同则原文写法相同。
- 分母为 1 的分数（`3/1`）如果原文这样写，也原样书写。原文是整数时，不用 FRACTION 而用整数 Codec。原文是小数（`0.5`、`5%`）时用 DECIMAL。
- 符号只放在分子上。分母是无符号 Codec。
- 分母的值为 0 时为 invalid（`0`、`0.0` 都是）。

### 比较

- 比较层把 FRACTION 计算为精确的有理数 `(C1 × 10^E1) / (C2 × 10^E2)`（INTEGER 成分取 `E = 0`）。不用浮点数近似。
- 比较·排序·重复判定按这个值进行，存储·签名·内容哈希按写法（字节）进行。`2/4`、`1/2`、`0.5` 值相同而字节不同。
- 法定人数判定（"出席股东表决权的三分之二以上"）用这个精确值比较。

## 长度

- 总计是 TAG 1 WORD + (Length 扩展 TAG) + 两条记录。整数记录是 TAG 1 + Payload 1 WORD 以上，十进制数记录是 TAG 1 + 指数 2 + 系数 1 WORD 以上。
- 小的整数分数是 5 WORD，小的小数分数是 9 WORD。15 WORD 以上则使用扩展长度（[记录与 TAG WORD](/zh/grammar/record/)）。

| 原文 | 成分 | 总计 |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## 示例

`2/3`：

```
0A07 0881 0002 0882 0003
```

- TAG `0A07`（Codec `0x07`，5 WORD），numerator `0881 0002`（SIGNED-INTEGER 2），denominator `0882 0003`（UNSIGNED-INTEGER 3）。

`23.45/1256.1`：

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07`（9 WORD），numerator `0990 FFFF FFFE 0929`（SIGNED-DECIMAL E = -2，C = 2345），denominator `0991 FFFF FFFF 3111`（UNSIGNED-DECIMAL E = -1，C = 12561）。

## 与其他格式的关系

- [QUANTITY](/zh/grammar/value/numeric/quantity/) 的 amount·lower·upper 接受 FRACTION。"出席表决权的三分之二"可以写成 amount 为 `2/3` 的无单位 QUANTITY。
- geul.org 规格文档 `0x0000/0x0000000000000807` 用 numerator（`0801`·`0810`）、denominator（`0802`·`0811`）两个记录字段书写（[Codec 规格文档](/zh/grammar/codec-spec/)）。
- 需要强制约分的固定 int64 分数时，使用 Issuer 格式 [RATIONAL-I64](/zh/grammar/value/etc/rational-i64/)。

## 未决问题

1. 带分数（`1又2/3`）的写法保留。
2. 把成分带单位的分数（面积/面积）用两个 QUANTITY 承载的格式。FRACTION 不承载单位。
3. 百分比·千分比（`5%`、`5‰`）采用 DECIMAL 加单位，还是 FRACTION（`5/100`）的写法标准。
4. 繁分数（分子·分母中放 FRACTION）。目前禁止。

## 相关页面

- [Value](/zh/grammar/value/)、[QUANTITY](/zh/grammar/value/numeric/quantity/)、[SIGNED-INTEGER](/zh/grammar/value/numeric/signed-integer/)、[SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/)、[RATIONAL-I64](/zh/grammar/value/etc/rational-i64/)
