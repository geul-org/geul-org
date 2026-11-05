---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "结束 HEAD 并开始 BODY 的记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `BODY`（规格文档 BIND `BODY`） |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| 规格文档 | `0x00000000/codecs/0x00001C30/`（DECLARE 对象 `1C30`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 3 |
| Kind | Meta · 类：结构 |
| TAG WORD | `0001 1100 0011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 1 WORD。结束文档的 HEAD 并开始 BODY。 |
| Hugo 侧 | `meta/structure/body.md` |

## 字段（规格文档） {#필드-규격-문서}

规格文档中没有 FIELD。不声明 Payload 字段。

这是结束 HEAD 并开始 BODY 的记录。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[Length 扩展 TAG]
```

- Codec：Meta `0x1C3L`，结构类
- Payload：无（1 WORD）
- 数量：每个文档至多一个

## 解释与有效性 {#해석과-유효성}

- HEAD 为空时省略。没有 `BODY` 的文档整体都是 BODY。HEAD 中若有 Meta 或 HEAD Edge（针对整个文档的[SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)及其 QUALIFIER），则放置 BODY。
- 没有 Payload。总计 1 WORD。

## 示例 {#예시}

- `0x1C30`

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C30/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
