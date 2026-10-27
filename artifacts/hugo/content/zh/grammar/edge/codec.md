---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC 是指定一个 FIELD 所接受的一个 Kind·Codec 的叙述 Edge（Codec 0x1E）。通配符和占位标记（0x0000 未写、0x0001 未知、0x0002 无）也用它来声明。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC 是指定一个 [FIELD](/zh/grammar/edge/field/) 所接受的一个 Kind·Codec 的叙述 Edge。Codec `0x1E`。

正如 [ENUM](/zh/grammar/edge/enum/) 给原始值字段的一个码值赋予含义，CODEC 给字段附上一种格式。一个 Edge 一个，所以可以指定多个。布局内置于解码器（[Codec 规格文档](/zh/grammar/codec-spec/)）。

## 布局

```
TAG WORD          0001 0LLL L001 1110
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
字段              指向 FIELD Edge 的 LOCAL Reference 记录
目标              1 WORD。000K KLLL LCCC CCCC (LLLL = 0000 精确，1111 通配符)
```

## 目标 WORD

- 保持 TAG WORD 的 Kind（`KK`）和 Codec（`CCCCCCC`）位置不变。高 3 位为 0。`LLLL` 是 `0000`（精确）或 `1111`（通配符），其他值 invalid。
- 精确目标（`LLLL = 0000`）与 Codec 规格文档 ID 的值相同（例：LOCAL `0x0008`、COORDINATE-EARTH `0x0804`、UTF8-LANGUAGE-TEXT `0x084A`）。因此目标就直接指向该 Codec 规格文档。
- 奇偶码对（文本·字节序列）也用精确码指定。要同时接受偶数和奇数，就两个都放。不设把对合并解读的规则（NUMERIC `0x04`/`0x05` 这样存在不是对的相邻码）。

### 通配符 (`LLLL = 1111`)

- Kind 必须相同，**为 0 的 Codec 位组匹配任意值**。Reference 的 `CCCC`（Codec）和 `QQQ`（Quantifier）是各自独立的位组，其他 Kind 则是整个 7 位为一个位组。

| 目标 | 含义 |
|---|---|
| `0780` | 任意 Reference |
| `07A0` | WIKIDATA-QID，不论 Quantifier |
| `0781` | 任意 Reference Codec，Quantifier 为 Generic（`001`） |
| `0F80` | 任意 Value |
| `1780`、`1F80` | 任意 Edge、任意 Meta |

- 没有可匹配内容的通配符 invalid。Value·Edge·Meta 的 Codec 必须为 0，Reference 的 `CCCC` 或 `QQQ` 中必须有一个为 0。Reference `CCCC = 0000`（占位标记）是保留 Codec，所以**与任何通配符都不匹配**（`0780` 不接受 ABSENT·UNKNOWN-VALUE·NO-VALUE）。另一方面，像 Value `0x00`（BOOL）·Edge `0x00`（REFERENCE-NODE）这样已分配了 Codec 0 的 Kind，通配符也包含它（只想接受 BOOL 就用 `LLLL = 0000`）。
- 通配符不指向规格文档。
- 没有"只固定 Identified 的任意 Reference"这样，只固定一个非 0 位组、而把为 0 的位组固定下来的写法。这样的列表要列出精确目标。
- Reference 的 7 位 Codec 中包含 Quantifier（`QQQ`）。目标要精确到 Quantifier。要接受多个 Quantifier，就放多个 CODEC。

### 占位标记（目标 `0000`~`0002`）

[占位标记](/zh/grammar/reference/slot-marker/)是保留 Reference Codec `0000` 的 1 WORD 记录组。低 3 位是标记编号（不是 Quantifier）。

| 目标 | 标记 | 含义 |
|---|---|---|
| `0000` | ABSENT | 未写。该字段是可选字段 |
| `0001` | UNKNOWN-VALUE | 未知。接受"有值"的断言 |
| `0002` | NO-VALUE | 无。接受"没有值"的断言 |
| `0003`~`0007` | 保留 | |

- **接受规则：** 只有该字段的 CODEC 列表中同一个 WORD 作为精确目标存在时，标记才有效。通配符和没有 CODEC 的记录字段（"任意记录"）不接受标记。在 HEAD·BODY 的记录位置、Edge Id 位置上的标记 invalid。
- 只有标记目标的列表（始终是标记）invalid（只有 `0000` 的列表规则的推广）。与通配符或精确目标一起使用（`0780` + `0000` = 任意 Reference 或省略）。
- 原始值字段不能放标记目标。原始值没有 TAG 且宽度固定，没有可放入 1 WORD 标记的位置。
- 标记的含义由接受它的 Codec 规格决定。

### 可选字段（目标 `0000`）

- 在记录字段的 CODEC 列表中放目标 `0000`，该字段就是**可选字段**。省略时在该位置写 WORD `0x0000` 1 WORD。这条 1 WORD 记录就是占位标记 ABSENT（未写）。
- `0x0000` 是 Reference Codec `0000`（保留）、标记编号 `000`、`LLLL = 0000`（总共 1 WORD）。它不与其他记录重叠，不认识规格的解码器也把它当作 1 WORD 记录跳过。
- 可选字段也始终占据位置。省略时必须写 `0x0000`，不能留空（即使是靠后的字段也一样）。因此一条记录的写法只有一种，分解仅凭位置确定。对可选字段的位置和个数、以及是否与其他字段的列表重叠，没有限制。
- ABSENT 只在可选字段位置有效。在 HEAD·BODY 的记录位置、必需字段位置、Edge Id 位置上的 `0x0000` invalid。
- 省略不是"没有值"，而是"未写"。对世界不作任何断言。"没有值"用 NO-VALUE（`0002`）来写。省略意味着什么（例：TAG 的目标不存在则为本版本）由各格式的规范决定。

## 解读与有效性

- 字段是同一文档的 FIELD Edge。同一字段不放两次相同的目标。
- **记录字段（宽度 0）**：没有 CODEC 时，接受除占位标记外的任意记录。有一个以上则是封闭列表。该字段的记录，其 Kind·Codec（Reference 含 Quantifier）必须是列表中之一，否则该记录不遵循规格。这与 ENUM 是开放列表不同。
- **原始值字段（宽度 n ≥ 1，或其余 `0xFFFF`）**：CODEC 只放一个精确目标（不可用通配符）。该原始值是去掉 TAG 的那个 Value 的 Payload。Kind·Codec 由 CODEC 给出，Length 由 FIELD 宽度给出。奇偶码由所指定的码决定字节数的奇偶。原始值不遵循该 Value 的规则（包括长度），则该记录不遵循规格。
- 占位标记只按列表中的精确目标核对。可选字段（目标 `0000`）位置出现 `0x0000` 即为省略。其他记录用去掉标记目标的列表核对。
- 原始值字段可以同时放 CODEC 和 ENUM。CODEC 是格式，ENUM 是码值的名称（例：把 rank 设为 UNSIGNED-INTEGER，再用 ENUM 表示 0·1·2）。
- 可以用 BIND 给 CODEC 的 Edge Id 起名，但不是必需的。
- "Reference 或 Value"字段用 2 个 CODEC（`0780`、`0F80`）来写。

## 长度

```
总计 = 1 + N_len + N_id + N_field + 1 WORD   (Edge Id·字段为 LOCAL 1 WORD ID 时是 6 WORD)
```

## 示例

在 LABEL 规格文档 `geul.org/label` 中，Object 字段（FIELD #3）接受 UTF8-LANGUAGE-TEXT（偶数·奇数）和 LOCAL。Edge Id 7~9。

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E`（Edge，Codec `0x1E`，`LLLL = 0101`，6 WORD），Edge Id `0088 0007`，字段 `0088 0003`，目标 `084A`。

## 相关页面

- [FIELD](/zh/grammar/edge/field/)、[ENUM](/zh/grammar/edge/enum/)、[DECLARE](/zh/grammar/edge/declare/)、[BIND](/zh/grammar/edge/bind/)
- [Codec 规格文档](/zh/grammar/codec-spec/)、[LABEL](/zh/grammar/edge/label/)
