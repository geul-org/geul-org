---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "记录整个文档的可信度。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `CONFIDENCE`（规格文档 BIND `CONFIDENCE`） |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| 规格文档 | `0x00000000/codecs/0x00001E80/`（DECLARE 对象 `1E80`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 8 |
| Kind | Meta · 类：验证 |
| TAG WORD | `0001 1110 1000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 可信度 |
| Hugo 侧 | `meta/verification/confidence.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | 记录 | `0690` UNSIGNED-DECIMAL |  |

记录整个文档的可信度。记录级的可信度用附加在目标 Edge 上的 QUALIFIER 表示（属性未定，[SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[Length 扩展 TAG]
Payload           UNSIGNED-DECIMAL Value，0 以上 1 以下
```

- Codec：Meta `0x1E8L`，验证类
- Payload：内置 Value（[UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md)）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 该值由谁评定，用 [GENERATED-BY](0x1D3L-generated-by.md) 等一并记录。

## 未决问题 {#열린-문제}

- 尺度（0~1）与 TOULMIN 判定的关系。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E80/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
