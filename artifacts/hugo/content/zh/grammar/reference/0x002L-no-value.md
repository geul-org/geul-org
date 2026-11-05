---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE 是表示“无”的占位标记。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE 是表示“无”的[占位标记](../slot-marker.md)。它是关于世界的断言：没有值。

| 项目 | 值 |
|---|---|
| 名称 | `NO-VALUE`（规格文档 BIND `NO-VALUE`） |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| 规格文档 | `0x00000000/codecs/0x00000020/`（DECLARE 目标 `0020`） |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 2 |
| Kind | Reference · 分类：占位标记 |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 无。没有值（Wikidata `novalue`） |
| Hugo 侧 | `reference/slot-marker.md` |

## 布局 {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- 没有 Payload。没有目标 ID，也没有 Quantifier（[占位标记](../slot-marker.md#레이아웃)）。
- `0x002L` 中带 Payload 的形式（L ≥ 1）为 Reserved。
- `geul show`、`geul add` 的文本写法：`NONE`。

## 含义 {#뜻}

| 项目 | 无 |
|---|---|
| 说的是什么 | **世界**：没有值 |
| 逻辑 | `¬∃x. P(s, x)` |
| 世界假设 | 对 (s, P, 限定条件) 为封闭世界 |
| Wikidata | `novalue` |

## 接受 {#수용}

- 只有设置了 CODEC 目标 `0020` 的字段才接受它。该字段接受“无”这一断言。例：[TRIPLE](../edge/0x0AAL-triple.md) Object、[QUALIFIER](../edge/0x0ABL-qualifier.md) Value。
- 通配符、没有 CODEC 的字段、HEAD·BODY 记录位置、Edge Id 位置、原始值字段中不能使用（[占位标记](../slot-marker.md#수용-규칙)的公共规则）。

## 读取方的义务 {#읽는-쪽의-의무}

- **NO-VALUE 在该命题的限定条件内封闭。** 附有 QUALIFIER 时，只在该范围内封闭。Q30 P1304 NO-VALUE(P580 1811, P582 1816) 的意思是仅在 1811~1816 年没有中央银行，与同一属性的值 TRIPLE（联邦储备系统，preferred）并不矛盾。
- 同一 Subject·Predicate 下，NO-VALUE 与值 TRIPLE 以相同的 rank 并存，且限定条件无法区分时，即为矛盾。检查器给出警告，但不拒绝。Wikidata 中也存在这种状态，由读取方按 rank 选择。
- **rank 同样适用。** 选取代表值（truthy）时，NO-VALUE TRIPLE 也在候选之列。
- **用作 QUALIFIER 值时，会改变该限定的含义。** `P582 = NONE` 断言尚未结束。完全没有 P582 QUALIFIER 时，则不知道是否已经结束。
- “没有”只有**写成** NO-VALUE 才能表达。文档中没有 TRIPLE 只是未填写（开放世界）。

## 示例 {#예시}

`0x0020` 1 WORD。例：没有子女（P40）写作 `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`（TRIPLE，Object 位置为 `0020`）。

## Codec 文档 {#코덱-문서}

Codec 文档只设一个 DECLARE（目标 `0020`）。没有 Payload，所以没有 FIELD。解码器内置标记的含义和接受规则（[第 0 层](../publishing.md#층)）。读取标记时不查询 Codec 文档。

## 相关页面 {#관련-페이지}

- [占位标记](../slot-marker.md)、[ABSENT](0x000L-absent.md)、[UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md)、[Codec 规格文档](../codec-spec.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000020/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
