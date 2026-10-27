---
title: "Codec 规格文档"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "codebook 也是 GEUL 文档。用 DECLARE·FIELD·ENUM·CODEC 四种 Edge 声明单个 Codec 的 Payload 构成，凭这一个文档同时完成验证·分解·显示。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Codec 如何构成 Payload，由 codebook 规定。GEUL 的 codebook 不是单独的格式，而是 **GEUL 文档**。一个 Codec 对应一个规格文档。

## 规格文档的位置

直接码的规格文档由 GEUL Issuer（`0x0000`）公布。文档 ID 是该 Codec 的 TAG WORD（只保留 Kind·Codec 位置，Length 为 0）扩展为 4 WORD 的值。

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | 规格文档 |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

解码器只看 TAG WORD 就能构造出规格文档的地址。遇到不认识的 Codec，获取并阅读该文档即可。

- `<TAG>` 是目标 TAG WORD 的 4 位 hex。Length 位置为 `0000`，Reference 的 Quantifier 位设为 `000`（LOCAL 是 `0008`）。
- Reference Codec `0000` 为保留，所以不存在目标 TAG WORD 为 `0x0000` 的规格文档。因此规格文档不会与 GEUL Issuer 的术语定义索引文档（文档 ID `0`，[Issuer 与公布](/zh/grammar/issuer/#术语定义文档)）重叠。Codec `0000` 的[占位标记](/zh/grammar/reference/slot-marker/)（`0x0000`~`0x0002`）也没有规格文档。它内置于解码器（[0 层](/zh/grammar/publishing/#层)）。
- 规格文档用 `DOC-ID` 放置 DOC-POINTER（`0x0000`、`0x000000000000<TAG>`、`0`）。版本列表记录也使用这个 DOC-POINTER。
- 规格文档也与其他文档一样，在 GEUL Issuer 的名称索引 `0x0000/documents.geul` 中绑定小写 slug 名称。例：`publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/`（[公布地址与版本列表](/zh/grammar/publishing/#文档名称)）。
- 版本·正本地址·签名规则与一般公布文档相同。

### GEUL Issuer 的文档 ID

| 文档 ID | 用途 |
|---|---|
| `0x0000000000000000` | 术语定义索引文档 |
| `0x00000000 0000xxxx` | Codec 规格文档。`xxxx` 是目标 TAG WORD |
| `0x0001xxxx xxxxxxxx` | geul.org 的术语定义文档。一个术语一个文档（[Issuer 与公布](/zh/grammar/issuer/#术语定义文档)） |

- `0x00000000 0000xxxx` 保留给 Codec 规格文档。GEUL Issuer 的其他文档（直接码不够用时设置的 GEUL 专属 ISSUER 格式的文档等）不使用这一区间。

### codebook 与规范版次

- codebook 文档不用 `IMPORT-DOC` 导入。文档 HEAD 的 [SPEC-VERSION](/zh/grammar/meta/declaration/spec-version/) 决定遵循哪个 codebook。
- 所有解码器都内置核心 codebook，或从这个地址获取。
- 提案（Prefix `000`）被采纳为标准时，布局保持不变，只把 Prefix 变为 `001`（[概述](/zh/grammar/overview/#领域结构)）。由于目标 TAG WORD 变了，采纳版成为文档 ID 不同的新规格文档，提案文档保持不变。

## 四个词汇

| Edge | Codec | 作用 |
|---|---|---|
| DECLARE | `0x1B` | 声明单个 Codec 的 Payload 构成。目标 TAG WORD 1 WORD |
| FIELD | `0x1C` | 一个 Payload 字段。所属 DECLARE 与宽度 |
| ENUM | `0x1D` | 给原始值字段的一个码值赋予含义 |
| CODEC | `0x1E` | 指定字段接受的一个 Kind·Codec |

- 四个 Edge 的布局内置于解码器（[0 层](/zh/grammar/publishing/#层)）。因为读取规格文档必须不依赖 codebook。读规格文档不需要其他规格文档。
- 名称（Codec 名称、字段名称、码值名称）全部用 BIND 绑定。

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (该字段所属的 DECLARE)
宽度              1 WORD: 0 = 记录, n = 原始值 n WORD, 0xFFFF = 其余原始值
```

- 指向同一 DECLARE 的 FIELD 们在**文档内的顺序**就是 Payload 字段顺序。
- 记录字段以 TAG WORD 开头，按其 Length 读取。
- 原始值字段是按固定 WORD 数读取的无符号整数。需要解读的值（符号·小数·日期等）不用原始值，而用 Value 记录。
- 其余原始值（`0xFFFF`）只能放一个，其后只能是固定宽度的原始值。
- Edge 的 Edge Id 不用 FIELD 声明。它是所有 Edge 的第一个元素，是隐含的。
- 依次读完字段后的位置，必须与记录末尾恰好吻合。

### CODEC

指定字段接受的格式。目标 WORD 直接使用 TAG WORD 的 Kind·Codec 位置。

| Length 位置 | 含义 | 例 |
|---|---|---|
| `0000` | 精确的 Codec | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | 通配符：为 0 的 Codec 位匹配任意值 | `0780` 任意 Reference, `0F80` 任意 Value, `07A0` Wikidata QID（不论量化） |

- 记录字段没有 CODEC 时接受任意记录（占位标记除外）。有一个以上时必须是其中之一（封闭列表）。
- 在原始值字段上放一个 CODEC，就把该原始值解读为没有 TAG 的那个 Value。

### 可选字段与占位标记

[占位标记](/zh/grammar/reference/slot-marker/)是保留 Reference Codec `0000` 的 1 WORD 记录组。只有字段的 CODEC 列表把该 WORD 作为精确目标时，才能出现在该位置。

| CODEC 目标 | 标记 | 该字段 |
|---|---|---|
| `0000` | ABSENT，未写 | 是**可选字段**。可以省略 |
| `0001` | UNKNOWN-VALUE，未知 | 接受"有值但不知道是什么"的断言 |
| `0002` | NO-VALUE，无 | 接受"没有值"的断言 |

- **接受规则：** 只有该字段的 CODEC 列表中把同一个 WORD 作为精确目标时，标记才有效。通配符（`0780`、`0781`、`0F80` …）和没有 CODEC 的字段（"任意记录"）不接受标记。在 HEAD·BODY 的记录位置、Edge Id 位置上 invalid。
- 省略可选字段时，在该位置写一个 WORD `0x0000`（ABSENT）。可选字段也始终占据位置。因此一条记录的写法只有一种，分解仅凭位置确定。
- 标记是保留的 Reference Codec，所以不会与其他记录重叠，不认识规格的解码器也把它当作 1 WORD 记录跳过。
- 三个标记表达不同的话。ABSENT 是关于文档的话（没有填这个位置），所以对世界不作任何断言。UNKNOWN-VALUE 是有值的断言（`∃x`），NO-VALUE 是没有值的断言（`¬∃x`，在限定条件内）。省略不是"没有值"，而是"未写"。
- 标记的含义由接受该标记的 Codec 规格规定（[TRIPLE](/zh/grammar/edge/triple/)、[QUALIFIER](/zh/grammar/edge/qualifier/)）。

## 示例：TRIPLE 规格文档

`0x0000/0x000000000000100A` 的 BODY。

| Edge | 内容 | 名称（BIND） |
|---|---|---|
| #1 DECLARE | 目标 `100A` | `TRIPLE` |
| #2 FIELD | #1 的字段，记录 | `predicate` |
| #3 FIELD | #1 的字段，记录 | `subject` |
| #4 FIELD | #1 的字段，记录 | `object` |
| #5 FIELD | #1 的字段，原始值 1 WORD | `rank` |
| #6~#8 ENUM | #5 的码值 0, 1, 2 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 按 UNSIGNED-INTEGER（`0802`）解读 | |
| #18, #19 CODEC | #4 是任意 Reference（`0780`）或任意 Value（`0F80`） | |
| #20, #21 CODEC | #4 也接受 UNKNOWN-VALUE（`0001`）、NO-VALUE（`0002`） | |

凭这一个文档，解码器就能把 TRIPLE 记录拆分为字段，附上字段名称显示，并检查格式是否正确。

## 示例：QUANTITY 规格文档

Value QUANTITY（`0806`）的四个字段全是记录。

| 字段 | CODEC |
|---|---|
| `amount` | `0810` SIGNED-DECIMAL |
| `unit` | `0780` 任意 Reference, `0000` 可选 |
| `lower` | `0810` SIGNED-DECIMAL, `0000` 可选 |
| `upper` | `0810` SIGNED-DECIMAL, `0000` 可选 |

## 规则

- 一个规格文档只有一个 DECLARE。DECLARE 的目标与文档 ID 的 TAG WORD 相同。
- 一个文档中不对同一目标声明两次。
- 字段构成不同的变体不作为分支使用。每个 Codec 分别声明。
- 不能声明有两个以上可变原始值、或原始值宽度随其他值而变化的布局。这类部分用记录包起来。
- 规格文档与其他文档一样以版本公布。但 Codec 的二进制布局不修订。要改变就分配新的 Codec。

## 未决问题

- 从 `SPEC-VERSION` 值（v1 是 `0x0001`）到 codebook 文档版本的对应。连接采纳版与提案版的谱系 Meta。
