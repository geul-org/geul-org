---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "记录更改的理由（git commit message）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `MESSAGE`（规格文档 BIND `MESSAGE`） |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| 规格文档 | `0x00000000/codecs/0x00001D90/`（DECLARE 对象 `1D90`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 25 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 1001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 更改理由。UTF8-LANGUAGE-TEXT Value，每种语言一个（git commit message） |
| Hugo 侧 | `meta/lineage/message.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | 记录 | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

记录更改的理由（git commit message）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[Length 扩展 TAG]
消息              1 个 UTF8-LANGUAGE-TEXT Value
```

- Codec：Meta `0x1D9L`，谱系类
- Payload：内置 Value（[UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)）
- 数量：每种语言至多一个

## 解释与有效性 {#해석과-유효성}

- 消息与语言装在一个 UTF8-LANGUAGE-TEXT 中。同一语言的 MESSAGE 只有一个。
- geul.org 规格文档用 [CODEC](../edge/0x0BEL-codec.md) `0780`·`0790` 记述。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001D90/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
