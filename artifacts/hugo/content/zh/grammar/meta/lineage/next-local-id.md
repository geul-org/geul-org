---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID 是在版本列表中记录文档下一个版本将分配给新叙述的 LOCAL ID 的谱系 Meta（auto increment）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录该文档下一个版本将分配给新叙述的 LOCAL ID（DBMS 的 auto increment，MySQL `AUTO_INCREMENT`）。文档任何版本中已分配的 LOCAL ID 都小于此值。

## 布局

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           下一个要分配的 LOCAL ID，最短宽度的 unsigned 整数
```

- Codec：Meta `0x3C`，谱系类（`011`）
- Payload：原始值（最短宽度的 unsigned 整数）
- 数量：至多一个
- 放置位置：版本列表文档 `versions.geul` 的 HEAD（[PUBLICATION](/zh/grammar/edge/publication/)）

## 解读与有效性

- LOCAL ID（包括 Edge Id）是跨版本的同一性（[修订](/zh/grammar/document/#修订)）。新叙述取得此值，随后此值加 1。已删除的 LOCAL ID 不再使用。因此即使持有最大值的叙述被删除，此值也不会减小。
- LOCAL ID `0` 不分配，所以初始值为 `1`。尚无版本时不放此 Meta，下一个编号为 `1`。
- 公布方公布版本时，在新的列表文档中更新记录。必须大于已公布版本中用过的任何 LOCAL ID。小于或等于则无效。
- 该值只增不减。小于上一个列表文档（[PARENT](/zh/grammar/meta/lineage/parent/)）的值则无效。
- 不做版本管理的文档（没有 `versions.geul` 的文档、无名文档）没有它。这类文档也不设 diff（[DELTA-BASE](/zh/grammar/meta/lineage/delta-base/)）。
- 不放在文档正文（版本文档）中。编号的记忆不是文档内容，而是延续撰写文档的公布方的状态（相当于 git 的 refs，而不是提交）。

## 示例

下一个分配编号 524：

```
18BC 020C
```

- TAG `18BC`（Meta `0x3C`，`LLLL=0001`，2 WORD），Payload `020C`。
