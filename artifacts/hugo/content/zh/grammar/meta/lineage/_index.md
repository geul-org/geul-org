---
title: "Meta — 谱系"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Meta 谱系类（高 3 位 `011`，`0x30`~`0x3F`）以 git 提交模型记录文档从什么、如何而来。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 谱系类（高 3 位 `011`，Codec `0x30`~`0x3F`）记录文档从什么、如何而来。谱系遵循 git 的提交模型，相当于提交的单位是文档。

- **内容哈希**指向一整份文档的内容（git commit id）。它是从开启记录（`DOC-*`）到 `END` 之前的 SHA-256，验证类（`100`）记录不参与计算。
- **版本 ID** 是在有名称的文档内按公布顺序从 1 起编的 2 WORD 整数。`0` 表示未写明版本。
- 谱系 Meta 通过内容哈希指向版本。文档内的 `PARENT` 也计入哈希，所以内容哈希成为贯穿全部历史的哈希链。
- 历史不删除。修改的内容以新版本发布。像 branch 这样会变化的指针不放在文档中。
- `DELTA-BASE`·`DELTA-REMOVE` 是把版本存为相对基准版本的 diff 的格式。版本始终以快照来定义。

修订规则见[文档](/zh/grammar/document/)。
