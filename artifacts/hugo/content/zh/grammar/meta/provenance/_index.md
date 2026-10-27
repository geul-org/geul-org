---
title: "Meta — 出处"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Meta 出处类（高 3 位 `010`，`0x20`~`0x2F`）记录文档由谁、何时创作和记录。来源资料用依据 Edge SOURCE 来写。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Meta 出处类（高 3 位 `010`，Codec `0x20`~`0x2F`）记录文档由谁、何时创作和记录。

- 作者·记录者及其时刻遵循 git 的 author·committer 模型（`AUTHOR`·`CREATED-AT`，`RECORDED-BY`·`RECORDED-AT`）。
- 删除出处不会改变叙述内容，只是丢失信任判断的素材。
- 来源资料不在本类中。整个文档的来源放在 HEAD 中，单条记录的来源放在 BODY 中，都用依据 Edge [SOURCE](/zh/grammar/edge/source/) 来写。原文中的对应范围、获取时刻、原文哈希是附在该 SOURCE 上的 QUALIFIER（页 P304·节 P958，查阅日 P813，校验和 P4092）。
- 如果把来源的属性（原文范围、获取时刻）做成 Meta，来源有多个时就无法确定它属于哪个来源。因此用以 SOURCE 为 Target 的 QUALIFIER 来写。Codec `0x26`~`0x2F` 为保留。
