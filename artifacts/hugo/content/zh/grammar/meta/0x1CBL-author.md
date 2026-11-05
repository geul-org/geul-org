---
title: "AUTHOR (0x1CBL)"
weight: 459
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "记录撰写文档内容的主体（git author）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `AUTHOR`（规格文档 BIND `AUTHOR`） |
| TAG ID | `0x1CBL` |
| Codec ID | `0x00001CB0` |
| 规格文档 | `0x00000000/codecs/0x00001CB0/`（DECLARE 对象 `1CB0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 11 |
| Kind | Meta · 类：出处 |
| TAG WORD | `0001 1100 1011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 作者。Reference（git author） |
| Hugo 侧 | `meta/provenance/author.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | 记录 | 任意记录（占位标记除外） |  |

记录撰写文档内容的主体（git author）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 1011 LLLL      Codec 0x1CBL
[Length 扩展 TAG]
Payload           一个 Reference 记录 (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL 等)
```

- Codec：Meta `0x1CBL`，出处类
- Payload：内置 Reference
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- Reference 不限定 Codec。人、组织、模型、规则引擎都可以（[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)、[GEUL](../reference/0x00AL-geul.md)、[WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)、[LOCAL](../reference/0x005L-local.md) 等）。
- geul.org 公布的文档中不放置指向自然人的 Reference（[Issuer 与公布](../issuer.md#geulorg-공표)）。指向组织或 Issuer。例外：通过 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) 指向自然人是允许的。
- 若是 LOCAL，则在 BODY 中描述该对象。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001CB0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CB000000000
BODY
#1 DECLARE 0x1CB0
#2 FIELD #1 record
#3 BIND #1 "AUTHOR"
#4 BIND #2 "actor"
```
