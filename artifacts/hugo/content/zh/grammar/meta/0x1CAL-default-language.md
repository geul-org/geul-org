---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "声明文档文本的默认语言。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DEFAULT-LANGUAGE`（规格文档 BIND `DEFAULT-LANGUAGE`） |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| 规格文档 | `0x00000000/codecs/0x00001CA0/`（DECLARE 对象 `1CA0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 10 |
| Kind | Meta · 类：定义 |
| TAG WORD | `0001 1100 1010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 默认语言 |
| Hugo 侧 | `meta/declaration/default-language.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | 记录 | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

声明文档文本的默认语言。未另行标注语言的文本即为该语言。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[Length 扩展 TAG]
Payload           一个语言 Value
```

- Codec：Meta `0x1CAL`，定义类
- Payload：内置 Value（[LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) 或 [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- TANGEUL 文档要写明撰写所用的区域设置（例：`en`、`ko`）。

## 示例 {#예시}

- `en`：`0x1CA2 0x0761 0x656E`

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001CA0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
