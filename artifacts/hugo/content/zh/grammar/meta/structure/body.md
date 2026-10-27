---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY 是结束文档 HEAD 并开始 BODY 的 1 WORD 结构 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

结束 HEAD 并开始 BODY 的记录。

## 布局

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length 扩展 TAG]
```

- Codec：Meta `0x0E`，结构类（`000`）
- Payload：无（1 WORD）
- 数量：每个文档至多一个

## 解读与有效性

- HEAD 为空时省略。没有 `BODY` 的文档整体都是 BODY。HEAD 中有 Meta 或 HEAD Edge（整个文档的 [SOURCE](/zh/grammar/edge/source/#整个文档的来源) 及其 QUALIFIER）时必须放置。
- 没有 Payload。总长 1 WORD。

## 示例

- `0x180E`
