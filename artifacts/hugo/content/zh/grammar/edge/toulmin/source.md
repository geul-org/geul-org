---
title: "SOURCE 与分区"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "书写 TOULMIN 文档的创作原文（SOURCE）、字符串（TEXT）、章节·案件分区（SECTION、CASE-BEGIN、CASE-END）、叙述段落（PROSE）的 GEUL ISSUER 格式 0xC000~0xC005。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

书写 TOULMIN 文档的原文和分区的记录。全部是使用 `ISSUER-1WORD`（`0x7C`）、Issuer `0x0000`（GEUL）之下格式编号的 Edge（[TOULMIN](/zh/grammar/edge/toulmin/#issuer-格式)）。

## 格式

| 格式编号 | 名称 | 布局 |
|---|---|---|
| `0xC000` | SOURCE | ID, SPAN 宽度 WORD, UTF8 Value |
| `0xC001` | TEXT | ID, UTF8 Value |
| `0xC002` | SECTION | ID, 章节码 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF(案件) |
| `0xC004` | CASE-END | ID, REF(案件) |
| `0xC005` | PROSE | ID, SPAN |

- ID 是 Edge Id，REF 是本文档记录的 Edge Id（[TOULMIN](/zh/grammar/edge/toulmin/#公共字段)公共字段）。
- UTF8 Value 是 [UTF8-TEXT](/zh/grammar/value/text/utf8-text/) Value 记录。原样存放字节。

## SOURCE

整个创作原文。所有 SPAN 都是这份原文内的字节范围。

```
ID
SPAN 宽度 WORD    高 2 位 = 宽度(00=1, 01=2, 10=4, 11=8 WORD), 其余 14 位 = 0
原文              UTF8-TEXT Value 记录
```

- SOURCE 是 BODY 的第一条记录。每个文档一个。
- SPAN 有起始字节和字节数两个字段。每个字段是由 SPAN 宽度 WORD 所定宽度（1/2/4/8 WORD）的 unsigned 整数。

## TEXT

一个名称·字符串。NODE 的 F_WITH·F_GROUNDS 列表、LINK 的 LABEL·IMPORTED-FROM 用 REF 指向它。

## SECTION

章节的开始。章节码是 1 WORD。

| 码 | 章节 | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | 条件表达式规则 |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- 不使用 `0`。章节按此码的顺序声明。
- 章节标题是紧接在 SECTION 之后的 PROSE。

## CASE-BEGIN, CASE-END

- 案件的范围是指向同一案件（CASE-DECLARE NODE）的 CASE-BEGIN 与 CASE-END 之间。

## PROSE

不是规则的叙述段落。只指向原文的范围（SPAN）。

## 相关页面

- [TOULMIN](/zh/grammar/edge/toulmin/)、[NODE](/zh/grammar/edge/toulmin/node/)、[LINK](/zh/grammar/edge/toulmin/link/)
