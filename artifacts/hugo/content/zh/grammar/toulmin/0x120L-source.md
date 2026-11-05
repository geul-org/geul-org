---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE 是 TOULMIN 文档的原文·分段记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE 是 TOULMIN 文档的原文·分段记录。含义：撰写原文。

| 项目 | 值 |
|---|---|
| 名称 | `SOURCE`（规格文档 BIND `SOURCE`） |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| 规格文档 | `0x00000000/codecs/0x00001200/`（DECLARE 对象 `1200`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 0 |
| Kind | Edge · 系列：TOULMIN 形式，布局：ID, SPAN 宽度 WORD, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 撰写原文 |
| Hugo 侧 | `edge/toulmin/source.md` |

## 布局 {#레이아웃}

撰写原文的整体。所有 SPAN 都是此原文内的字节范围。

```
ID
SPAN 宽度 WORD    高 2 位 = 宽度(00=1, 01=2, 10=4, 11=8 WORD), 其余 14 位 = 0
原文              UTF8-TEXT Value 记录
```

- SOURCE 是 BODY 的第一条记录。每个文档只有一条。
- SPAN 由起始字节和字节数两个字段构成。每个字段是由 SPAN 宽度 WORD 决定宽度（1/2/4/8 WORD）的 unsigned 整数。
- 与依据 Edge [SOURCE](../edge/0x0C0L-source.md)（`0x0C0L`）是不同的 Codec。

- ID 是 Edge Id，REF 是此文档记录的 Edge Id（[TOULMIN](_index.md#공통-필드) 公共字段）。没有 Issuer 和 Codec 编号栏，TAG 之后直接是 Payload。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1200`）。字段声明与 TOULMIN Codec 规格文档一并确定（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [SOURCE 与分段](_index.md#source와-구획), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001200/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
