---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "记录该文档的下一版本要分配给新陈述的 LOCAL ID（DBMS 的 auto increment、MySQL AUTO_INCREMENT）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `NEXT-LOCAL-ID`（规格文档 BIND `NEXT-LOCAL-ID`） |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| 规格文档 | `0x00000000/codecs/0x00001DD0/`（DECLARE 对象 `1DD0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 29 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 1101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 下一个要分配的 LOCAL ID（auto increment）。放在版本列表 `versions.geul` 的 HEAD 中 |
| Hugo 侧 | `meta/lineage/next-local-id.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | 剩余原始值（`0xFFFF`） |  |  |

记录该文档的下一版本要分配给新陈述的 LOCAL ID（DBMS 的 auto increment、MySQL `AUTO_INCREMENT`）。文档在任何版本中已分配的 LOCAL ID 都小于该值。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           下一个要分配的 LOCAL ID，最短宽度的 unsigned 整数
```

- Codec：Meta `0x1DDL`，谱系类
- Payload：原始值（最短宽度的 unsigned 整数）
- 数量：至多一个
- 放置位置：版本列表文档 `versions.geul` 的 HEAD（[PUBLICATION](../edge/0x0B8L-publication.md)）

## 解释与有效性 {#해석과-유효성}

- LOCAL ID（含 Edge Id）是跨越版本的身份（[修订](../document.md#개정)）。新陈述取得该值，该值加 1。已删除的 LOCAL ID 不再使用。因此即使拥有最大值的陈述被删除，该值也不会减小。
- LOCAL ID `0` 不分配，因此初始值为 `1`。尚无版本时不放置该 Meta，下一个编号为 `1`。
- 公布方公布版本时，在新的列表文档中更新记录。必须大于所公布版本中用到的任何 LOCAL ID。小于或等于则为 invalid。
- 该值只增不减。小于上一个列表文档（[PARENT](0x1D1L-parent.md)）的值则为 invalid。
- 不做版本管理的文档（没有 `versions.geul` 的文档、无名文档）中没有它。这类文档也不设 diff（[DELTA-BASE](0x1DBL-delta-base.md)）。
- 不放在文档正文（版本文档）中。编号的记忆不是文档内容，而是延续撰写文档的公布方的状态（相当于 git 的 refs，而非提交）。

## 示例 {#예시}

下一个分配编号 524：

```
1DD1 020C
```

- TAG `1DD1`（Meta `0x1DDL`，`LLLL=0001`，2 WORD），Payload `020C`。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001DD0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
