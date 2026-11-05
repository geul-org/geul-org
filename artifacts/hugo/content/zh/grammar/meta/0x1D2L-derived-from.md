---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "记录本文档派生自其他谱系的文档或资料。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DERIVED-FROM`（规格文档 BIND `DERIVED-FROM`） |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| 规格文档 | `0x00000000/codecs/0x00001D20/`（DECLARE 对象 `1D20`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 18 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 0010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 派生自其他谱系的记录或资料。要固定到外部资料的特定版本时，在 HEAD 的 [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) 上附加原文哈希 QUALIFIER（P4092）（git submodule）。 |
| Hugo 侧 | `meta/lineage/derived-from.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | 记录 | `000F` 章节 0 全部（通配符，Reference）, `020F` 章节 1 全部（通配符，Reference）, `040F` 章节 2 全部（通配符，Reference）, `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

记录本文档派生自其他谱系的文档或资料。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[Length 扩展 TAG]
Payload           Reference，或 SHA-256-DIGEST（内容哈希），或 URI Value
```

- Codec：Meta `0x1D2L`，谱系类
- Payload：内置 Reference 或 Value
- 数量：可有多个

## 解释与有效性 {#해석과-유효성}

- 若派生自 GEUL 文档，则放其内容哈希（[SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)）；若是外部资料，则放 [URI](../value/0x074L-uri.md)。要用哈希固定外部资料的版本，在 HEAD 的 [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) 上附加原文哈希 QUALIFIER（P4092）。
- 记录级的来源由依据 Edge [SOURCE](../edge/0x0C0L-source.md) 负责；移动、拆分、合并之前的旧记录由目标 Edge 的 QUALIFIER P1365（值为旧 Edge Id）负责。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001D20/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
