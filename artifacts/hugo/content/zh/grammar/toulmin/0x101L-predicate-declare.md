---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE 是声明谓词（判定式）的 TOULMIN Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE 是声明谓词（判定式）的 TOULMIN Codec。布局为 EXPR。EXPR 是用于写入 TANGEUL Rules 条件式的布局。它把条件式树按前序展开存放，式中的字符串通过记录内的标签表引用。因此无需 TEXT 记录即可自成完整。

| 项目 | 值 |
|---|---|
| 名称 | `PREDICATE-DECLARE`（规格文档 BIND `PREDICATE-DECLARE`） |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| 规格文档 | `0x00000000/codecs/0x00001010/`（DECLARE 对象 `1010`） |
| 章节 | 8 `1000`（Edge TOULMIN），章节内偏移 C = 1 |
| Kind | Edge · 系列：TOULMIN，分组：声明，布局：EXPR |
| TAG WORD | `0001 0000 0001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 谓词声明。判定函数·式、判断标准（Spec）、事实契约（Ground） |
| Hugo 侧 | `edge/toulmin/expr.md` |

## 布局 {#레이아웃}

```
ID                     LOCAL Reference 记录 (Edge Id)
节点数 1 WORD           式记录的总数
标签数 1 WORD
标签 × 标签数           UTF8-TEXT Value 记录
式记录 × 节点数          前序
```

- 标签是字段名、字符串值、路径步骤、函数名等字符串。空字符串也算标签。式记录通过从 0 开始编号的索引（1 WORD）引用标签。
- 式记录先放父节点，再依次放子节点（前序）。由每条记录的子节点数和这一顺序，树被唯一确定。

## 式记录 {#식-레코드}

式记录以 1 WORD 的头部开始。

```
头部 1 WORD      种类低 2 位 (b15–14) | 种类高 1 位 (b13) | 子节点数 13 位 (b12–0)
```

种类 = `(b13 << 2) | b15–14`。

| 种类 | 名称 | 子节点数 | 头部之后 |
|---|---|---|---|
| 0 | COMPARE | 0 | 比较运算符 1 WORD、字段标签 1 WORD、值位 |
| 1 | LOGIC | n | 逻辑运算符 1 WORD |
| 2 | NOT | 1 | 无 |
| 3 | EITHER | n | 无 |
| 4 | EXISTS | 1 | 量化运算符 1 WORD、对象操作数、绑定名称标签 1 WORD |
| 5 | CALL | 0 | 别名标签 1 WORD、函数名标签 1 WORD |
| 6 | COMPARE-X | 0 | 比较运算符 1 WORD、字段标签 1 WORD、左侧标记 1 WORD [+ 操作数]、值位 |
| 7 | Reserved | | |

- 子记录紧接在头部之后的字段后。EXISTS 的子节点是一个条件。
- COMPARE 是两侧都没有操作数的比较 `<字段> <运算符> <值>`。只要有一侧存在操作数，就使用 COMPARE-X。
- COMPARE-X 的左侧标记为 `1` 时后面跟有操作数，为 `0` 时没有。存在左侧操作数时，字段标签为空字符串。
- CALL 是谓词位上的宿主函数调用。若是本文档的函数，则别名标签为空字符串。

### 值位 {#값-자리}

```
值种类 1 WORD    0 数, 1 字符串, 2 操作数
值                0: UNSIGNED-INTEGER Value 记录
                  1: 标签 1 WORD
                  2: 操作数 (仅限 COMPARE-X)
```

- 值字符串与非负整数的规范十进制表示完全相同时，作为 UNSIGNED-INTEGER Value 写入。其余值作为标签写入。因此值字符串可以原样还原。

### 操作数 {#피연산자}

```
操作数种类 1 WORD   0 路径, 1 基准引用, 2 函数调用
路径·基准引用         步骤数 1 WORD + 标签 1 WORD × 步骤数
函数调用              别名标签 1 WORD + 函数名标签 1 WORD
```

- 路径是输入数据的路径，基准引用是通过 `with` 注入的判断标准（SPEC）的路径。

### 运算符代码 {#연산자-코드}

| 代码 | 比较运算符 |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| 代码 | 逻辑运算符 |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| 代码 | 量化运算符 |
|---|---|
| `0x0321` | any |

### 未知输入的求值 {#미상-입력의-평가}

当输入是占位标记时，比较运算符按三值（真、假、未定 U）求值。NO-VALUE 时 `is empty` 为真，其他比较为假。UNKNOWN-VALUE 时 `is not empty` 为真，`equals`、`is in`、大小比较为 U。ABSENT 与无陈述时所有运算符均为 U。逻辑运算符遵循 Kleene 强三值逻辑，谓词为 U 时节点判定为 Review。此求值属于固定核心（[TOULMIN](_index.md#미상-위에서-판정하기)）。

## 解释与有效性 {#해석과-유효성}

- 节点数必须等于展开的式记录数。读完最后一条式记录的位置必须与记录末尾恰好吻合。
- 标签索引大于等于标签数时拒绝。
- NOT 和 EXISTS 的子节点数必须为 1。
- 未知的种类（7）或未知的值种类、操作数种类，一律拒绝。
- 子节点数为 13 位（最大 8191）。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1010`）。EXPR 布局中，前面的原始值（节点数、标签数）决定重复次数，无法用 FIELD 声明，因此字段声明是未决问题（[DECLARE](../edge/0x0BBL-declare.md#열린-문제) 重复）。

## 相关页面 {#관련-페이지}

- [TOULMIN](_index.md), [NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md), [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001010/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
