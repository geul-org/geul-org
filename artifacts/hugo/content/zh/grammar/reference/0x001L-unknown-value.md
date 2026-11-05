---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE 是表示“未知”的占位标记。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE 是表示“未知”的[占位标记](../slot-marker.md)。它是关于世界的断言：有值，但不知道是什么。

| 项目 | 值 |
|---|---|
| 名称 | `UNKNOWN-VALUE`（规格文档 BIND `UNKNOWN-VALUE`） |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| 规格文档 | `0x00000000/codecs/0x00000010/`（DECLARE 目标 `0010`） |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 1 |
| Kind | Reference · 分类：占位标记 |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 未知。有值，但不知道是什么（Wikidata `somevalue`） |
| Hugo 侧 | `reference/slot-marker.md` |

## 布局 {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- 没有 Payload。没有目标 ID，也没有 Quantifier（[占位标记](../slot-marker.md#레이아웃)）。
- `0x001L` 中带 Payload 的形式（L ≥ 1）为 Reserved。
- `geul show`、`geul add` 的文本写法：`UNKNOWN`。

## 含义 {#뜻}

| 项目 | 未知 |
|---|---|
| 说的是什么 | **世界**：有值。不知道是什么 |
| 逻辑 | `∃x. P(s, x)`，x 未被识别 |
| 世界假设 | 存在是封闭的，身份是开放的 |
| Wikidata | `somevalue` |

## 接受 {#수용}

- 只有设置了 CODEC 目标 `0010` 的字段才接受它。该字段接受“未知”这一断言。例：[TRIPLE](../edge/0x0AAL-triple.md) Object、[QUALIFIER](../edge/0x0ABL-qualifier.md) Value、[SOURCE](../edge/0x0C0L-source.md) Origin。
- 通配符、没有 CODEC 的字段、HEAD·BODY 记录位置、Edge Id 位置、原始值字段中不能使用（[占位标记](../slot-marker.md#수용-규칙)的公共规则）。

## 读取方的义务 {#읽는-쪽의-의무}

- **UNKNOWN-VALUE 不是值，而是存在断言。** 它与任何其他值都不相等，也不不等（比较结果未定）。两个 UNKNOWN-VALUE 之间也不视为同一个值。每次出现都是独立的存在量化（与 Wikidata 的空白节点相同）。
- 因此字节相同的两个 TRIPLE（`P40 Q… UNKNOWN` ×2）不是重复。子女可能是两个，也可能是一个。含有 UNKNOWN-VALUE 的 TRIPLE 不做重复合并。
- 之后身份查明时，发布修改该 TRIPLE 的新版本。UNKNOWN-VALUE 不能被指向。需要共指时使用 LOCAL Variable（[Reference](_index.md#quantifier) Variable）。
- **rank 同样适用。** 选取代表值（truthy）时，UNKNOWN-VALUE TRIPLE 也在候选之列。
- **用作 QUALIFIER 值时，会改变该限定的含义。** `P582 = UNKNOWN` 表示已经结束，但不知道时间点。不要读作现在仍然有效的命题。
- UNKNOWN-VALUE 是“有”的断言，所以只在来源这样说时才使用。未能转写的值不写成 UNKNOWN-VALUE。

## 示例 {#예시}

`0x0010` 1 WORD。例：不知道 Q30–Q34266 边界的终止时点（P582）：`0AB7 0051 0C58 0191 0246 0051 080C 0010`（QUALIFIER，Value 位置为 `0010`）。

## Codec 文档 {#코덱-문서}

Codec 文档只设一个 DECLARE（目标 `0010`）。没有 Payload，所以没有 FIELD。解码器内置标记的含义和接受规则（[第 0 层](../publishing.md#층)）。读取标记时不查询 Codec 文档。

## 相关页面 {#관련-페이지}

- [占位标记](../slot-marker.md)、[ABSENT](0x000L-absent.md)、[NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md)、[Codec 规格文档](../codec-spec.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000010/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
