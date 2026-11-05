---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX 是用 GEUL SIDX（Semantic-aligned Index）指向对象的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `GEUL-SIDX`（5Q 分组。各代码的名称见下方成员表） |
| TAG ID | `0x00FL~0x013L` |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 15~19 |
| Kind | Reference · 分类：声明 |
| Hugo 侧 | `reference/geul-sidx.md` |

## 成员 {#구성원}

本页合并讲述一套 5Q 体系的五个代码。量化由章节内偏移 `C % 5` 决定（[Reference](_index.md#quantifier)）。每个代码各有一份 Codec 文档。五份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 量化 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | 剩余原始值（`0xFFFF`） |  |  |

GEUL-SIDX 是用 GEUL SIDX（Semantic-aligned Index）指向对象的声明 Reference。SIDX 是在比特本身承载含义（类别、属性）的标识符。

## 布局 {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[Length 扩展 TAG]
SIDX              其余全部
```

- Quantifier 与其他声明 Codec 相同。为 Variable 时，是该类别的匿名变量（[Reference](_index.md) Variable）。量化只通过 5Q 代码（`0x00FL~0x013L`，`C % 5`）进行。SIDX 值中不放入量化。
- 规格文档把 SIDX 声明为一个剩余宽度的原始值字段。宽度规则确定后再修改。

## 示例 {#예시}

| SIDX | WORD sequence |
|---|---|
| （非规范）64 位 `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## 分配方针 {#배정-방침}

- 与 [GEUL](0x00AL-geul.md) 的角色不同。GEUL 是大体按顺序（auto increment）分配的身份 ID，GEUL-SIDX 是给语义相近的对象赋予相近值的语义地址。
- 相近的程度通过积累使用数据，由统计决定。统计积累之前使用 GEUL ID；分配 SIDX 后，用 [SAME-NODE](../edge/0x0A1L-same-node.md) 把同一对象的 GEUL 和 GEUL-SIDX 连起来。

## 未决问题 {#열린-문제}

- **宽度。** 参考统计后决定。正在考虑 4 WORD（64 位）和 16 WORD 等。SIDX 的高位比特有含义，因此不能照搬其他声明 Codec 的“最短宽度”规则（禁止前导 `0x0000`）。所以会是固定宽度（或按子格式固定宽度）。在确定之前，规格文档把 SIDX 声明为剩余宽度的原始值。
- **分配的稳定性。** Reference 的整数值相同则为同一对象，且已分配的 ID 不重用。若统计变化后也不想移动已分配的 SIDX，就需要 append-only 分配（为语义相近的位置预留空位的稀疏分配）。若需要经常移动，则要决定是否把 SIDX 定义为与注册表版本绑定的索引，而不是永久标识符。
- **唯一性。** 若 SIDX 按比特语义生成而可能冲突，就与“整数值相同则为同一对象”的前提不符。分配时消解冲突，以保证唯一性。
- 码本和注册表的公开格式。

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[GEUL](0x00AL-geul.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000000F0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

以上是 `GEUL-SIDX-IDENTIFIED`（`0x00FL`）的 Codec 文档。其他成员（`GEUL-SIDX-GENERIC`、`GEUL-SIDX-FREE-CHOICE`、`GEUL-SIDX-UNIVERSAL`、`GEUL-SIDX-VARIABLE`）的 Codec 文档，只有 DOC-ID 的 Codec ID、DECLARE 目标、`#1` 上绑定的名称（BIND）不同。
