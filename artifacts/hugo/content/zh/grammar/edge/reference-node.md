---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE 是把一个 Reference 绑定到一条 Object 记录，以定义该 Reference 是什么的有向叙述 Edge（Codec 0x00）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE 是把一个 Reference 连接到一条 Object 记录，以定义或绑定该 Reference 是什么的有向叙述 Edge。Codec `0x00`。

Subject 指示 Object。这种绑定不是在语义上主张同一性的 [SAME-NODE](/zh/grammar/edge/same-node/)，也不意味着两条记录的 byte 相同。

## 布局

```
TAG WORD          0001 0LLL L000 0000
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            Reference 或 Value 记录 1 个
```

## 解读与有效性

- Subject 必须恰好是一个完整的 [Reference](/zh/grammar/reference/) 记录。靠 Subject 自身的 Length 找到边界，不是 Reference 或不完整则 invalid。
- Object 必须恰好是一个完整的 Reference 或 Value 记录。靠 Object 自身的 Length 找到边界，是 Edge·Meta 或不完整则 invalid。
- 如果 Object 是 Reference，则沿 REFERENCE-NODE 绑定追踪的 Reference 链不得循环，LOCAL 最终必须被解析。解析循环和悬空 LOCAL 是 invalid。
- 在同一文档中，一个 LOCAL ID 被绑定到相互冲突的 Object 则 invalid。LOCAL 的范围、ID、最小宽度和合并规则遵循 [LOCAL](/zh/grammar/reference/local/)。
- 并非所有 Reference 都必须用 REFERENCE-NODE 绑定。
- 代表性用法是 `LOCAL → UTF8-LANGUAGE-TEXT`。当 [LABEL](/zh/grammar/edge/label/) 的 Object 放了 LOCAL 时，通过同一文档的这个绑定来解析文本。

不得把 Subject 指示 Object 的方向反过来解读。SAME 和 DIFFERENT 的含义和细则由各自的格式另行规定。

## 长度

```
总计 = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` 是 Length 扩展 TAG WORD 数，`N_id` 是 Edge Id LOCAL 记录的 WORD 数，`N_subject`·`N_object` 是各记录的总 WORD 数。读完 Subject 和 Object 后的游标必须与 Edge 末尾恰好吻合。

## 示例（非规范）

Edge Id `0008`，Subject 是 LOCAL 1，Object 是 `Donald Trump`（en）的 [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)。

- Edge Id 是 `0088 0008`，2 WORD。
- Subject 是 `0088 0001`，2 WORD。
- Object 是语言 `08C6 656e`（BCP47 `en`）+ 文本 12 byte（偶数），所以是 `UTF8-LANGUAGE-TEXT-EVEN`（`0x4A`），共 9 WORD。TAG 是 `0C4A`。
- Edge 是 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD，`LLLL=1101`。TAG 是 `1680`。

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## 相关页面

- [Edge](/zh/grammar/edge/)、[SAME-NODE](/zh/grammar/edge/same-node/)、[DIFFERENT-NODE](/zh/grammar/edge/different-node/)、[LABEL](/zh/grammar/edge/label/)
- [Reference](/zh/grammar/reference/)、[LOCAL](/zh/grammar/reference/local/)、[UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)
