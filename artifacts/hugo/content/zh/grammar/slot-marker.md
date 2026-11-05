---
title: "占位标记"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "占位标记（slot marker）是填充记录字段位置的 1 WORD 记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

占位标记（slot marker）是填充记录字段位置的 1 WORD 记录。它不指向任何对象，是分配给 Reference 章节 0 前三格 `0x000L~0x002L` 的码。每个标记都有页：[ABSENT](reference/0x000L-absent.md)、[UNKNOWN-VALUE](reference/0x001L-unknown-value.md)、[NO-VALUE](reference/0x002L-no-value.md)。

值的位置上可以出现的话有三种。没有填写值、有值但不知道是什么、没有值。三者是不同的。占位标记把这三种话分写为相邻的三个 WORD。

## 布局 {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, 章节 0(Reference), Codec 0~2, LLLL 0000(1 WORD)
```

| WORD | 名称 | 含义 | 表示 |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | 未填写 | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | 未知：有值，但不知道是什么 | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | 无：没有值 | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | 这种 TAG 形态（带 Payload 的标记）未分配 | |

- 标记**没有 Quantifier。** 量化只在 5Q 体系（章节 0 的 `5 <= C < 30`，章节 1 的 `C < 30`）中读取。不把 `0x0010` UNKNOWN-VALUE 按 `C % 5` 读成 Generic（[Reference](reference/_index.md) Quantifier）。
- 没有 Payload。也没有对象 ID。
- 没有 codebook 的解码器也只看 TAG WORD 就知道它是 Kind Reference、1 WORD，从而跳过。“WORD 值为 `0x0000`、`0x0010`、`0x0020` 就是占位标记”可通过 `w & 0xF == 0 && w <= 0x0020` 判断。
- 表示 `ABSENT`·`UNKNOWN`·`NONE` 是 `geul show`·`geul add` 的文本表示。

## 三种区分 {#세-가지-구분}

| | 未填写 (ABSENT) | 未知 (UNKNOWN-VALUE) | 无 (NO-VALUE) |
|---|---|---|---|
| 谈论的是什么 | **文档**：未填充这个位置 | **世界**：有值，不知道是什么 | **世界**：没有值 |
| 逻辑 | 不断言任何事 | `∃x. P(s, x)`，x 未被识别 | `¬∃x. P(s, x)` |
| 世界假设 | 开放世界（无信息） | 存在是封闭的，身份是开放的 | 对 (s, P, 限定条件) 封闭的世界 |
| 维基数据 | 没有对应的 snak | `somevalue` | `novalue` |
| 用在哪里 | 设有 CODEC 目标 `0000` 的可选字段（SOURCE Origin 等） | 设有 CODEC 目标 `0010` 的字段（TRIPLE Object、QUALIFIER Value、SOURCE Origin） | 设有 CODEC 目标 `0020` 的字段（TRIPLE Object、QUALIFIER Value） |
| “子女（P40）有几个” | 不知道 | 至少 1 个 | 0 个 |
| “有终止时间（P582）吗” | 不知道 → 不知道现在是否仍有效 | 已结束。不知何时 | 尚未结束（断言） |

在命题层面也有同样的区分。**文档中没有 TRIPLE** 是未填写。GEUL 文档是开放世界，所以没有陈述并不意味着没有事实。“没有”只有用 NO-VALUE **写出来**才能表达。

## 接受规则 {#수용-규칙}

- 只有该字段的 [CODEC](edge/0x0BEL-codec.md) 列表中**以精确目标包含同一个 WORD 时**，占位标记才有效。目标 `0000` 的意思是“可选字段”，`0010` 是“接受未知”，`0020` 是“接受无”。
- 通配符（`000F`、`060F` 等，`L=1111`）不接受标记。任意 Reference（`000F`·`020F`·`040F`）也与标记不重叠。
- 没有 CODEC 的记录字段（“任意记录”）同样不接受标记。
- 在 HEAD·BODY 记录位置、Edge Id 位置，标记无效。
- 原始值字段不能使用标记。原始值没有 TAG，没有可放入 1 WORD 标记的位置。
- 只有标记目标的 CODEC 列表（始终是标记）无效。
- 标记的含义（有什么、没有什么）由接受该标记的 Edge 规格决定。与“量化和否定由 Edge 而非 Reference 决定”的原则相同。
- 标记的含义和接受规则属于[第 0 层](publishing.md#층)（解码器内置）。三者都没有 Payload，所以内置也没有成本。尽管如此，每个码仍设一个 Codec 文档。Codec 文档只有 DECLARE，没有 FIELD。

## 读取方的义务 {#읽는-쪽의-의무}

各记于每个标记的页。要点如下。

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무)不是值，而是存在断言。它与任何值既不相同也不相异，其 TRIPLE 不做重复合并。
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무)在该命题的限定条件内封闭。
- 两个标记都同样适用 rank，作为 QUALIFIER 值使用时会改变该限定的含义。
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무)对世界不作任何陈述。无法转换的值不用 UNKNOWN-VALUE 表示。

## 与其他“无”的区别 {#다른-없음과의-차이}

- 把 [LOCAL](reference/0x005L-local.md) `0` 用作“无”的 Codec 规则（[TOULMIN](toulmin/_index.md) REF 等）是该 Codec 内的约定。与占位标记不同。
- 不把 Identified LOCAL 用作 null·sentinel。要写未知·缺失，就在接受占位标记的字段中使用标记。

## 示例 {#예시}

Q30（美国）–Q34266（俄罗斯帝国）边界，终止时间未知。Edge Id 仅用于说明。

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Q30 的中央银行，1811~1816 年间不存在。

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- 标记位置为 1 WORD。TRIPLE 为 9 WORD（`0AA8`），QUALIFIER 为 8 WORD（`0AB7`）。
- 最简单的形式，“没有子女（P40）”为 `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`。

## 相关页面 {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md)、[UNKNOWN-VALUE](reference/0x001L-unknown-value.md)、[NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md)、[CODEC](edge/0x0BEL-codec.md)、[Codec 规格文档](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md)、[QUALIFIER](edge/0x0ABL-qualifier.md)、[TOULMIN](toulmin/_index.md)
