---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM 是为原始值字段的某个码值附加含义的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `ENUM`（规格文档 BIND `ENUM`） |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| 规格文档 | `0x00000000/codecs/0x00000BD0/`（DECLARE 目标 `0BD0`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 29 |
| Kind | Edge · 系列：陈述，分组：其他 |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 原始值字段的一个码值。字段、码值 |
| Hugo 侧 | `edge/enum.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | 记录 | `0050` LOCAL |  |
| 2 | `code` | #3 | 剩余原始值（`0xFFFF`） |  |  |

ENUM 是为原始值字段的某个码值附加含义的陈述 Edge。Codec `0x0BDL`。

它与 [FIELD](0x0BCL-field.md) 一起，是编写 Codec 规格所用的词汇。布局内置于解码器（[Codec 规格文档](../codec-spec.md)）。

## 布局 {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
字段              指向 FIELD Edge 的 LOCAL Reference 记录
码值              原始值。与该 FIELD 宽度相同的 WORD 数
```

## 解释与有效性 {#해석과-유효성}

- 字段必须是原始值 FIELD（宽度 `n ≥ 1`）。不给记录字段附加 ENUM。记录的含义由该记录的 Codec 说明。
- 码值恰好是该 FIELD 的宽度。用 ENUM 记录的 Length 确认边界。
- 同一字段中不对同一码值声明两次。
- 码值的名称用 [BIND](0x0A3L-bind.md) 绑定到 ENUM 的 Edge Id。附在 DECLARE·FIELD·ENUM·CODEC 上的 UTF8-TEXT 全都用 BIND，不用 LABEL 等其他 Edge 附加。
- 未声明的码值不是错误。查看器按原始值原样显示。是否封闭允许值是 Codec 规格的事，目前的词汇中没有封闭的标示。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_field + n WORD
```

## 示例（非规范） {#예시-비규범}

在 TOMBSTONE 规格文档的理由类别字段（FIELD #4，原始值 1 WORD）上声明码 `0x0001`。Edge Id 10。名称另用 BIND 绑定。理由类别码表尚未确定，所以码值只是示例。

- TAG 1 + Edge Id 2 + 字段 2 + 码值 1 = 6 WORD，`LLLL = 0101`。

```
0BD5 0051 000A 0051 0004 0001
```

TRIPLE 规格文档在 Rank 字段（FIELD #5）上放了三个 ENUM（`0`·`1`·`2`），并分别 BIND 为 `normal`·`preferred`·`deprecated`（[TRIPLE](0x0AAL-triple.md)）。

## 相关页面 {#관련-페이지}

- [DECLARE](0x0BBL-declare.md)、[FIELD](0x0BCL-field.md)、[CODEC](0x0BEL-codec.md)、[BIND](0x0A3L-bind.md)
- [Codec 规格文档](../codec-spec.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000BD0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
