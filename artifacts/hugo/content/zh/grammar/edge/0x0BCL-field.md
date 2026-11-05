---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD 是声明 Codec Payload 中一个字段的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `FIELD`（规格文档 BIND `FIELD`） |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| 规格文档 | `0x00000000/codecs/0x00000BC0/`（DECLARE 目标 `0BC0`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 28 |
| Kind | Edge · 系列：陈述，分组：其他 |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 一个 Payload 字段。所属 DECLARE，宽度：记录（TAG 的 Length）或原始值 n WORD |
| Hugo 侧 | `edge/field.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | 记录 | `0050` LOCAL |  |
| 2 | `width` | #3 | 原始值 1 WORD |  | `0x0000` record，`0xFFFF` rest |

FIELD 是声明 Codec Payload 中一个字段的陈述 Edge。Codec `0x0BCL`。

FIELD 指向自己的 [DECLARE](0x0BBL-declare.md)。指向同一个 DECLARE 的各 FIELD 按文档内顺序构成 Payload。布局内置于解码器（[Codec 规格文档](../codec-spec.md)）。

## 布局 {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           LOCAL Reference 记录
DECLARE           LOCAL Reference 记录。该字段所属的 DECLARE Edge
宽度              1 WORD。0 = 记录，n (1~65534) = 原始值 n WORD，0xFFFF = 剩余原始值
```

## 解释与有效性 {#해석과-유효성}

- DECLARE 指向同一文档的 DECLARE Edge。一个 FIELD 只属于一个 DECLARE。顺序不另行记载，就是 FIELD 记录在文档中的排列顺序。
- FIELD 规格文档把 DECLARE 声明为宽度 `0`（记录）、CODEC `0050`（LOCAL）的字段。因此在查看器图中，FIELD → DECLARE 的连接会被绘出。
- 宽度 `0` 是记录字段。以 TAG WORD 开头，按该 TAG 的 Length 读取（[DECLARE](0x0BBL-declare.md) 解释规则）。
- 宽度 `n`（1~65534）是原始值字段。始终恰好是 n WORD。
- 宽度 `0xFFFF` 是剩余原始值。DECLARE 中只放一个，前、中、末任何位置均可。宽度是外层记录的 TAG Length 所决定的剩余 WORD 减去后面各字段宽度的值。因此剩余字段之后的字段必须全都是固定宽度的原始值（记录必须从前往后读才知道结尾）。可以是 0 WORD。不附加 ENUM。
- 字段所接受的 Kind·Codec 用 [CODEC](0x0BEL-codec.md) 指定。记录字段没有 CODEC 时接受任意记录，有 CODEC 时必须是其中之一。给原始值字段放一个 CODEC，则把该原始值解释为去掉 TAG 的那个 Value。
- 字段名称用 [BIND](0x0A3L-bind.md) 绑定到 FIELD 的 Edge Id（例：`doc`、`hash`）。附在 DECLARE·FIELD·ENUM·CODEC 上的 UTF8-TEXT 全都用 BIND，不用 LABEL 等其他 Edge 附加。
- 原始值字段的码值含义用 [ENUM](0x0BDL-enum.md) 附加。
- 图中指向其他节点的字段不另行标示。记录字段若是 Reference，那就是连接。

## 长度 {#길이}

```
全部 = 1 + 2 + 2 + 1 WORD   (Edge Id·DECLARE 为 LOCAL 1 WORD ID 时)
```

## 示例（非规范） {#예시-비규범}

- 记录字段：Edge Id 7，DECLARE #1，宽度 `0`。TAG 1 + Edge Id 2 + DECLARE 2 + 宽度 1 = 6 WORD。若要只接受 LOCAL，见 [CODEC](0x0BEL-codec.md) 示例。

```
0BC5 0051 0007 0051 0001 0000
```

- 内容哈希这类原始值字段，见 [DECLARE](0x0BBL-declare.md) 示例。

## 相关页面 {#관련-페이지}

- [DECLARE](0x0BBL-declare.md)、[ENUM](0x0BDL-enum.md)、[CODEC](0x0BEL-codec.md)、[BIND](0x0A3L-bind.md)
- [Codec 规格文档](../codec-spec.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000BC0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
