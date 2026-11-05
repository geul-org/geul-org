---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "贡献权利的确认（git Signed-off-by、DCO）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SIGNED-OFF`（规格文档 BIND `SIGNED-OFF`） |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| 规格文档 | `0x00000000/codecs/0x00001E70/`（DECLARE 对象 `1E70`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 7 |
| Kind | Meta · 类：验证 |
| TAG WORD | `0001 1110 0111 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 贡献权利确认。Reference（git `Signed-off-by`、DCO） |
| Hugo 侧 | `meta/verification/signed-off.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | 记录 | 任意记录（占位标记除外） |  |

这是贡献权利的确认（git `Signed-off-by`、DCO）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[Length 扩展 TAG]
Payload           一个 Reference
```

- Codec：Meta `0x1E7L`，验证类
- Payload：内置 Reference
- 数量：可有多个

## 解释与有效性 {#해석과-유효성}

- geul.org 公布的文档中不放置指向自然人的 Reference（[Issuer 与公布](../issuer.md#geulorg-공표)）。指向组织或 Issuer。例外：通过 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) 指向自然人是允许的。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E70/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
