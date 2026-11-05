---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "记录生成文档的主体。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `GENERATED-BY`（规格文档 BIND `GENERATED-BY`） |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| 规格文档 | `0x00000000/codecs/0x00001D30/`（DECLARE 对象 `1D30`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 19 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 0011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 生成主体。人、模型、规则引擎 |
| Hugo 侧 | `meta/lineage/generated-by.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `version` | #5 | 记录 | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT（可选字段） |  |

记录生成文档的主体。人、模型、规则引擎都可以。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[Length 扩展 TAG]
生成主体          Reference（人、模型、规则引擎）
版本              UTF8-TEXT Value，或省略标记 0x0000（可选字段）
```

- Codec：Meta `0x1D3L`，谱系类
- Payload：内置 Reference + 版本文本（可选）
- 数量：可有多个

## 解释与有效性 {#해석과-유효성}

- 若是模型，则一并写明模型版本。
- 不知道版本或不设置版本时，省略该位置并使用 ABSENT（`0x0000`）（[CODEC](../edge/0x0BEL-codec.md) 可选字段）。geul.org 规格 `0x1D30` 是 agent（无 CODEC）与 version（`0720`·`0730`·`0000`）两个记录字段。
- 程序的源码版本（提交）用 [TRANSFORMED-BY](0x1D4L-transformed-by.md) 的格式（摘要，必需）更为准确。GENERATED-BY 的版本以文本记录模型名称、版本之类不是提交 ID 的内容。
- geul.org 公布的文档中不放置指向自然人的 Reference（[Issuer 与公布](../issuer.md#geulorg-공표)）。指向组织或 Issuer。例外：通过 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) 指向自然人是允许的。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001D30/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
