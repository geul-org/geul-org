---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE 是表明本版本文件是相对同一文档基准版本之 diff 的谱系 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

这是一个标记，表示本版本文件不是快照，而是相对同一文档基准版本的 **diff**（git packfile 的 delta）。版本本身仍以快照来定义。内容哈希、版本列表、签名都以应用 diff 还原出的快照为准（[diff 存储](/zh/grammar/document/#diff-存储)）。

## 布局

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
版本 ID           2 WORD unsigned (同一文档的基准版本)
```

- Codec：Meta `0x3A`，谱系类（`011`）
- Payload：2 WORD 版本 ID（原始值）
- 数量：至多一个

## 解读与有效性

- 只用于有 [DOC-ID](/zh/grammar/meta/declaration/doc-id/) 的文档（用版本列表管理版本的文档）。不做版本管理的 `versions.geul`·`documents.geul`·`issuers.geul` 以及无名文档不设 diff。
- 基准版本是同一 `DOC-ID` 的已公布版本，且早于本版本。`0`（无版本）无效。
- 还原出的快照的内容哈希必须与版本列表（[PUBLICATION](/zh/grammar/edge/publication/)）中本版本的哈希相同。不同则此 diff 无效。因此 diff 内不另写结果哈希。
- 只有 BODY 中所有记录都是 Edge（带 Edge Id 的记录）的文档才能存为 diff。因为 diff 的单位是 LOCAL ID（Edge Id）。
- 快照还原规则遵循 [diff 存储](/zh/grammar/document/#diff-存储)。删除由 [DELTA-REMOVE](/zh/grammar/meta/lineage/delta-remove/) 负责。
- 不另设添加·修订标记。diff BODY 的 Edge Id 在基准中已有则为修订，没有则为添加。添加从版本列表的 [NEXT-LOCAL-ID](/zh/grammar/meta/lineage/next-local-id/) 起取号。重新使用已删除的 LOCAL ID 则无效（[修订](/zh/grammar/document/#修订)）。

## 示例

相对基准版本 3 的 diff：

```
193A 0000 0003
```

- TAG `193A`（Meta `0x3A`，`LLLL=0010`，3 WORD），版本 ID `0000 0003`。

## 未决问题

1. 快照间隔：每隔多少版本放置一次完整快照（diff 链长度与还原成本）。
2. 是否把基准版本限定为上一个版本。
3. diff 文件的存放位置：是放在版本文件的位置（`<版本 ID>.geul`），还是与内容寻址存储库 `h/` 的关系（`h/` 通过快照的内容哈希查找）。
