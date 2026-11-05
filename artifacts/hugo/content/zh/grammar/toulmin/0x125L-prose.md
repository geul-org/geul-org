---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE 是 TOULMIN 文档的原文·分段记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE 是 TOULMIN 文档的原文·分段记录。含义：叙述段落。

| 项目 | 值 |
|---|---|
| 名称 | `PROSE`（规格文档 BIND `PROSE`） |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| 规格文档 | `0x00000000/codecs/0x00001250/`（DECLARE 对象 `1250`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 5 |
| Kind | Edge · 系列：TOULMIN 形式，布局：ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 叙述段落 |
| Hugo 侧 | `edge/toulmin/source.md` |

## 布局 {#레이아웃}

不是规则的叙述段落。只指向原文的范围（SPAN）。

```
ID
SPAN             由 SOURCE 决定的宽度 × 2 (起始字节, 字节数)
```

- ID 是 Edge Id，REF 是此文档记录的 Edge Id（[TOULMIN](_index.md#공통-필드) 公共字段）。没有 Issuer 和 Codec 编号栏，TAG 之后直接是 Payload。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1250`）。SPAN 宽度由 SOURCE 决定，无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [SOURCE 与分段](_index.md#source와-구획), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001250/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
