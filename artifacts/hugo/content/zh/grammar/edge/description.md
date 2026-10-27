---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION 是连接 Subject 目标的一个分语言简短说明的叙述 Edge（Codec 0x06）。布局与 LABEL 相同。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION 是把 Subject 目标的一个特定语言说明作为 Object 连接的叙述 Edge。Codec `0x06`。

说明是用来区分目标的简短语句（Wikidata description，例："德国的首都和最大城市"）。它不是目标的定义或主张。关于目标的命题用 [TRIPLE](/zh/grammar/edge/triple/) 来写。布局与 [LABEL](/zh/grammar/edge/label/) 相同。说明及其语言放在一个 Object，即 [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/) 中。没有原始值字段。

## 布局

```
TAG WORD          0001 0LLL L000 0110
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            UTF8-LANGUAGE-TEXT Value 或 LOCAL Reference 记录 1 个
```

## 解读与有效性

- Subject 和 Object 的规则与 [LABEL](/zh/grammar/edge/label/) 相同。Subject 恰好是一个完整的 Reference 记录。Object 恰好是一个完整的 UTF8-LANGUAGE-TEXT（`0x4A`·`0x4B`）记录，或者是通过同一文档的 [REFERENCE-NODE](/zh/grammar/edge/reference-node/) 绑定解析为 UTF8-LANGUAGE-TEXT 的 LOCAL Reference。
- 没有语言的文本（UTF8-TEXT）不能成为 DESCRIPTION。说明每种语言一个，有了语言这条规则才成立。对多种语言通用的说明用语言 `mul` 来写。
- 同一 Subject·语言的 DESCRIPTION 至多一个。
- 说明用来与同名的其他目标区分。同一语言中，LABEL 与 DESCRIPTION 的组合最好不要在两个目标上重复，但规格不检查这一点（Wikidata 也只是建议而不强制）。
- geul.org 规格文档把 Object 限定为 [CODEC](/zh/grammar/edge/codec/)（`084A`·`084B`·`0008`，与 LABEL 相同）。

## 长度

```
总计 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object 的语言记录和文本字节数由 Object 记录负责。读完最后一条记录的游标必须与 Edge 末尾恰好吻合。
- 说明比 label 长，Object 和 Edge 都容易超过 15 WORD。此时使用 Length 扩展（[记录](/zh/grammar/record/)）。

## 示例（非规范）

Edge Id `0009`，Subject Q64（`00A0 0040`），Object `capital and largest city of Germany`（en）。语言因为在注册表之前，所以是 LANGUAGE-BCP47-CODE。

- Object 是语言 `08C6 656E`（BCP47 `en`，2 WORD）+ 文本 35 byte（奇数，18 WORD），所以是 `0x4B`，TAG 1 + 扩展 TAG 1 + 20 = 22 WORD，`0F4B 0016 …`。
- Edge 是 TAG 1 + 扩展 TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD，所以 `LLLL=1110`，TAG `1706`，扩展 TAG `001C`。

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## 与 Wikidata 的对应

- 条目的 `descriptions`（每种语言一个）→ 每种语言一个 DESCRIPTION。语言码按与 LABEL 相同的语言码对应表转换。

## 未决问题

- 是否存在应当允许没有语言的 UTF8-TEXT 说明的情形（目前不允许）。

## 相关页面

- [Edge](/zh/grammar/edge/)、[LABEL](/zh/grammar/edge/label/)、[ALIAS](/zh/grammar/edge/alias/)、[CODEC](/zh/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)、[LOCAL](/zh/grammar/reference/local/)、[REFERENCE-NODE](/zh/grammar/edge/reference-node/)
