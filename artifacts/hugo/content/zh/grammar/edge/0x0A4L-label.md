---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL 是把 Subject 对象的某一语言名称（label）作为 Object 连接起来的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `LABEL`（规格文档 BIND `LABEL`） |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| 规格文档 | `0x00000000/codecs/0x00000A40/`（DECLARE 目标 `0A40`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 4 |
| Kind | Edge · 系列：陈述，分组：指示与名称 |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 连接 Subject 的语言名称（label）。Object 是 UTF8-LANGUAGE-TEXT |
| Hugo 侧 | `edge/label.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `object` | #3 | 记录 | `0780` UTF8-LANGUAGE-TEXT，`0790` UTF8-LANGUAGE-TEXT，`0050` LOCAL |  |

LABEL 是把 Subject 对象的某一语言名称（label）作为 Object 连接起来的陈述 Edge。Codec `0x0A4L`。它不是表示一般词汇学中 lemma 的 Edge。

名称及其语言装在一个 Object，即 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) 里。没有原始值字段。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            UTF8-LANGUAGE-TEXT Value 或 LOCAL Reference 记录 1 个
```

## 解释与有效性 {#해석과-유효성}

- Subject 是恰好一条完整的 Reference 记录。依靠 Subject 自身的 Length 找到边界，不是 Reference 或不完整则为 invalid。
- Object 是恰好一条完整的 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)（`0x078L`·`0x079L`）记录。语言与文本的规则（两种语言格式均允许，同语言比较）遵循该格式。
- Object 也可以是 LOCAL Reference。此时必须通过同一文档的 [REFERENCE-NODE](0x0A0L-reference-node.md) 绑定解析为 UTF8-LANGUAGE-TEXT。无法解析或解析为其他种类的对象则为 invalid。
- geul.org 规格文档用 [CODEC](0x0BEL-codec.md) 书写这一限制（Object = `0780`·`0790`·`0050`）。LOCAL 的解析目标不用 CODEC 表示。
- Object 不是上述两种格式之一，或记录不完整，则为 invalid。没有语言的文本（UTF8-TEXT）不能成为 LABEL。没有语言的机器用名称用 [BIND](0x0A3L-bind.md) 书写。多种语言通用的名称用语言 `mul` 书写。
- 同一 Subject、同一语言的 LABEL 至多一个。其他名称用 [ALIAS](0x0A5L-alias.md) 书写。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object 的语言记录和文本字节数由 Object 记录负责，而不是 Edge。读完最后一条记录后的游标必须与 Edge 末尾恰好吻合。

## 示例（非规范） {#예시-비규범}

`en` 的语言码 `0784` 是 GEUL Language Registry v2（规格文档 `0x00000000/codecs/0x000007A0` 版本 2）的编号。

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`，Subject Q22686（`0141 589E`），Object `Donald Trump`（en）。

- Object 为语言 `07A1 0784`（SHORT-CODE 2 WORD）+ 文本 12 byte（偶数，6 WORD），即 `UTF8-LANGUAGE-TEXT-EVEN`（`0x078L`），总共 9 WORD `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`。
- Edge 为 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD，`LLLL=1101`。TAG 为 `0A4D`。

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`，Subject Q155（`0141 009B`），Object `Brasil`（pt-BR）。

- Object 为语言 `0773 7074 2D42 5200`（BCP47 `pt-BR`，4 WORD）+ 文本 6 byte（偶数，3 WORD），总共 8 WORD `0787 0773 7074 2D42 5200 4272 6173 696C`。
- Edge 为 TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD，`LLLL=1100`。TAG 为 `0A4C`。

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[ALIAS](0x0A5L-alias.md)、[DESCRIPTION](0x0A6L-description.md)、[BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)、[LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)、[LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md)、[REFERENCE-NODE](0x0A0L-reference-node.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A40/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
