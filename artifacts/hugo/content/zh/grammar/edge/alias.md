---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS 是连接 Subject 目标的一个其他名称（别名）的叙述 Edge（Codec 0x05）。布局与 LABEL 相同。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS 是把 Subject 目标的一个其他名称（别名）作为 Object 连接的叙述 Edge。Codec `0x05`。

[LABEL](/zh/grammar/edge/label/) 是该语言的代表名称（每种语言至多一个），ALIAS 是同一目标的其他名称（每种语言可有多个，Wikidata 的 "also known as"）。主要用于搜索。布局和有效性与 LABEL 相同。

## 布局

```
TAG WORD          0001 0LLL L000 0101
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            UTF8-LANGUAGE-TEXT Value 或 LOCAL Reference 记录 1 个
```

## 解读与有效性

- Subject、Object 的规则与 [LABEL](/zh/grammar/edge/label/) 相同（Object 是 [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)，或解析为它的 LOCAL）。
- 同一 Subject·语言上可以放多个 ALIAS。顺序是文档内顺序。
- 不把与同一 Subject·语言的 LABEL 相同的文本作为 ALIAS 放置（代表名称用一个 LABEL 就够了）。此规则为建议。
- geul.org 规格文档把 Object 限定为 [CODEC](/zh/grammar/edge/codec/)（`084A`·`084B`·`0008`，与 LABEL 相同）。

## 示例（非规范）

Edge Id `0003`，Subject Q42（`00A0 002a`），Object `DNA`（en）：语言 `08C6 656e`（BCP47 `en`）+ 文本 3 byte（奇数）→ `UTF8-LANGUAGE-TEXT-ODD`（`0x4B`），`0A4B 08C6 656e 444e 4100`。

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD，`LLLL=1001`。TAG 是 `1485`。

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## 相关页面

- [Edge](/zh/grammar/edge/)、[LABEL](/zh/grammar/edge/label/)、[DESCRIPTION](/zh/grammar/edge/description/)、[UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)
