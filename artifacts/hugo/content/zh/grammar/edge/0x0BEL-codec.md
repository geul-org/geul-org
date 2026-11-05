---
title: "CODEC (0x0BEL)"
weight: 190
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC 是指定一个 FIELD 所接受的一个 Kind·Codec 的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `CODEC`（规格文档 BIND `CODEC`） |
| TAG ID | `0x0BEL` |
| Codec ID | `0x00000BE0` |
| 规格文档 | `0x00000000/codecs/0x00000BE0/`（DECLARE 目标 `0BE0`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 30 |
| Kind | Edge · 系列：陈述，分组：其他 |
| TAG WORD | `0000 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 字段所接受的一个 Kind·Codec。字段、目标 WORD（`000K KKKC CCCC LLLL`，LLLL 0000 精确·1111 通配符（该章节 32 格全部），占位标记只能用精确目标 `0000`·`0010`·`0020`）。记录字段可有多个（封闭列表），原始值字段只有一个（无 TAG 的那个 Value） |
| Hugo 侧 | `edge/codec.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | 记录 | `0050` LOCAL |  |
| 2 | `target` | #4 | 原始值 1 WORD |  |  |

CODEC 是指定一个 [FIELD](0x0BCL-field.md) 所接受的一个 Kind·Codec 的陈述 Edge。Codec `0x0BEL`。

正如 [ENUM](0x0BDL-enum.md) 为原始值字段的一个码值附加含义，CODEC 为字段附加一个格式。每个 Edge 只指定一个，所以可以指定多个。布局内置于解码器（[Codec 规格文档](../codec-spec.md)）。

## 布局 {#레이아웃}

```
TAG WORD          0000 1011 1110 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
字段              指向 FIELD Edge 的 LOCAL Reference 记录
目标              1 WORD。000K KKKC CCCC LLLL (LLLL = 0000 精确，1111 通配符)
```

## 目标 WORD {#대상-word}

- 原样保留 TAG WORD 的 Codec 位置（章节 `KKKK` 和 `CCCCC`）。高 3 位为 0。`LLLL` 是 `0000`（精确）或 `1111`（通配符），其他值为 invalid。
- 把精确目标（`LLLL = 0000`）写成 32 位的值就是该 Codec 的 Codec ID（例：LOCAL `0x0050` → `0x00000050`，COORDINATE-EARTH `0x0640`，UTF8-LANGUAGE-TEXT `0x0780`）。因此目标直接指向该 Codec 规格文档（[Codec 规格文档](../codec-spec.md)）。
- 奇偶码对（文本·字节序列）也用精确码指定。若要偶数、奇数都接受，则两个都放。不设把成对码合并解释的规则（存在 NUMERIC `0x064L`/`0x065L` 这样并非成对的相邻码）。

### 通配符（`LLLL = 1111`） {#와일드카드-llll--1111}

- 当 `LLLL = 1111` 时，与 `C` 值无关，接受目标 WORD 所在章节 `KKKK`（32 格）的全部。只要在同一章节内，`C` 取何值含义都相同。只看目标的章节与记录的章节是否相同。不跨章节接受。
- 当 `LLLL = 1111` 时，建议使用章节第一格（`C = 0`）。这是建议而非强制。同一章节的其他 `C` 也有效。
- Kind 跨多个章节时，按章节分别列出 CODEC。

| 目标 | 含义 |
|---|---|
| `000F`·`020F`·`040F` | 任意 Reference（章节 0~2，含 REFERENCE-ISSUER） |
| `060F`·`080F` | 任意 Value（章节 3·4，含 VALUE-ISSUER） |
| `0A0F`·`0C0F`·`0E0F`·`100F`·`120F`·`140F`·`160F`·`180F`·`1A0F` | 任意 Edge（章节 5~13，含 EDGE-ISSUER） |
| `1C0F`·`1E0F` | 任意 Meta（章节 14·15） |

- Reference 占位标记（`0x000L~0x002L`）与 `LLLL = 1111` 不匹配（`000F` 不接受 ABSENT·UNKNOWN-VALUE·NO-VALUE）。另一方面，像 Value `0x060L`（BOOL）、Edge `0x0A0L`（REFERENCE-NODE）这样章节第一格已被分配的章节，`LLLL = 1111` 也包含它（若只想接受 BOOL，则用 `LLLL = 0000` 的 `0600`）。
- `LLLL = 1111` 的目标不指向规格文档。
- 与量化无关的分组，只用 CODEC 列举（`LLLL = 0000`）来书写。例：WIKIDATA-QID 与量化无关为 `0140`、`0150`、`0160`、`0170`、`0180` 五个。
- Reference 5Q 体系的码中包含量化。目标要精确指定到量化。若要接受多个 Quantifier，就放多个 CODEC。REFERENCE-ISSUER 的量化由 Issuer 文档规定。

### 占位标记（目标 `0000`、`0010`、`0020`） {#자리-표지-대상-0000-0010-0020}

[占位标记](../slot-marker.md)是分配在 Reference 章节 0 前三格 `0x000L~0x002L` 的 1 WORD 记录分组。没有量化。

| 目标 | 标记 | 含义 |
|---|---|---|
| `0000` | ABSENT | 不书写。该字段是可选字段 |
| `0010` | UNKNOWN-VALUE | 未知。接受存在值的断言 |
| `0020` | NO-VALUE | 无。接受不存在值的断言 |

- **接受规则：** 只有当该字段的 CODEC 列表中把同一个 WORD 作为精确目标时，标记才有效。通配符以及没有 CODEC 的记录字段（"任意记录"）不接受标记。HEAD·BODY 记录位置、Edge Id 位置上的标记为 invalid。
- 只有标记目标的列表（始终是标记）为 invalid（只有 `0000` 的列表规则的一般化）。须与 `LLLL = 1111` 目标或精确目标一起使用（`000F`·`020F`·`040F` + `0000` = 任意 Reference 或省略）。
- 原始值字段不能放标记目标。原始值没有 TAG，宽度已定，没有可放入 1 WORD 标记的位置。
- 标记的含义由接受它的 Codec 规格规定。

### 可选字段（目标 `0000`） {#선택-필드-대상-0000}

- 在记录字段的 CODEC 列表中放入目标 `0000`，该字段就是**可选字段**。省略时在该位置写 WORD `0x0000` 1 WORD。这条 1 WORD 记录就是占位标记 ABSENT（不书写）。
- `0x0000` 是 Reference，Codec `0x000L`（Reserved），`LLLL = 0000`（总共 1 WORD）。它与其他记录不重叠，不了解规格的解码器也会把它当作 1 WORD 记录跳过。
- 可选字段也始终占据位置。省略时必须写 `0x0000`，不空出位置（后部字段也一样）。因此一条记录的表示只有一种，分解仅由位置决定。对可选字段的位置和个数，以及与其他字段的列表是否重叠，没有限制。
- ABSENT 只在可选字段的位置上有效。HEAD·BODY 记录位置、必填字段位置、Edge Id 位置上的 `0x0000` 为 invalid。
- 省略是"不书写"而不是"没有值"。不对世界断言任何事。"没有值"用 NO-VALUE（`0020`）书写。省略意味着什么（例：TAG 没有目标则为本版本）由各格式的说明规定。

## 解释与有效性 {#해석과-유효성}

- 字段是同一文档的 FIELD Edge。同一字段中不放两次相同目标。
- **记录字段（宽度 0）**：没有 CODEC 时，接受除占位标记之外的任意记录。有一个以上时是封闭列表。该字段的记录其 Kind·Codec（Reference 含 Quantifier）必须是列表中的一个，否则该记录不符合规格。这与 ENUM 是开放列表不同。
- **原始值字段（宽度 n ≥ 1，或剩余 `0xFFFF`）**：CODEC 只放一个精确目标（不可用通配符）。该原始值是去掉 TAG 的那个 Value 的 Payload。Kind·Codec 由 CODEC 给出，Length 由 FIELD 宽度给出。奇偶码由所指定的码决定字节数的奇偶。原始值若不符合该 Value 规则（含长度），该记录即不符合规格。
- 占位标记只与列表中的精确目标比对。可选字段（目标 `0000`）位置上出现 `0x0000` 即为省略。其他记录与去掉标记目标的列表比对。
- 原始值字段可以同时放 CODEC 和 ENUM。CODEC 是格式，ENUM 是码值的名称（例：把 rank 设为 UNSIGNED-INTEGER，并用 ENUM 表示 0·1·2）。
- 可以用 BIND 给 CODEC 的 Edge Id 命名，但不是必须。
- "Reference 或 Value"字段用 5 个 CODEC（`000F`、`020F`、`040F`、`060F`、`080F`）书写。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_field + 1 WORD   (Edge Id·字段为 LOCAL 1 WORD ID 时为 6 WORD)
```

## 示例 {#예시}

在 LABEL 规格文档 `0x00000000/codecs/0x00000A40/` 中，Object 字段（FIELD #3）接受 UTF8-LANGUAGE-TEXT（偶数·奇数）和 LOCAL。Edge Id 7~9。

```
0BE5 0051 0007 0051 0003 0780
0BE5 0051 0008 0051 0003 0790
0BE5 0051 0009 0051 0003 0050
```

- TAG `0BE5`（Edge，Codec `0x0BEL`，`LLLL = 0101`，6 WORD），Edge Id `0051 0007`，字段 `0051 0003`，目标 `0780`。

## 相关页面 {#관련-페이지}

- [FIELD](0x0BCL-field.md)、[ENUM](0x0BDL-enum.md)、[DECLARE](0x0BBL-declare.md)、[BIND](0x0A3L-bind.md)
- [Codec 规格文档](../codec-spec.md)、[LABEL](0x0A4L-label.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000BE0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BE000000000
BODY
#1 DECLARE 0x0BE0
#2 FIELD #1 record
#3 CODEC #2 0x0050
#4 FIELD #1 0x0001
#5 BIND #1 "CODEC"
#6 BIND #2 "field"
#7 BIND #4 "target"
```
