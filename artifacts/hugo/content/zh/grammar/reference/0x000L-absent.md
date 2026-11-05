---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT 是表示“未填写”的占位标记。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT 是表示“未填写”的[占位标记](../slot-marker.md)。它说的是文档：这个位置没有填写；对世界不作任何断言。

| 项目 | 值 |
|---|---|
| 名称 | `ABSENT`（规格文档 BIND `ABSENT`） |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| 规格文档 | `0x00000000/codecs/0x00000000/`（DECLARE 目标 `0000`） |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 0 |
| Kind | Reference · 分类：占位标记 |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 未填写。省略了可选字段。对世界不作任何断言 |
| Hugo 侧 | `reference/slot-marker.md` |

## 布局 {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- 没有 Payload。没有目标 ID，也没有 Quantifier（[占位标记](../slot-marker.md#레이아웃)）。
- `0x000L` 中带 Payload 的形式（L ≥ 1）为 Reserved。
- `geul show`、`geul add` 的文本写法：`ABSENT`。

## 含义 {#뜻}

| 项目 | 未填写 |
|---|---|
| 说的是什么 | **文档**：这个位置没有填写 |
| 逻辑 | 不作任何断言 |
| 世界假设 | 开放世界（无信息） |
| Wikidata | 没有对应的 snak |

## 接受 {#수용}

- 只有设置了 CODEC 目标 `0000` 的字段才接受它。该字段是**可选字段**。省略可选字段时，在该位置写一个 WORD `0x0000`。可选字段也始终占据位置（[Codec 规格文档](../codec-spec.md#선택-필드와-자리-표지)）。例：[SOURCE](../edge/0x0C0L-source.md) 的 Origin、[QUANTITY](../value/0x066L-quantity.md) 的单位、下限、上限。
- 通配符、没有 CODEC 的字段、HEAD·BODY 记录位置、Edge Id 位置、原始值字段中不能使用（[占位标记](../slot-marker.md#수용-규칙)的公共规则）。

## 读取方的义务 {#읽는-쪽의-의무}

- **ABSENT 对世界不说任何话。** 不要把它读作 UNKNOWN-VALUE 或 NO-VALUE。
- 禁止把转换器未能转写的值（来源中有的值）写成 UNKNOWN-VALUE，因为来源是知道该值的。来源没有说的位置（例：未描述来源的出处的 [SOURCE](../edge/0x0C0L-source.md) Origin），转换器也写 ABSENT。
- 在判定图中，ABSENT 和没有陈述，对所有比较运算符都是未定（U）。若要把 ABSENT 读作 empty，输入方必须声明封闭世界（[TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)）。

## 示例 {#예시}

`0x0000` 1 WORD。例：未填写单位的 QUANTITY 的单位位置。

## Codec 文档 {#코덱-문서}

Codec 文档只设一个 DECLARE（目标 `0000`）。没有 Payload，所以没有 FIELD。解码器内置标记的含义和接受规则（[第 0 层](../publishing.md#층)）。读取标记时不查询 Codec 文档。

## 相关页面 {#관련-페이지}

- [占位标记](../slot-marker.md)、[UNKNOWN-VALUE](0x001L-unknown-value.md)、[NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md)、[Codec 规格文档](../codec-spec.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000000/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
