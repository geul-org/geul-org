---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "声明本版本的施行日。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `EFFECTIVE-FROM`（规格文档 BIND `EFFECTIVE-FROM`） |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| 规格文档 | `0x00000000/codecs/0x00001C80/`（DECLARE 对象 `1C80`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 8 |
| Kind | Meta · 类：定义 |
| TAG WORD | `0001 1100 1000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 本版本的施行日。GREGORIAN-DATE 或 POSIX-TIMESTAMP Value。没有则为公布时刻 |
| Hugo 侧 | `meta/declaration/effective-from.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | 记录 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

声明本版本的施行日。施行日与公布时刻不同（[修订](../document.md#개정)）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[Length 扩展 TAG]
Payload           一个 TIME Value
```

- Codec：Meta `0x1C8L`，定义类
- Payload：内置 Value（[GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) 或 [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md)）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 若没有，则自公布时刻起施行。
- 若有 [EFFECTIVE-UNTIL](0x1C9L-effective-until.md)，则必须早于它。
- 若各条文的施行日不同，则在该条文 Edge 上以 QUALIFIER P580（起始）、P582（结束）另行记录（[SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)）。
- 以某一时点为准解释文档时，读取该值。

## 示例 {#예시}

- 自 1970-01-02 施行：`0x1C83 0x06A2 0x0000 0x0001`

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C80/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
