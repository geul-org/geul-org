---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL 是把 Subject 目标的一个分语言名称，以 UTF8-LANGUAGE-TEXT Object 连接的叙述 Edge（Codec 0x04）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL 是把 Subject 目标的一个特定语言名称（label）作为 Object 连接的叙述 Edge。Codec `0x04`。它不是表示一般词汇学 lemma 的 Edge。

名称及其语言放在一个 Object，即 [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/) 中。没有原始值字段。

## 布局

```
TAG WORD          0001 0LLL L000 0100
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            UTF8-LANGUAGE-TEXT Value 或 LOCAL Reference 记录 1 个
```

## 解读与有效性

- Subject 恰好是一个完整的 Reference 记录。靠 Subject 自身的 Length 找到边界，不是 Reference 或不完整则 invalid。
- Object 恰好是一个完整的 [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)（`0x4A`·`0x4B`）记录。语言和文本的规则（两种语言格式都允许，同语言比较）遵循该格式。
- Object 也可以是 LOCAL Reference。此时必须通过同一文档的 [REFERENCE-NODE](/zh/grammar/edge/reference-node/) 绑定解析为 UTF8-LANGUAGE-TEXT。无法解析，或解析为其他种类的目标，则 invalid。
- geul.org 规格文档用 [CODEC](/zh/grammar/edge/codec/) 来写这一限制（Object = `084A`·`084B`·`0008`）。LOCAL 的解析目标不用 CODEC 表示。
- Object 不是上述两种格式之一，或记录不完整，则 invalid。没有语言的文本（UTF8-TEXT）不能成为 LABEL。没有语言的机器用名称用 [BIND](/zh/grammar/edge/bind/) 来写。对多种语言通用的名称用语言 `mul` 来写。
- 同一 Subject·语言的 LABEL 至多一个。其他名称用 [ALIAS](/zh/grammar/edge/alias/) 来写。

## 长度

```
总计 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object 的语言记录和文本字节数由 Object 记录负责，而不是 Edge。读完最后一条记录的游标必须与 Edge 末尾恰好吻合。

## 示例（非规范）

`en` 的语言码因注册表尚未封版，所以 `0783` 不是确定的码，而是非规范值。

### LANGUAGE-SHORT-CODE

Edge Id `0007`，Subject Q22686（`00A0 589e`），Object `Donald Trump`（en）。

- Object 是语言 `08C8 0783`（SHORT-CODE 2 WORD）+ 文本 12 byte（偶数，6 WORD），所以是 `UTF8-LANGUAGE-TEXT-EVEN`（`0x4A`），共 9 WORD `0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70`。
- Edge 是 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD，`LLLL=1101`。TAG 是 `1684`。

```
1684 0088 0007 00A0 589e 0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`，Subject Q155（`00A0 009b`），Object `Brasil`（pt-BR）。

- Object 是语言 `09C7 7074 2d42 5200`（BCP47 `pt-BR`，4 WORD）+ 文本 6 byte（偶数，3 WORD），共 8 WORD `0BCA 09C7 7074 2d42 5200 4272 6173 696c`。
- Edge 是 TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD，`LLLL=1100`。TAG 是 `1604`。

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## 相关页面

- [Edge](/zh/grammar/edge/)、[ALIAS](/zh/grammar/edge/alias/)、[DESCRIPTION](/zh/grammar/edge/description/)、[BIND](/zh/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)、[LANGUAGE-SHORT-CODE](/zh/grammar/value/text/language-short-code/)、[LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/)
- [LOCAL](/zh/grammar/reference/local/)、[REFERENCE-NODE](/zh/grammar/edge/reference-node/)
