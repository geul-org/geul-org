---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "记录文档的保存期限。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `RETENTION`（规格文档 BIND `RETENTION`） |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| 规格文档 | `0x00000000/codecs/0x00001E10/`（DECLARE 对象 `1E10`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 1 |
| Kind | Meta · 类：策略 |
| TAG WORD | `0001 1110 0001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 保存期限 |
| Hugo 侧 | `meta/policy/retention.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | 记录 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

记录文档的保存期限。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[Length 扩展 TAG]
Payload           到期时刻（GREGORIAN-DATE 等）或期间（DURATION-SECONDS）
```

- Codec：Meta `0x1E1L`，策略类
- Payload：内置 Value（TIME 系列：[GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) 等，或 [DURATION-SECONDS](../value/0x06DL-duration-seconds.md)）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 若是期间，则从 [RECORDED-AT](0x1D0L-recorded-at.md) 起算。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E10/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
