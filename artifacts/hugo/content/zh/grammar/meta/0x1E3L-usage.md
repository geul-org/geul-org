---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "记录使用限制（例：禁止训练，禁止商业使用）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `USAGE`（规格文档 BIND `USAGE`） |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| 规格文档 | `0x00000000/codecs/0x00001E30/`（DECLARE 对象 `1E30`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 3 |
| Kind | Meta · 类：策略 |
| TAG WORD | `0001 1110 0011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 使用限制 |
| Hugo 侧 | `meta/policy/usage.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | 记录 | `000F` 章节 0 全部（通配符，Reference）, `020F` 章节 1 全部（通配符，Reference）, `040F` 章节 2 全部（通配符，Reference）, `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

记录使用限制（例：禁止训练，禁止商业使用）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[Length 扩展 TAG]
Payload           表示使用限制的文本或 Reference
```

- Codec：Meta `0x1E3L`，策略类
- Payload：内置 Value 或 Reference
- 数量：可有多个

## 未决问题 {#열린-문제}

- 限制种类代码表。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E30/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
