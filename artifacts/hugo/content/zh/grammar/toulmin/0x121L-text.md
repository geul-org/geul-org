---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT 是 TOULMIN 文档的原文·分段记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT 是 TOULMIN 文档的原文·分段记录。含义：名称·字符串。

| 项目 | 值 |
|---|---|
| 名称 | `TEXT`（规格文档 BIND `TEXT`） |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| 规格文档 | `0x00000000/codecs/0x00001210/`（DECLARE 对象 `1210`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 1 |
| Kind | Edge · 系列：TOULMIN 形式，布局：ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 名称·字符串 |
| Hugo 侧 | `edge/toulmin/source.md` |

## 布局 {#레이아웃}

一个名称·字符串。NODE 的 F_WITH·F_GROUNDS 列表，以及 LINK 的 [LABEL](0x134L-label.md)·[IMPORTED-FROM](0x133L-imported-from.md) 通过 REF 指向它。

```
ID
字符串           UTF8-TEXT Value 记录
```

- ID 是 Edge Id，REF 是此文档记录的 Edge Id（[TOULMIN](_index.md#공통-필드) 公共字段）。没有 Issuer 和 Codec 编号栏，TAG 之后直接是 Payload。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1210`）。字段声明与 TOULMIN Codec 规格文档一并确定（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [SOURCE 与分段](_index.md#source와-구획), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001210/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
