---
title: "Codec 规格文档"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Codec 如何构成 Payload，由 codebook 规定。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Codec 如何构成 Payload，由 codebook 规定。GEUL 的 codebook 不是单独的格式，而是 **GEUL 文档**。一个 Codec 对应一个规格文档。

## 规格文档的位置 {#규격-문서의-위치}

直接码的规格文档由 GEUL Issuer（`0x00000000`）公布。规格文档是 Codec 文档，没有文档 ID。Codec ID 是将该 Codec 的 TAG WORD（只保留章节和 `C` 的 Codec 位置，Length 为 0）写成 32 位的值。

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<版本 ID>.geul
```

| Codec | TAG | 规格文档 |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

解码器只看 TAG WORD 就能构造出规格文档的地址。遇到不认识的 Codec，获取并阅读该文档即可。

- `<TAG>` 是目标 TAG WORD 的 4 位十六进制（大写）。Length 位置为 `0000`。每个码对应一个 Codec 文档。Reference 5Q 体系也为每个量化码单独设置（LOCAL Identified `0050`，LOCAL Generic `0060`）。直接码和 Issuer Codec 使用同一个地址规则 `<Issuer>/codecs/<Codec ID>/`（[公布地址与版本列表](publishing.md#공표-주소)）。
- [占位标记](slot-marker.md)（`0x0000`、`0x0010`、`0x0020`）也设有规格文档。它没有 Payload，所以只有 DECLARE，没有 FIELD。标记的含义和接受规则内置于解码器（[第 0 层](publishing.md#층)）。尚未确定布局的 Codec 也从只含 DECLARE 的规格文档开始。
- 规格文档以 [CODEC-POINTER](reference/0x042L-codec-pointer.md)（`0x00000000`、`0x0000<TAG>`、`0`）作为 `DOC-ID`。版本列表记录也使用这个 CODEC-POINTER。
- 版本、正本地址和签名规则与一般的公布文档相同。

### codebook 与规范版本 {#코덱북과-명세-판}

- Codec 文档也可以通过 [IMPORT-DOC](meta/0x1E4L-import-doc.md) 导入。此时文档位置使用 [CODEC-POINTER](reference/0x042L-codec-pointer.md)，而不是 DOC-POINTER。文档 HEAD 的 [SPEC-VERSION](meta/0x1C5L-spec-version.md) 决定遵循哪个 codebook。
- 所有解码器都内置核心 codebook，或从这个地址获取。
- 提案（Prefix `000`）被采纳为标准时，布局保持不变，只把 Prefix 改为 `001`（[概览](_index.md#영역-구조)）。由于目标 TAG WORD 改变，采纳版成为另一个 Codec ID 的新规格文档，提案文档保持不可变。

## 四个词汇 {#네-어휘}

| Edge | Codec | 作用 |
|---|---|---|
| DECLARE | `0x0BBL` | 声明一个 Codec 的 Payload 构成。目标 TAG WORD 1 WORD |
| FIELD | `0x0BCL` | 一个 Payload 字段。所属 DECLARE 和宽度 |
| ENUM | `0x0BDL` | 为原始值字段的一个码值赋予含义 |
| CODEC | `0x0BEL` | 指定字段接受的一个 Kind·Codec |

- 四个 Edge 的布局内置于解码器（[第 0 层](publishing.md#층)）。因为读取规格文档时不能依赖 codebook。读取规格文档不需要其他规格文档。
- 名称（Codec 名称、字段名称、码值名称）一律用 BIND 绑定。

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (该字段所属的 DECLARE)
宽度              1 WORD: 0 = 记录, n = 原始值 n WORD, 0xFFFF = 剩余原始值
```

- 指向同一个 DECLARE 的 FIELD 在**文档中的顺序**就是 Payload 的字段顺序。
- 记录字段以 TAG WORD 开头，按其 Length 读取。
- 原始值字段是按固定 WORD 数读取的无符号整数。需要解释的值，如符号、小数、日期，不作为原始值，而作为 Value 记录。
- 剩余原始值（`0xFFFF`）只能设置一个，其后只能是固定宽度的原始值。
- Edge 的 Edge Id 不用 FIELD 声明。它是所有 Edge 的第一个元素，是隐含的。EDGE-ISSUER 是 Issuer·Codec 编号之后的第一个元素（[EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)）。
- 依次读完各字段后的位置必须与记录末尾恰好吻合。

### CODEC {#codec}

指定字段接受的格式。目标 WORD 直接使用 TAG WORD 的 Codec 位置（章节 `KKKK` 和 `C`）。

| Length 位置 | 含义 | 例 |
|---|---|---|
| `0000` | 精确的 Codec | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | 通配符：与 `C` 值无关，是该章节 `KKKK` 的全部（32 格）。建议使用章节第一格（`C = 0`） | `000F` 章节 0 全部, `060F` 章节 3 全部 |

- Kind 跨多个章节时，按章节逐一列出 CODEC。任意 Reference 是 `000F`·`020F`·`040F`，任意 Value 是 `060F`·`080F`。
- 量化无关或分组，则列出精确的 Codec。维基数据 QID（量化无关）是 `0140`、`0150`、`0160`、`0170`、`0180` 五个。

- 记录字段没有 CODEC 时，接受任意记录（占位标记除外）。有一个以上时，必须是其中之一（封闭列表）。
- 原始值字段设置一个 CODEC 时，将该原始值解释为不带 TAG 的该 Value。

### 可选字段与占位标记 {#선택-필드와-자리-표지}

[占位标记](slot-marker.md)是分配给 Reference 章节 0 前三格 `0x000L~0x002L` 的 1 WORD 记录分组。只有字段的 CODEC 列表将该 WORD 作为精确目标时，它才能出现在该位置。

| CODEC 目标 | 标记 | 该字段 |
|---|---|---|
| `0000` | ABSENT, 未填写 | 是**可选字段**。可以省略 |
| `0010` | UNKNOWN-VALUE, 未知 | 接受“有值但不知道是什么”的断言 |
| `0020` | NO-VALUE, 无 | 接受“没有值”的断言 |

- **接受规则：** 只有该字段的 CODEC 列表中以精确目标包含同一个 WORD 时，标记才有效。通配符（`000F`、`060F` ……）和没有 CODEC 的字段（“任意记录”）不接受标记。在 HEAD·BODY 记录位置和 Edge Id 位置，标记无效。
- 省略可选字段时，在该位置写一个 WORD `0x0000`（ABSENT）。可选字段也始终占据位置。因此一个记录的表示是唯一的，分解仅由位置决定。
- 标记拥有自己的 Reference 码，不与其他记录重叠，不了解规格的解码器也可以把它当作 1 WORD 记录跳过。
- 三个标记是不同的话语。ABSENT 是关于文档的话（没有填写这个位置），因此不对世界作任何断言。UNKNOWN-VALUE 是断言有值（`∃x`），NO-VALUE 是断言没有值（`¬∃x`，在限定条件之内）。省略不是“没有值”，而是“未填写”。
- 标记表示什么，由接受该标记的 Codec 规格决定（[TRIPLE](edge/0x0AAL-triple.md)、[QUALIFIER](edge/0x0ABL-qualifier.md)）。

## 例：TRIPLE 规格文档 {#예-triple-규격-문서}

这是 `0x00000000/codecs/0x00000AA0` 的 BODY。

| Edge | 内容 | 名称（BIND） |
|---|---|---|
| #1 DECLARE | 目标 `0AA0` | `TRIPLE` |
| #2 FIELD | #1 的字段，记录 | `predicate` |
| #3 FIELD | #1 的字段，记录 | `subject` |
| #4 FIELD | #1 的字段，记录 | `object` |
| #5 FIELD | #1 的字段，原始值 1 WORD | `rank` |
| #6~#8 ENUM | #5 的码值 0、1、2 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 解释为 UNSIGNED-INTEGER（`0620`） | |
| #18, #22, #23, #19, #24 CODEC | #4 为任意 Reference（`000F`·`020F`·`040F`）或任意 Value（`060F`·`080F`） | |
| #20, #21 CODEC | #4 也接受 UNKNOWN-VALUE（`0010`）、NO-VALUE（`0020`） | |
| #25~#27 CODEC | #2 为任意 Reference（`000F`·`020F`·`040F`） | |
| #28~#30 CODEC | #3 为任意 Reference（`000F`·`020F`·`040F`） | |

凭这一个文档，解码器就能把 TRIPLE 记录分解为字段，附上字段名称显示，并检查格式是否正确。

## 例：QUANTITY 规格文档 {#예-quantity-규격-문서}

Value QUANTITY（`0660`）的四个字段都是记录。

| 字段 | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT（仅有限值）, `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` 任意 Reference, `0000` 可选 |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690`（与 amount 相同）, `0000` 可选 |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690`（与 amount 相同）, `0000` 可选 |

## 规则 {#규칙}

- 一个规格文档只有一个 DECLARE。DECLARE 的目标与 Codec ID 的 TAG WORD 相同。
- 同一文档中不得两次声明同一目标。
- 字段构成不同的变体不用分支表示。每个 Codec 单独声明。
- 不能声明含有两个以上可变原始值，或原始值的宽度随其他值而变化的布局。这样的部分用记录包裹。
- 规格文档与其他文档一样按版本公布。但 Codec 的二进制布局不做修订。要改动就分配新的 Codec。

## 未决问题 {#열린-문제}

- 从 `SPEC-VERSION` 值（v1 为 `0x0001`）到 codebook 文档版本的对应。连接采纳版与提案版的谱系 Meta。
