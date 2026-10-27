---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE 是以带语言的文本记录变更原因的谱系 Meta（git commit message）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录变更原因（git commit message）。

## 布局

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length 扩展 TAG]
消息              UTF8-LANGUAGE-TEXT Value 1 个
```

- Codec：Meta `0x38`，谱系类（`011`）
- Payload：内置 Value（[UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)）
- 数量：每种语言至多一个

## 解读与有效性

- 消息与语言装在同一个 UTF8-LANGUAGE-TEXT 中。同一语言的 MESSAGE 只有一个。
- geul.org 规范文档用 [CODEC](/zh/grammar/edge/codec/) `084A`·`084B` 记录。
