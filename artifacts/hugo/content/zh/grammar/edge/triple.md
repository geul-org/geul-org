---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE 是承载一个命题（Predicate、Subject、Object）及其等级（rank）的叙述 Edge（Codec 0x0A）。Object 可以用未知（UNKNOWN-VALUE）或无（NO-VALUE）代替值。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE 是承载一个命题（Predicate、Subject、Object）及其等级（rank）的叙述 Edge。Codec `0x0A`。

限定命题的条件（开始·结束时点、适用范围等）用指向 TRIPLE 的 Edge Id 的 [QUALIFIER](/zh/grammar/edge/qualifier/) 附加。出处（Wikidata references）用指向 TRIPLE 的 Edge Id 的依据 Edge [SOURCE](/zh/grammar/edge/source/) 附加。

## 布局

```
TAG WORD          0001 0LLL L000 1010
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Predicate         Reference 记录 (WIKIDATA-PID 等)
Subject           Reference 记录
Object            Reference 或 Value 记录，或占位标记 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| 码 | 名称 | 含义 |
|---|---|---|
| `0` | normal | 默认 |
| `1` | preferred | 当前值，最权威的值 |
| `2` | deprecated | 被判定为错误或过时但作为记录保留的值 |

- 与 Wikidata statement rank 相同。代表值（Wikidata truthy）是同一 Subject·Predicate 中有 preferred 则取 preferred，否则取 normal。
- 不单独标注 rank 的来源使用 `0`（normal）。
- 其他码 invalid。

## 解读与有效性

- Predicate、Subject 恰好是一个完整的 Reference 记录。
- Object 恰好是一个完整的 Reference 或 Value 记录，或[占位标记](/zh/grammar/reference/slot-marker/) `0x0001`（UNKNOWN-VALUE）·`0x0002`（NO-VALUE）1 WORD。不接受 ABSENT（`0x0000`）。Object 不是可选字段。
- 读完 Object 后必须恰好剩下 1 WORD（Rank）。
- geul.org 规格文档给 Rank 原始值字段放 [CODEC](/zh/grammar/edge/codec/) UNSIGNED-INTEGER（`0802`）和 [ENUM](/zh/grammar/edge/enum/) 0·1·2。给 Object 字段放 CODEC `0780`（任意 Reference）、`0F80`（任意 Value）、`0001`（UNKNOWN-VALUE）、`0002`（NO-VALUE）。Predicate·Subject 不接受占位标记。
- **TRIPLE 的含义是同一文档中指向其 Edge Id 的所有 QUALIFIER 的总和。** 读取方在解读 TRIPLE 之前先收集 QUALIFIER。不带 QUALIFIER 读取的 TRIPLE 可能是缺少限定的命题（例：缺少时间限定的"行政首脑"）。

## 未知与无

Object 位置上的占位标记不是值，而是关于命题的断言。

| Object | 含义 | 逻辑 |
|---|---|---|
| 值 v | Subject 的 Predicate 值之一是 v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | 有值。不知道是什么（Wikidata `somevalue`） | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | 没有值（Wikidata `novalue`） | `¬∃x. P(s, x)` |
| 没有 TRIPLE | 不断言任何事（开放世界） | |

- **在限定条件内解读。** `∃`·`¬∃` 的范围由指向该 TRIPLE 的 QUALIFIER 决定。附有 QUALIFIER 时，只在该范围内封闭。"1811~1816 年没有中央银行"是在 NO-VALUE TRIPLE 上附加 P580·P582 QUALIFIER 来写的。它与同一 Predicate 其他时期的值 TRIPLE 并不矛盾。
- **rank 同样适用。** 选取代表值（truthy）时，UNKNOWN-VALUE·NO-VALUE TRIPLE 也在候选之列。有 preferred 时只保留 preferred。
- **UNKNOWN-VALUE 之间不相等。** UNKNOWN-VALUE 与任何值既不相等也不不等（比较结果未定），两个 UNKNOWN-VALUE 之间也不视为相同的值。每次出现都是独立的存在量化。因此字节相同的两个 UNKNOWN-VALUE TRIPLE 不是重复，不合并（子女可能有两个，也可能只有一个）。
- 在同一 Subject·Predicate·rank 上，如果 NO-VALUE 与值（或 UNKNOWN-VALUE）TRIPLE 在限定条件无法区分的情况下共存，就是矛盾。检查器会发出警告。但不拒绝（这在 Wikidata 中也存在）。
- 不要把没能转换的值（来源中有值）写成 UNKNOWN-VALUE。

## 示例（非规范）

Q42（Douglas Adams）P31（instance of）Q5（human），normal。Edge Id `0005`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD，`LLLL=1001`。TAG 是 `0001 0 1001 0001010` = `148A`。

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30（美国）P1304（中央银行）NO-VALUE，normal。1811~1816 年没有中央银行（P580·P582 QUALIFIER 见 [QUALIFIER](/zh/grammar/edge/qualifier/) 示例）。Edge Id `3161`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD，`LLLL=1000`。TAG 是 `0001 0 1000 0001010` = `140A`。

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "没有子女（P40）"是 `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`。

## 未决问题

- scope（主张的上下文：世界、视角）：有了用途再定。
- 把 TRIPLE 和 QUALIFIER 折叠成一条记录的缩写形式：等有了重复字段声明（[DECLARE](/zh/grammar/edge/declare/) 未决问题）之后。

## 相关页面

- [Edge](/zh/grammar/edge/)、[QUALIFIER](/zh/grammar/edge/qualifier/)、[SOURCE](/zh/grammar/edge/source/)、[LABEL](/zh/grammar/edge/label/)、[ALIAS](/zh/grammar/edge/alias/)、[占位标记](/zh/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/zh/grammar/reference/wikidata-pid/)、[WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)
