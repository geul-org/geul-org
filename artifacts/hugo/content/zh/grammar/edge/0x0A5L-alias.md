---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS 是把 Subject 对象的另一个名称（别名）作为 Object 连接起来的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `ALIAS`（规格文档 BIND `ALIAS`） |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| 规格文档 | `0x00000000/codecs/0x00000A50/`（DECLARE 目标 `0A50`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 5 |
| Kind | Edge · 系列：陈述，分组：指示与名称 |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 连接 Subject 的其他名称（别名）。布局与 LABEL 相同 |
| Hugo 侧 | `edge/alias.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `object` | #3 | 记录 | `0780` UTF8-LANGUAGE-TEXT，`0790` UTF8-LANGUAGE-TEXT，`0050` LOCAL |  |

ALIAS 是把 Subject 对象的另一个名称（别名）作为 Object 连接起来的陈述 Edge。Codec `0x0A5L`。

[LABEL](0x0A4L-label.md) 是该语言的代表名称（每种语言至多一个），ALIAS 是同一对象的其他名称（每种语言可有多个，维基数据 "also known as"）。主要用于检索。布局和有效性与 LABEL 相同。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            UTF8-LANGUAGE-TEXT Value 或 LOCAL Reference 记录 1 个
```

## 解释与有效性 {#해석과-유효성}

- Subject、Object 的规则与 [LABEL](0x0A4L-label.md) 相同（Object 是 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) 或解析为它的 LOCAL）。
- 同一 Subject、同一语言可以放多个 ALIAS。顺序就是文档内的顺序。
- 不把与同一 Subject、同一语言的 LABEL 文本相同的内容放作 ALIAS（代表名称有一个 LABEL 就够了）。这条规则是建议。
- geul.org 规格文档用 [CODEC](0x0BEL-codec.md) 限制 Object（`0780`·`0790`·`0050`，与 LABEL 相同）。

## 示例（非规范） {#예시-비규범}

Edge Id `0003`，Subject Q42（`0141 002A`），Object `DNA`（en）：语言 `0761 656E`（BCP47 `en`）+ 文本 3 byte（奇数）→ `UTF8-LANGUAGE-TEXT-ODD`（`0x079L`），`0794 0761 656E 444E 4100`。

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD，`LLLL=1001`。TAG 为 `0A59`。

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[LABEL](0x0A4L-label.md)、[DESCRIPTION](0x0A6L-description.md)、[UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A50/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
