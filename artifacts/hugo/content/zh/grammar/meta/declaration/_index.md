---
title: "Meta — 定义"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Meta 定义类（高 3 位 `001`，`0x10`~`0x1F`）是解读声明。规定规范版本、Profile、文档 ID、生效期间、默认语言。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 定义类（高 3 位 `001`，Codec `0x10`~`0x1F`）是解读声明。声明会改变解读规则，因此所有解码器都必须处理。声明的范围是该文档。

- `SPEC-VERSION` 决定如何读取其余记录，所以不使用内置 Value，只放整数。GEUL v1 为 `0x0001`（记录 `1890 0001`）。
- `DOC-ID` 是指向该文档自身的 `DOC-POINTER`（Issuer、文档 ID、版本 `0`）。没有它则为无名文档，只能通过内容哈希指向。
- 文档的寻址名称不作为 Meta 放置。由 Issuer 的名称索引 `documents.geul` 以叙述性 `BIND` 附加，人可读的标题以 `LABEL` 附加（[公布地址与版本列表](/zh/grammar/publishing/#文档名称)）。
