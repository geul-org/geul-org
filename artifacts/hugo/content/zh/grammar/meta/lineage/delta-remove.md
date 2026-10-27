---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE 是在 diff 中记录要从基准快照 BODY 中去除的 LOCAL ID（Edge Id）列表的谱系 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

在 diff（[DELTA-BASE](/zh/grammar/meta/lineage/delta-base/)）中，记录要从基准快照 BODY 中去除的记录的 LOCAL ID（Edge Id）（"删除第 X 条"）。

## 布局

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length 扩展 TAG]
要删除的 LOCAL ID  LOCAL Reference 记录 × 1 个以上
```

- Codec：Meta `0x3B`，谱系类（`011`）
- Payload：一个以上 [LOCAL](/zh/grammar/reference/local/) Reference 记录
- 数量：至多一个

## 解读与有效性

- 只放在有 `DELTA-BASE` 的文档中。
- 每个 LOCAL ID 必须是基准快照 BODY 中存在的 Edge Id。没有则无效。同一 ID 出现两次则无效。
- 在同一 diff 的 BODY 中再次放置相同的 Edge Id 则无效（不能同时删除和修订）。
- 已删除的 LOCAL ID 在之后的版本中不再分配给其他目标（[修订](/zh/grammar/document/#修订)）。
- diff BODY 中没有记录意味着"未变化"。因此删除只能用此 Meta 表达。
- 不写 HEAD Edge（整个文档的 [SOURCE](/zh/grammar/edge/source/#整个文档的来源) 及其 QUALIFIER）。HEAD 会整体被 diff 的 HEAD 替换（[diff 存储](/zh/grammar/document/#diff-存储)）。

## 示例

删除 LOCAL `#7` 和 `#12`：

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B`（Meta `0x3B`，`LLLL=0100`，5 WORD），LOCAL Reference `0088 0007`、`0088 000C`。
