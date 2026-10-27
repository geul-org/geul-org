---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR 是 PREDICATE-DECLARE（Codec 0x61）所用的条件表达式布局。用自带的标签表和按前序展开的表达式记录来容纳条件表达式树。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR 是书写 TANGEUL Rules 条件表达式的布局。由 Codec `0x61` PREDICATE-DECLARE（谓词声明）使用。条件表达式树按前序展开存放，表达式中的字符串通过记录内的标签表来指向。因此无需 TEXT 记录就能自成一体。

## 布局

```
ID                     LOCAL Reference 记录 (Edge Id)
节点数 1 WORD           表达式记录的总个数
标签数 1 WORD
标签 × 标签数           UTF8-TEXT Value 记录
表达式记录 × 节点数      前序
```

- 标签是字段名称、字符串值、路径步骤、函数名称之类的字符串。空字符串也是标签。表达式记录用从 0 开始编号的索引（1 WORD）指向标签。
- 表达式记录在父节点之后依次放置子节点（前序）。凭每条记录的子节点数和这个顺序，树被唯一确定。

## 表达式记录

表达式记录以 1 WORD 的头开始。

```
头 1 WORD      种类低 2 位 (b15–14) | 种类高 1 位 (b13) | 子节点数 13 位 (b12–0)
```

种类 = `(b13 << 2) | b15–14`。

| 种类 | 名称 | 子节点数 | 头之后 |
|---|---|---|---|
| 0 | COMPARE | 0 | 比较运算符 1 WORD、字段标签 1 WORD、值位置 |
| 1 | LOGIC | n | 逻辑运算符 1 WORD |
| 2 | NOT | 1 | 无 |
| 3 | EITHER | n | 无 |
| 4 | EXISTS | 1 | 量化运算符 1 WORD、目标操作数、绑定名称标签 1 WORD |
| 5 | CALL | 0 | 别名标签 1 WORD、函数名称标签 1 WORD |
| 6 | COMPARE-X | 0 | 比较运算符 1 WORD、字段标签 1 WORD、左侧标记 1 WORD [+ 操作数]、值位置 |
| 7 | 保留 | | |

- 子记录紧接在头之后的字段后面。EXISTS 的子节点是一个条件。
- COMPARE 是两侧都没有操作数的比较 `<字段> <运算符> <值>`。只要有一侧有操作数，就使用 COMPARE-X。
- COMPARE-X 的左侧标记为 `1` 时后面跟着操作数，为 `0` 则没有。有左侧操作数时，字段标签是空字符串。
- CALL 是谓词位置上的宿主函数调用。如果是本文档的函数，则别名标签是空字符串。

### 值位置

```
值种类 1 WORD    0 数, 1 字符串, 2 操作数
值                0: UNSIGNED-INTEGER Value 记录
                  1: 标签 1 WORD
                  2: 操作数 (仅在 COMPARE-X 中)
```

- 如果值字符串与非负整数的规范十进制写法完全相同，就用 UNSIGNED-INTEGER Value 书写。其他值用标签书写。因此值字符串可以原样还原。

### 操作数

```
操作数种类 1 WORD   0 路径, 1 标准引用, 2 函数调用
路径·标准引用       步骤数 1 WORD + 标签 1 WORD × 步骤数
函数调用            别名标签 1 WORD + 函数名称标签 1 WORD
```

- 路径是输入数据的路径，标准引用是用 `with` 注入的判断标准（SPEC）的路径。

### 运算符码

| 码 | 比较运算符 |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| 码 | 逻辑运算符 |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| 码 | 量化运算符 |
|---|---|
| `0x0321` | any |

### 未知输入的评估

当输入是占位标记时，比较运算符按三值（真、假、未定 U）评估。NO-VALUE 使 `is empty` 为真，其他比较为假。UNKNOWN-VALUE 使 `is not empty` 为真，`equals`·`is in`·大小比较为 U。ABSENT 和没有叙述时，所有运算符都是 U。逻辑运算符遵循 Kleene 强三值，谓词为 U 时节点判定为 Review。此评估是固定核心（[TOULMIN](/zh/grammar/edge/toulmin/#在未知之上判定)）。

## 解读与有效性

- 节点数必须与展开的表达式记录数相同。读完最后一条表达式记录的位置必须与记录末尾恰好吻合。
- 标签索引大于等于标签数则拒绝。
- NOT 和 EXISTS 的子节点数必须为 1。
- 不认识的种类（7）或不认识的值种类·操作数种类则拒绝。
- 子节点数为 13 位（最大 8191）。

## 相关页面

- [TOULMIN](/zh/grammar/edge/toulmin/)、[NODE](/zh/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/zh/grammar/value/text/utf8-text/)、[UNSIGNED-INTEGER](/zh/grammar/value/numeric/unsigned-integer/)
