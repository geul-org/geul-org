---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "关闭文档的记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `END`（规格文档 BIND `END`） |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| 规格文档 | `0x00000000/codecs/0x00001C40/`（DECLARE 对象 `1C40`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 4 |
| Kind | Meta · 类：结构 |
| TAG WORD | `0001 1100 0100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 1 WORD。关闭文档。 |
| Hugo 侧 | `meta/structure/end.md` |

## 字段（规格文档） {#필드-규격-문서}

规格文档中没有 FIELD。不声明 Payload 字段。

这是关闭文档的记录。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[Length 扩展 TAG]
```

- Codec：Meta `0x1C4L`，结构类
- Payload：无（1 WORD）
- 数量：每个文档一个，位于最后

## 解释与有效性 {#해석과-유효성}

- 必需。位置通过 [DOC](0x1C0L-doc-1word.md)（`DOC-*`）的长度确认。
- 输入在没有 END 的情况下结束，则为被截断的文档。截断文档的内容是否视为有效，由解码器策略决定。
- 其后不能再有任何内容。

## 示例 {#예시}

- `0x1C40`

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C40/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
