---
title: "DOC-1WORD (0x1C0L)"
weight: 448
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD、DOC-2WORD、DOC-4WORD 是通过指定文档的总 WORD 数来开启文档的结构 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD、DOC-2WORD、DOC-4WORD 是通过指定文档的总 WORD 数来开启文档的结构 Meta。

| 项目 | 值 |
|---|---|
| 名称 | `DOC-1WORD`（规格文档 BIND `DOC-1WORD`） |
| TAG ID | `0x1C0L` |
| Codec ID | `0x00001C00` |
| 规格文档 | `0x00000000/codecs/0x00001C00/`（DECLARE 对象 `1C00`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 0 |
| Kind | Meta · 类：结构 |
| TAG WORD | `0001 1100 0000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 在 Payload 的 1 WORD 中指定总长度的文档开头 |
| Hugo 侧 | `meta/structure/doc.md`（该侧同时说明 [DOC-2WORD](0x1C1L-doc-2word.md)、[DOC-4WORD](0x1C2L-doc-4word.md)） |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | 原始值 1 WORD |  |  |

这是开启文档的记录。在 Payload 中指定文档的总 WORD 数。`DOC-1WORD`（`0x1C0L`）、`DOC-2WORD`（`0x1C1L`）、`DOC-4WORD`（`0x1C2L`）在本页一并说明。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[Length 扩展 TAG]
Payload           总 WORD 数。由 Codec 决定宽度：DOC-1WORD 1，DOC-2WORD 2，DOC-4WORD 4
```

- Codec：Meta `0x1C0L~0x1C2L`，结构类
- Payload：原始值（文档总 WORD 数，unsigned）
- 数量：每个文档一个，位于最前

## 解释与有效性 {#해석과-유효성}

- 长度从开启记录的起点算到 [END](0x1C4L-end.md) 的末尾。
- 使用能容纳该值的最窄宽度。以更宽的宽度编码则作为非规范编码拒绝。
- 长度必须与整个输入相等。一个文档就是一个输入。
- 解码器可以凭此长度跳过整个文档。不存在不知道长度就开启文档的 Codec。
- 计算内容哈希时，去掉验证类 Meta 后按相应长度及与之匹配的宽度重新写出（[内容哈希](../document.md#내용-해시)）。

## 示例 {#예시}

- `0x1C01 0x0017`：DOC-1WORD，总计 23 WORD

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C00/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C0000000000
BODY
#1 DECLARE 0x1C00
#2 FIELD #1 0x0001
#3 BIND #1 "DOC-1WORD"
#4 BIND #2 "count"
```
