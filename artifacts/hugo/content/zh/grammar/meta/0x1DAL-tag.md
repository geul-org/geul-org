---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "记录附加在版本上的不可变名称（git annotated tag）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `TAG`（规格文档 BIND `TAG`） |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| 规格文档 | `0x00000000/codecs/0x00001DA0/`（DECLARE 对象 `1DA0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 26 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 1010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 附加在版本上的不可变名称。TEXT Value 与内容哈希（git annotated tag） |
| Hugo 侧 | `meta/lineage/tag.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | 记录 | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | 记录 | `07C0` SHA-256-DIGEST, `0000` ABSENT（可选字段） |  |

记录附加在版本上的不可变名称（git annotated tag）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[Length 扩展 TAG]
名称              UTF8-TEXT-* Value
对象              SHA-256-DIGEST Value，或省略标记 0x0000（可选字段）。省略则为本版本
```

- Codec：Meta `0x1DAL`，谱系类
- Payload：内置 Value（文本 + 可选的内容哈希）
- 数量：可有多个

## 解释与有效性 {#해석과-유효성}

- 名称是 [UTF8-TEXT](../value/0x072L-utf8-text.md)，对象是 [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)。
- 省略对象时（ABSENT `0x0000`，[CODEC](../edge/0x0BEL-codec.md) 可选字段），则是附加在本文档自身上的名称。自身的内容哈希无法写在自身之中。geul.org 规格 `0x1DA0` 是 name（`0720`·`0730`）与 target（`07C0`·`0000`）两个记录字段。
- 同一名称不再用于其他版本。

## 示例 {#예시}

- 名称 `v1`，本版本：`1DA3 0721 7631 0000`

## 未决问题 {#열린-문제}

- 已有版本 ID（序号）的情况下，是否仍需要 TAG。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001DA0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
