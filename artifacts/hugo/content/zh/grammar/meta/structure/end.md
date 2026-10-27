---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END 是关闭文档的 1 WORD 结构 Meta。所有文档都必须有。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

关闭文档的记录。

## 布局

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length 扩展 TAG]
```

- Codec：Meta `0x0F`，结构类（`000`）
- Payload：无（1 WORD）
- 数量：每个文档一个，位于最末

## 解读与有效性

- 必须有。位置通过 [DOC](/zh/grammar/meta/structure/doc/)（`DOC-*`）的长度确认。
- 输入在没有 END 的情况下结束，则为被截断的文档。是否将被截断文档的内容视为有效，由解码器策略决定。
- 其后不再有任何内容。

## 示例

- `0x180F`
