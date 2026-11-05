---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE 是承载一个命题（Predicate、Subject、Object）及其等级（rank）的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `TRIPLE`（规格文档 BIND `TRIPLE`） |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| 规格文档 | `0x00000000/codecs/0x00000AA0/`（DECLARE 目标 `0AA0`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 10 |
| Kind | Edge · 系列：陈述，分组：命题 |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 按 Predicate、Subject、Object 顺序的命题与 rank。Object 是值或 UNKNOWN-VALUE·NO-VALUE 标记。含义是指向其 Edge Id 的所有 QUALIFIER 汇集在一起的结果 |
| Hugo 侧 | `edge/triple.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference） |  |
| 2 | `subject` | #3 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference） |  |
| 3 | `object` | #4 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference），`060F` 章节 3 全部（通配符，Value），`080F` 章节 4 全部（通配符，Value），`0010` UNKNOWN-VALUE，`0020` NO-VALUE |  |
| 4 | `rank` | #5 | 原始值 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal，`0x0001` preferred，`0x0002` deprecated |

TRIPLE 是承载一个命题（Predicate、Subject、Object）及其等级（rank）的陈述 Edge。Codec `0x0AAL`。

限定命题的条件（起止时间、适用范围等）用指向 TRIPLE 的 Edge Id 的 [QUALIFIER](0x0ABL-qualifier.md) 附加。出处（维基数据 references）用指向 TRIPLE 的 Edge Id 的依据 Edge [SOURCE](0x0C0L-source.md) 附加。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Predicate         Reference 记录 (WIKIDATA-PID 等)
Subject           Reference 记录
Object            Reference 或 Value 记录，或占位标记 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| 码 | 名称 | 含义 |
|---|---|---|
| `0` | normal | 默认 |
| `1` | preferred | 当前值，最具权威的值 |
| `2` | deprecated | 被判定为错误或过时但仍作为记录保留的值 |

- 与维基数据 statement rank 相同。代表值（维基数据 truthy）是同一 Subject、Predicate 中有 preferred 则取 preferred，否则取 normal。
- 不单独标注 rank 的来源使用 `0`（normal）。
- 其他码为 invalid。

## 解释与有效性 {#해석과-유효성}

- Predicate、Subject 是恰好一条完整的 Reference 记录。
- Object 是恰好一条完整的 Reference 或 Value 记录，或 1 WORD 的[占位标记](../slot-marker.md) `0x0010`（UNKNOWN-VALUE）·`0x0020`（NO-VALUE）。不接受 ABSENT（`0x0000`）。Object 不是可选字段。
- 读完 Object 后必须恰好剩下 1 WORD（Rank）。
- geul.org 规格文档给 Rank 原始值字段放 [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER（`0620`）和 [ENUM](0x0BDL-enum.md) 0·1·2。给 Object 字段放 CODEC `000F`·`020F`·`040F`（任意 Reference）、`060F`·`080F`（任意 Value）、`0010`（UNKNOWN-VALUE）、`0020`（NO-VALUE）。给 Predicate、Subject 字段放 CODEC `000F`·`020F`·`040F`（任意 Reference）。由于是通配符，不接受占位标记。
- **TRIPLE 的含义是同一文档中指向其 Edge Id 的所有 QUALIFIER 汇集在一起的结果。** 读取方在解释 TRIPLE 之前先收集 QUALIFIER。不带 QUALIFIER 读取的 TRIPLE 可能是缺少限定的命题（例：缺少时间限定的"行政首脑"）。

## 未知与无 {#알-수-없음과-없음}

Object 位置上的占位标记不是值，而是关于命题的断言。

| Object | 含义 | 逻辑 |
|---|---|---|
| 值 v | Subject 的 Predicate 值之一是 v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | 有值。不知道是什么（维基数据 `somevalue`） | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | 没有值（维基数据 `novalue`） | `¬∃x. P(s, x)` |
| 没有 TRIPLE | 不断言任何事（开放世界） | |

- **在限定条件内解释。** `∃`·`¬∃` 的范围由指向该 TRIPLE 的 QUALIFIER 决定。附有 QUALIFIER 时，只在该范围内封闭。"1811~1816 年没有中央银行"是在 NO-VALUE TRIPLE 上附加 P580·P582 QUALIFIER 来书写的。它与同一 Predicate 其他时期的值 TRIPLE 并不矛盾。
- **rank 同样适用。** 选取代表值（truthy）时，UNKNOWN-VALUE·NO-VALUE TRIPLE 也在候选之列。有 preferred 则只留下 preferred。
- **UNKNOWN-VALUE 之间并不相同。** UNKNOWN-VALUE 与任何值既不相同也不相异（比较结果未定），两个 UNKNOWN-VALUE 之间也不视为同一个值。每次出现都是独立的存在量化。因此 byte 相同的两个 UNKNOWN-VALUE TRIPLE 并不是重复，不合并（子女可能是两个，也可能是一个）。
- 同一 Subject、Predicate、rank 上，NO-VALUE 与值（或 UNKNOWN-VALUE）TRIPLE 在限定条件无法区分的情况下并存，则为矛盾。检查器发出警告。不予拒绝（维基数据中也存在这种状态）。
- 不把未能转换的值（来源中有值）写成 UNKNOWN-VALUE。

## 示例（非规范） {#예시-비규범}

Q42（Douglas Adams）P31（instance of）Q5（human），normal。Edge Id `0005`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD，`LLLL=1001`。TAG 为 `0000 1010 1010 1001` = `0AA9`。

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30（美国）P1304（中央银行）NO-VALUE，normal。1811~1816 年没有中央银行（P580·P582 QUALIFIER 见 [QUALIFIER](0x0ABL-qualifier.md) 示例）。Edge Id `3161`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD，`LLLL=1000`。TAG 为 `0000 1010 1010 1000` = `0AA8`。

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "无子女（P40）"为 `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`。

## 未决问题 {#열린-문제}

- scope（主张的上下文：世界、视角）：待有用途时再定。
- 把 TRIPLE 和 QUALIFIER 折叠进一条记录的缩写形式：待有了重复字段声明（[DECLARE](0x0BBL-declare.md) 未决问题）之后。

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[QUALIFIER](0x0ABL-qualifier.md)、[SOURCE](0x0C0L-source.md)、[LABEL](0x0A4L-label.md)、[ALIAS](0x0A5L-alias.md)、[占位标记](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md)、[WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000AA0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
