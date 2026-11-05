---
title: "CASE-END (0x124L)"
weight: 292
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-END 是 TOULMIN 文档的原文·分段记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-END 是 TOULMIN 文档的原文·分段记录。含义：案件范围结束。

| 项目 | 值 |
|---|---|
| 名称 | `CASE-END`（规格文档 BIND `CASE-END`） |
| TAG ID | `0x124L` |
| Codec ID | `0x00001240` |
| 规格文档 | `0x00000000/codecs/0x00001240/`（DECLARE 对象 `1240`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 4 |
| Kind | Edge · 系列：TOULMIN 形式，布局：ID, REF(案件) |
| TAG WORD | `0001 0010 0100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 案件范围结束 |
| Hugo 侧 | `edge/toulmin/source.md` |

## 布局 {#레이아웃}

案件范围的结束。

```
ID
案件             REF(CASE-DECLARE NODE)
```

- 案件的范围在指向同一案件（[CASE-DECLARE](0x100L-case-declare.md) NODE）的 [CASE-BEGIN](0x123L-case-begin.md) 与 CASE-END 之间。

- ID 是 Edge Id，REF 是此文档记录的 Edge Id（[TOULMIN](_index.md#공통-필드) 公共字段）。没有 Issuer 和 Codec 编号栏，TAG 之后直接是 Payload。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1240`）。字段声明与 TOULMIN Codec 规格文档一并确定（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [SOURCE 与分段](_index.md#source와-구획), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001240/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000124000000000
BODY
#1 DECLARE 0x1240
#2 BIND #1 "CASE-END"
```
