---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE 是以语言 Value 声明文档文本默认语言的定义 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

声明文档文本的默认语言。未单独标明语言的文本即为该语言。

## 布局

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length 扩展 TAG]
Payload           一个语言 Value
```

- Codec：Meta `0x16`，定义类（`001`）
- Payload：内置 Value（[LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/) 或 [LANGUAGE-SHORT-CODE](/zh/grammar/value/text/language-short-code/)）
- 数量：至多一个

## 解读与有效性

- TANGEUL 文档记录撰写时的语言区域（例：`en`、`ko`）。

## 示例

- `en`：`0x1916 0x08C6 0x656E`
