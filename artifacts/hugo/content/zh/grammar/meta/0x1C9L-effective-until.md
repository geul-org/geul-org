---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "声明本版本有效期的终点（限时法）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `EFFECTIVE-UNTIL`（规格文档 BIND `EFFECTIVE-UNTIL`） |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| 规格文档 | `0x00000000/codecs/0x00001C90/`（DECLARE 对象 `1C90`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 9 |
| Kind | Meta · 类：定义 |
| TAG WORD | `0001 1100 1001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 本版本有效期的终点（限时法）。没有则持续到下一版本施行为止 |
| Hugo 侧 | `meta/declaration/effective-until.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | 记录 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

声明本版本有效期的终点（限时法）。自该时刻起，本版本不再施行。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[Length 扩展 TAG]
Payload           一个 TIME Value
```

- Codec：Meta `0x1C9L`，定义类
- Payload：内置 Value（[GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) 或 [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md)）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 若没有，则持续有效，直到下一版本施行。
- 有效期届满后，没有施行中的版本。旧版本不会复活。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C90/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
